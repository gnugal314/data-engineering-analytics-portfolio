from __future__ import annotations

import json
import logging
from dataclasses import dataclass, asdict
from datetime import datetime, timezone
from pathlib import Path
from typing import List

import pandas as pd


# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

RAW_FILE_PATH = Path("data/raw/online_retail.csv")
PROCESSED_DIR = Path("data/processed")
PROCESSED_FILE_PATH = PROCESSED_DIR / "online_retail_raw_loaded.csv"
METADATA_FILE_PATH = PROCESSED_DIR / "ingestion_metadata.json"

REQUIRED_COLUMNS = [
    "InvoiceNo",
    "StockCode",
    "Description",
    "Quantity",
    "InvoiceDate",
    "UnitPrice",
    "CustomerID",
    "Country",
]


# ------------------------------------------------------------------------------
# Logging
# ------------------------------------------------------------------------------

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s",
)

logger = logging.getLogger(__name__)


# ------------------------------------------------------------------------------
# Data classes
# ------------------------------------------------------------------------------

@dataclass
class IngestionMetadata:
    source_file: str
    processed_file: str
    load_timestamp_utc: str
    row_count_source: int
    row_count_output: int
    required_columns_present: bool
    invoice_date_parse_success: bool
    status: str
    notes: List[str]


# ------------------------------------------------------------------------------
# Utility functions
# ------------------------------------------------------------------------------

def ensure_output_directory(path: Path) -> None:
    """Create the output directory if it does not already exist."""
    path.mkdir(parents=True, exist_ok=True)


def validate_source_file_exists(path: Path) -> None:
    """Raise an error if the raw input file is missing."""
    if not path.exists():
        raise FileNotFoundError(f"Source file not found: {path}")


def load_source_data(path: Path) -> pd.DataFrame:
    """
    Load the source CSV into a pandas DataFrame.

    Returns:
        pd.DataFrame: Loaded source data.
    """
    logger.info("Loading source data from %s", path)
    return pd.read_csv(path, encoding="latin1")


def validate_required_columns(df: pd.DataFrame, required_columns: List[str]) -> bool:
    """
    Check whether all required columns are present.

    Returns:
        bool: True if all required columns exist, False otherwise.
    """
    missing_columns = [col for col in required_columns if col not in df.columns]
    if missing_columns:
        logger.error("Missing required columns: %s", missing_columns)
        return False
    return True


def standardize_column_names(df: pd.DataFrame) -> pd.DataFrame:
    """
    Standardize column names to a consistent format.

    For this project, we preserve the original business-friendly names
    but trim surrounding whitespace.
    """
    df = df.copy()
    df.columns = [col.strip() for col in df.columns]
    return df


def parse_invoice_date(df: pd.DataFrame) -> tuple[pd.DataFrame, bool]:
    """
    Attempt to parse the InvoiceDate column.

    Returns:
        tuple[pd.DataFrame, bool]:
            - Updated DataFrame
            - Whether parsing succeeded without introducing all-null values
    """
    df = df.copy()

    try:
        df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"], errors="coerce")
        parse_success = df["InvoiceDate"].notna().any()
        if not parse_success:
            logger.error("InvoiceDate parsing failed: all values are null after parsing.")
        return df, parse_success
    except Exception as exc:
        logger.exception("Unexpected error while parsing InvoiceDate: %s", exc)
        return df, False


def add_ingestion_metadata_columns(df: pd.DataFrame, source_file: Path) -> pd.DataFrame:
    """
    Add ingestion metadata fields to support traceability.
    """
    df = df.copy()
    load_timestamp = datetime.now(timezone.utc).isoformat()

    df["ingestion_source_file"] = source_file.name
    df["ingestion_load_timestamp_utc"] = load_timestamp
    df["ingestion_batch_id"] = load_timestamp.replace(":", "").replace("-", "")
    return df


def validate_row_count(df: pd.DataFrame) -> bool:
    """
    Ensure the dataset contains at least one record.
    """
    if df.empty:
        logger.error("Loaded dataset is empty.")
        return False
    return True


def write_processed_output(df: pd.DataFrame, output_path: Path) -> None:
    """
    Write the raw-loaded dataset to a processed output location.
    """
    logger.info("Writing processed output to %s", output_path)
    df.to_csv(output_path, index=False)


def write_metadata(metadata: IngestionMetadata, metadata_path: Path) -> None:
    """
    Persist ingestion metadata to JSON.
    """
    logger.info("Writing ingestion metadata to %s", metadata_path)
    with metadata_path.open("w", encoding="utf-8") as f:
        json.dump(asdict(metadata), f, indent=2)


# ------------------------------------------------------------------------------
# Main pipeline
# ------------------------------------------------------------------------------

def run_ingestion_pipeline() -> None:
    """
    Execute the end-to-end ingestion workflow.
    """
    notes: List[str] = []

    try:
        ensure_output_directory(PROCESSED_DIR)
        validate_source_file_exists(RAW_FILE_PATH)

        df = load_source_data(RAW_FILE_PATH)
        source_row_count = len(df)

        if not validate_row_count(df):
            raise ValueError("Source dataset contains zero rows.")

        df = standardize_column_names(df)

        required_columns_present = validate_required_columns(df, REQUIRED_COLUMNS)
        if not required_columns_present:
            raise ValueError("Required columns are missing from source dataset.")

        df, invoice_date_parse_success = parse_invoice_date(df)
        if not invoice_date_parse_success:
            notes.append("InvoiceDate parsing had issues; null values may exist.")

        df = add_ingestion_metadata_columns(df, RAW_FILE_PATH)

        output_row_count = len(df)

        write_processed_output(df, PROCESSED_FILE_PATH)

        metadata = IngestionMetadata(
            source_file=str(RAW_FILE_PATH),
            processed_file=str(PROCESSED_FILE_PATH),
            load_timestamp_utc=datetime.now(timezone.utc).isoformat(),
            row_count_source=source_row_count,
            row_count_output=output_row_count,
            required_columns_present=required_columns_present,
            invoice_date_parse_success=invoice_date_parse_success,
            status="SUCCESS",
            notes=notes,
        )
        write_metadata(metadata, METADATA_FILE_PATH)

        logger.info("Ingestion pipeline completed successfully.")

    except Exception as exc:
        logger.exception("Ingestion pipeline failed: %s", exc)

        failed_metadata = IngestionMetadata(
            source_file=str(RAW_FILE_PATH),
            processed_file=str(PROCESSED_FILE_PATH),
            load_timestamp_utc=datetime.now(timezone.utc).isoformat(),
            row_count_source=0,
            row_count_output=0,
            required_columns_present=False,
            invoice_date_parse_success=False,
            status="FAILED",
            notes=[str(exc)],
        )

        ensure_output_directory(PROCESSED_DIR)
        write_metadata(failed_metadata, METADATA_FILE_PATH)

        raise


if __name__ == "__main__":
    run_ingestion_pipeline()
