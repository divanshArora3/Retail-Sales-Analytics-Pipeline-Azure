# 🛒 Retail Lakehouse & Real-Time Analytics Platform on Azure

A end-to-end modern data engineering project built on Azure, implementing a **Medallion Lakehouse Architecture** with both batch and real-time streaming pipelines — from raw retail data ingestion to Power BI dashboards.

---

## 📌 Problem Statement

A global retail chain (stores + e-commerce) faced:
- **Disconnected systems** — POS, website, warehouse, and IoT sensors operating in silos
- **Delayed reporting** — daily batch jobs with no real-time visibility
- **Poor inventory management** — leading to stock-outs and revenue loss
- **No unified customer insights** — limiting personalization capabilities

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        BATCH LAYER                              │
│  POS / E-commerce / ERP                                         │
│       ↓                                                         │
│  ADF Pipelines (Copy Activity + Integration Runtime)            │
│       ↓                                                         │
│  ADLS Gen2 → Bronze → Silver → Gold                             │
│       ↓                                                         │
│  Azure Synapse Analytics (SQL Pool)                             │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      STREAMING LAYER                            │
│  POS Events / IoT Sensors                                       │
│       ↓                                                         │
│  Azure Event Hub / IoT Hub                                      │
│       ↓                                                         │
│  Spark Structured Streaming (Databricks)                        │
│       ↓                                                         │
│  ADLS Bronze (streaming/) → Silver → Gold (final_sales/)        │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    CONSUMPTION LAYER                            │
│  Synapse SQL Pool → Power BI Dashboards                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🧱 Tech Stack

| Layer | Technology |
|---|---|
| Storage | Azure Data Lake Storage Gen2 |
| Orchestration | Azure Data Factory |
| Processing | Azure Databricks (PySpark) |
| Analytics | Azure Synapse Analytics |
| Streaming | Azure Event Hubs + Spark Structured Streaming |
| Visualization | Power BI |
| Format | Delta Lake |
| Security | Managed Identity, SAS, Private Link |

---

## 📂 ADLS Folder Structure

```
adlsgen2detraining2026/
├── bronze/
│   ├── sales/year=2026/month=04/     # Partitioned raw data (Parquet)
│   ├── streaming/                    # Real-time ingestion (Delta)
│   └── checkpoints/stream/           # Spark streaming checkpoint
├── silver/
│   ├── sales_clean/                  # Cleaned batch data (Delta)
│   └── stream_clean/                 # Cleaned stream data (Delta)
└── gold/
    ├── sales_summary/                # Batch aggregations (Delta)
    ├── stream_summary/               # Stream aggregations (Delta)
    └── final_sales/                  # Unified batch + stream (Delta)
```

---

## 📓 Notebooks

### `bronze.ipynb` — Raw Ingestion
Reads raw `retail_dataset.csv` from ADLS, adds `year`/`month` partition columns from `order_date`, and writes to the Bronze layer as **partitioned Parquet**.

### `silver.ipynb` — Cleaning & Transformation
Reads Bronze Parquet, casts columns (`price`, `quantity`, `total_amount`) to correct types, adds a `processed_at` audit timestamp, and writes to Silver as **Delta format**.

### `gold.ipynb` — Aggregation
Groups Silver data by `product` and `city`, computes `total_sales`, and writes the sales summary to the Gold layer.

### `dk_batch_notebook.ipynb` — Full Batch Pipeline (End-to-End)
Orchestrates the complete Bronze → Silver → Gold flow in a single notebook using PySpark.

### `dk_sparkstreaming.ipynb` — Real-Time Streaming Pipeline
Simulates POS event streams using Spark's `rate` source, processes and writes to Bronze streaming Delta table, cleans to Silver, aggregates to Gold, and **merges batch + stream** into a unified `final_sales` Delta table.

---

## 🗄️ Synapse SQL — `dkscript.sql`

KPI queries powered by Synapse Serverless SQL using `OPENROWSET` over Delta Lake:

- **Total Sales** — aggregate revenue across all products
- **Sales by Product** — breakdown per product category
- **Sales by City** — geographic revenue distribution
- **Top Performing Product** — highest grossing SKU
- **City-wise Ranking** — cities ordered by total sales

A `CREATE VIEW sales_summary` is also defined for Power BI connectivity.

---

## 📊 Power BI Dashboard

The final dashboard (see `PowerBI_Dashboard.pdf`) surfaces key retail KPIs:

| Metric | Value |
|---|---|
| Total Sales | ₹151 Billion |
| Top Product | Tablet |
| Cities Covered | Hyderabad, Chennai, Delhi, Mumbai, Bangalore |

Visuals include sales by product (bar chart) and sales by city (bar chart).

---

## 🔐 Security & Governance

- **Managed Identity** for Databricks ↔ ADLS access (no hardcoded keys in production)
- **SAS Tokens** for scoped, time-limited access
- **Private Link** for secure Databricks networking
- **Encryption at rest** enabled on ADLS Gen2
- **Lifecycle policies** to archive cold data automatically

---

## ⚡ Performance Optimizations

- **Partitioning** by `year`/`month` on Bronze layer for predicate pushdown
- **Delta Lake** format on Silver and Gold for ACID transactions and time travel
- **Hash distribution** on Synapse fact tables
- **Auto-scaling job clusters** on Databricks (no idle compute)
- **Tumbling window aggregations** for real-time stream analytics

---

## 📈 Key Results

- Unified **batch + real-time** data into a single Gold layer (`final_sales/`)
- Enabled sub-minute latency on streaming sales insights
- Replaced daily batch-only reporting with a live Power BI dashboard
- Total pipeline covers **₹151B in retail sales** data across 5 major Indian cities

---

## 🙋 Author

**Divansh** — Built as part of an Azure Data Engineering training capstone project.
