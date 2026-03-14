## System Overview

This project simulates a modern analytics data pipeline for retail transaction data.

The system ingests raw transactional records, performs structured transformations,
applies data quality validations, and produces analytics-ready datasets that
support dashboard reporting and business analysis.

## High-Level Architecture

The pipeline follows a layered data architecture:

Source Layer
Raw Ingestion Layer
Transformation Layer
Analytics Layer
Consumption Layer

Public Dataset
      │
      ▼
Raw Ingestion Layer
      │
      ▼
Data Cleaning & Transformation
      │
      ▼
Analytics Data Model
      │
      ▼
Dashboard / BI Layer


## Data Flow

1. Retail transaction dataset is downloaded from the UCI repository.
2. Raw data is ingested into the raw data layer.
3. SQL transformations standardize and clean the data.
4. Curated fact and dimension tables are generated.
5. Data quality checks validate the transformed datasets.
6. Analytics datasets are consumed by dashboard metrics.
