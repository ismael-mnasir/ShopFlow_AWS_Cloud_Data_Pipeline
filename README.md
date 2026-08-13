# ShopFlow: Automated Event-Driven AWS Cloud Data Pipeline

## Overview

ShopFlow is an end-to-end serverless data pipeline built on Amazon Web Services (AWS) to automate the ingestion, schema discovery, transformation, and analytics of retail sales data. 

The pipeline automatically detects new sales CSV files uploaded to an Amazon S3 bucket, triggers a Python-based AWS Lambda function, runs an AWS Glue ETL job to transform raw tabular data into compressed JSON format, and enables instant ad-hoc SQL querying through Amazon Athena.

---

## 🏗️ Architecture & Data Flow

```text
[ Daily CSV Upload ] ──► [ Amazon S3: raw-data/ ] ──(S3 Event Trigger)──► [ AWS Lambda ]
                               │                                                │
                               ├──► [ AWS Glue Crawler ]                        │ (StartJobRun)
                               │            │                                   ▼
                               │            ▼                           [ AWS Glue ETL Job ]
                               │     [ Glue Data Catalog ]                      │
                               │            │                                   ▼
                               ▼            ▼                           [ Amazon S3: json-data/ ]
                 [ Amazon Athena (SQL Analytics) ]

Data Ingestion (Amazon S3):

Raw sales CSV files are uploaded to s3://ismael-shopflow-2026/raw-data/.

Schema Discovery & Metadata Cataloging (AWS Glue Crawler):

shopflow-crawler automatically scans incoming CSV files, detects column types, and updates the database schema inside the AWS Glue Data Catalog (shopflow_db).

Event Notification & Orchestration (AWS Lambda):

The shopflow-upload-notifier function (Python 3.12, boto3) listens for s3:ObjectCreated:* upload events.

It validates the file extension (.csv) and programmatically initiates the Glue ETL job via StartJobRun.

ETL Transformation (AWS Glue Studio):

sales-etl-job-v2 extracts data from the Data Catalog, converts CSV formatting, and writes Snappy-compressed JSON files to s3://ismael-shopflow-2026/json-data/.

Data Analytics (Amazon Athena):

Provides serverless SQL access over the Data Catalog to analyze product revenue, sales volume, and order trends.

🛠️ Tech Stack & Services Used

Cloud Provider: Amazon Web Services (AWS)

Storage: Amazon S3 (Data Lake)

Compute & Serverless: AWS Lambda (Python 3.12, boto3), AWS Glue (Crawler & Visual ETL)

Analytics Engine: Amazon Athena (SQL)

Security & Governance: AWS IAM (Execution Roles & Least Privilege Access)

Monitoring & Logs: AWS CloudWatch

📊 Sample Analytics & Business Insights

SQL query executed in Amazon Athena to identify top-performing products:

SQL
SELECT 
    product, 
    SUM(CAST(price AS DOUBLE) * CAST(quantity AS INT)) AS total_revenue,
    SUM(CAST(quantity AS INT)) AS total_units_sold
FROM "shopflow_db"."raw_data"
GROUP BY product
ORDER BY total_revenue DESC;

Key Finding: The Standing Desk was the highest revenue-generating product, producing £498.00 in total sales.

🔒 Security & IAM Governance
Lambda Execution Role (shopflow-upload-notifier-role): Configured with scoped permissions allowing s3:GetObject on the raw S3 bucket prefix and glue:StartJobRun on sales-etl-job-v2.

Glue Service Role: Granted full access to S3 data paths and Data Catalog databases under least-privilege principles.

Monitoring: Real-time execution tracking, execution logs, and error debugging via AWS CloudWatch.

📁 Repository Structure
Plaintext
ShopFlow_AWS_Cloud_Data_Pipeline/
├── lambda/
│   └── lambda_function.py      # Python 3.12 S3 event trigger & Glue job orchestrator
├── sql/
│   └── athena_queries.sql      # Analytical SQL queries executed in Amazon Athena
└── README.md                   # Complete project documentation