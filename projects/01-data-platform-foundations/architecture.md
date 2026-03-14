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
