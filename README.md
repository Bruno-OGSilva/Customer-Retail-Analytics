# **Customer Retail Analytics – ELT Pipeline for Retail POS Data**

![Project Architecture](/assets/Project_Architecture.png)

🚀 **A scalable data pipeline that automates POS data ingestion, transformation, and reporting for category management and retail analytics.**

This project eliminates **manual data extraction and transformation** by integrating **Google BigQuery, DBT, and Power BI**, enabling **faster, more accurate insights** for **category managers and business analysts**.

---

## **📌 Problem Statement**

Category management and insights teams **spend more time extracting and transforming data than analyzing it**. The traditional approach requires:

❌ **Manual data pulls** from multiple retailer POS portals (Loblaw, Sobeys, Metro, etc.)
❌ **Time-consuming transformations** in spreadsheets
❌ **No standardized structure**, making it hard to compare across retailers
❌ **Limited time for actual analysis & strategic decision-making**

This project **solves these inefficiencies** by **automating data workflows**, ensuring that category managers can **focus on insights instead of data wrangling**.

---

## **⚡ Solution Overview**

This pipeline follows a **modern ELT (Extract, Load, Transform) approach**:

1️⃣ **Extract** → Load raw POS data from multiple retailer portals into **Google BigQuery**
2️⃣ **Transform** → Use **DBT** to standardize, clean, and enrich the data
3️⃣ **Load to Power BI** → Create an **interactive dashboard** for category performance analysis

---

## **🛠️ Tech Stack**

✅ **Google BigQuery** → Centralized cloud data warehouse
✅ **DBT (Data Build Tool)** → ELT transformations & data modeling
✅ **Power BI** → Interactive dashboards for decision-making
✅ **Python** → Data ingestion scripts for uploading CSV files
✅ **GitHub** → Version control & collaboration

---

## **📊 Power BI Dashboard Highlights**

The **one-page Power BI dashboard** provides:

✔ **Total Category KPIs** → Dollar Sales, Unit Sales, hL Sales, Average Price, Stores Selling, POD
✔ **Retailer Breakdown** → Performance comparison across different retailers
✔ **YoY Growth Analysis** → Sales & volume trends over time
✔ **Time-Based Analysis** → Weekly trends using retail-specific fiscal calendars

---

## **🛠️ Quick Start Instructions**

### **1 Clone the Repository**
```sh
git clone https://github.com/yourusername/customer-retail-analytics.git
cd customer-retail-analytics

---

### **2️ Set Up Google BigQuery Credentials**
1. Create a **Google Cloud project**
2. Enable **BigQuery API**
3. Download your **service account JSON key** and set the environment variable:
```sh
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your-key.json"
```
---

 ### **3️ Start Poetry**
Then launch Poetry and install the dependencies:
```sh
poetry init
poetry install
```
### **4 Install Additional Dependencies

Add dbt Core, dbt-bigquery, pre-commit, and sqlfluff to your Poetry environment:

```sh
poetry add dbt-core dbt-bigquery
poetry add --dev pre-commit
```
### **5 Setting Up the Project with Pre-commit
In this project, we will use **pre-commit** to ensure that our SQL code and configuration conform to best practices before each commit.

### **6 Configure Pre-commit

Create a `.pre-commit-config.yaml` file in your project root directory with the following content:

```yaml
repos:
- repo: https://github.com/pre-commit/pre-commit-hooks
rev: v4.5.0
hooks:
- id: check-yaml
- id: end-of-file-fixer
- id: trailing-whitespace
- id: requirements-txt-fixer
- repo: https://github.com/charliermarsh/ruff-pre-commit
rev: v0.3.4
hooks:
- id: ruff
args: [--fix, --exit-non-zero-on-fix]
- id: ruff-format
- repo: https://github.com/sqlfluff/sqlfluff
rev: 0.11.2


Then install the pre-commit hooks:

```sh
pre-commit install
```
---

### **7 Upload Historical POS Data to BigQuery**
Run the data ingestion scripts to load raw CSV files into BigQuery:
```sh
python upload_sales_data.py
python upload_store_data.py
```
---

### **8 Set Up & Run DBT Transformations**
- Install **DBT CLI**
- Navigate to the **dbt project folder** and run the transformations:
```sh
cd dbt_project
dbt run
```
### **Run DBT Tests**
To validate the transformations and ensure data integrity, run the following command:
```sh
dbt test
```
---
## **9 Connect Power BI to BigQuery**

To visualize and analyze the transformed data in **Power BI**, follow these steps:

1. **Open Power BI Desktop**
2. **Select** `Google BigQuery` from **Get Data**
3. **Authenticate** using your preferred method:
   - **Organizational Account** → Sign in with your Google credentials
   - **Service Account** → Use your JSON key file to connect
4. **Browse and select the transformed dataset** in BigQuery
5. **Load the data into Power BI** or choose **Transform Data** to modify it in Power Query
6. **Build interactive dashboards** using Power BI visualizations and DAX measures

---

### **🔹 Power BI Integration Benefits**
✅ **Seamless connectivity with BigQuery** for large-scale data analysis
✅ **Real-time insights** with interactive visualizations
✅ **Flexible data modeling** using Power BI’s powerful DAX engine
✅ **Time intelligence features** for YoY comparisons and trend analysis

---

## **💾 Data Structure & Modeling**

This project follows a **layered ELT approach**, ensuring **clean and structured data** for analytics.

### **1️⃣ Raw Data Layer**
📌 Stores **unprocessed POS data** exactly as received from retailer portals.

### **2️⃣ Staging Layer**
📌 **Standardizes formats**, renames columns, and ensures **schema consistency** for accurate downstream processing.

### **3️⃣ Intermediate Layer**
📌 **Applies business logic**, such as:
   - Standardizing **sales schema** across retailers
   - Classifying **stores by channel** (e.g., Discount vs. Conventional)

### **4️⃣ Mart Layer**
📌 **Consolidates final datasets** optimized for **Power BI reporting**, including:
- **Sales Table** → Unified sales transactions from all retailers
- **Stores Table** → Comprehensive list of store attributes
- **Products Table** → Standardized product details
- **Calendar Table** → Custom **time intelligence** structure for accurate YoY and trend analysis

This structured approach ensures **data consistency, scalability, and efficiency** across all analytical workflows.

---

## 💡 Why This Matters?

This project **bridges the gap between data engineering & business insights** by **automating data workflows** and **empowering category teams** with real-time analytics.

**No more manual data prep—just actionable insights.**
