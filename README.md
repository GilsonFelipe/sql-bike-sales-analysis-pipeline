# 📊 **End-to-End Business Intelligence Pipeline for Bike Sales Analysis**  

# **Project Overview**

This project delivers an end-to-end business intelligence solution that transforms raw sales data from six disparate sources into a strategic narrative to drive decision-making for a bike company. By engineering a robust ETL pipeline and architecting a modern data warehouse, this analysis uncovers the compelling story of a business in a high-growth but precarious phase—exposing critical operational bottlenecks and revenue concentration risks that threaten its long-term stability.

This work moves beyond data analysis to demonstrate a full-cycle business intelligence capability, structured around three core pillars: 

- 🏗️ **Data Engineering & ETL**: Ingesting, cleaning, and validating complex data from multiple sources to create a reliable foundation for analysis. The process addresses significant data quality issues, including historical records, inconsistent formats, and invalid entries.

- 🗄️ **Data Warehousing & Modeling**: Architecting a scalable data warehouse using the Medallion framework (Bronze, Silver, Gold layers) and designing a star schema data model optimized for high-performance analytical queries.

- 📈 **Analytics & Strategic Insights**: Translating the modeled data into actionable business intelligence. The analysis covers customer segmentation, product profitability, and operational efficiency, culminating in six data-driven recommendations to mitigate risk and unlock sustainable growth.

Ultimately, this project showcases a complete cycle of data maturation: from chaotic, raw information to a polished, actionable strategy that can secure a company's financial future.

---

# 📑 **Table of Contents**
 
1. [**Executive Summary**](#executive-summary)
2. [**Recomendations**](#recomendations) 
3. [**Dataset**](#dataset)  
4. [**Analysis Problem**](#analysis-problem)
5. [**Project Workflow**](#project-workflow)
6. [**Tools**](#tools)
7. [**Data Warehouse Architecture**](#data-warehouse-architecture)
8. [**ETL Pipelines**](#etl-pipelines)
    - [**1. Building Bronze Layer**](#1-building-bronze-layer)
    - [**2. Building Silver Layer**](#2-building-silver-layer)
    - [**3. Building Gold Layer**](#3-building-gold-layer)
9. [**Data Analysis, Visualization, and Interpreting Findings**](#data-analysis-visualization-and-interpreting-findings)
10. [**What I Learned**](#what-i-learned)
11. [**Challenges I Faced**](#challenges-i-faced)

> 📌 *You can skip the technical part if you only want to focus on the analysis and insights interpretation*

# **Executive Summary**

This project executed the development of an end-to-end data warehousing and business intelligence solution to conduct a comprehensive performance analysis of a bike company. By building a robust ETL pipeline and a modern Medallion data architecture, raw data from six disparate sources was transformed into a centralized source of truth, enabling a deep dive into the company's sales trends, customer behavior, product performance, and operational efficiency. The analysis uncovers the story of a business in a successful but precarious growth phase, underpinned by high customer loyalty yet exposed to significant concentration risks and a critical internal bottleneck.

The company's growth narrative reveals a strategic pivot in its business model. After a period of stability, sales began to accelerate significantly in late 2012, culminating in a Year-over-Year growth of +180% by 2013. This growth was not driven by higher prices, but by a fundamental shift from a low-volume, high-value model (AOV ~$3,200 in early years) to a high-volume, low-value transaction model (AOV dropping to ~$23 in late 2013). The engine sustaining this high-volume strategy is an exceptionally strong **customer retention rate of 86.52%**, indicating that once acquired, customers are highly likely to make repeat purchases. Sales exhibit clear seasonality, with a slow start in Q1 and Q2 before accelerating mid-year and peaking in December.

Despite a large catalog and customer base, revenue is overwhelmingly concentrated in a few key areas.

- **Product Dependency**: The business is almost entirely dependent on a single category, with **"Bikes" generating 96.46% of total revenue**. Specifically, the **high-cost tier (products > $1,500) accounts for 81.22% of revenue from just 15.87% of orders**. This dependency is so extreme that the **top 10% of products drive 75.55% of all revenue**.

- **Product Lifecycle Risks**: The company's product succession strategy reveals volatile outcomes, amplifying its concentration risk. While the launch of a new Mountain bike successfully replaced its predecessor and drove higher sales, the replacement for a key Road bike model underperformed significantly, causing a net revenue loss for that series. This demonstrates how flawed product transitions can directly erode the company's core revenue streams.

- **Customer Concentration**: A parallel concentration exists within the customer base. The top **10% of customers contribute 40.28% of total revenue**, with the top **28% accounting for a full 80% of sales**. While customer segments by gender are evenly split, married customers drive higher transaction volume whereas single customers have a significantly higher Average Order Value ($522 vs. $456).

- **Geographic Focus**: Over **62% of revenue is generated from just two countries: the United States and Australia**. These markets exhibit different behaviors; the U.S. is a high-volume, lower-AOV market, while Australia is a lower-volume, higher-AOV market, demanding distinct strategic approaches.

This model of relying on a narrow set of high-value products and customers is directly threatened by a major operational inefficiency. The analysis identified an **average order processing time of 7 days**, which is **longer than the average shipping and delivery time of 5 days**. This internal delay in fulfillment poses a significant risk to customer satisfaction, jeopardizing the loyalty of the very segments the company's financial health depends upon. In conclusion, while the company has successfully scaled its revenue through a high-retention, volume-based model, its future stability hinges on mitigating its "double concentration risk" and urgently addressing the critical bottleneck in its order processing pipeline.

> 📌 To see the the deep dive analysis along with the visualization, you can click [`here`](#data-analysis-visualization-and-interpreting-findings)

# **Recomendations**

Based on the analytical findings, the following strategic recommendations are proposed to mitigate risks, optimize operations, and capitalize on growth opportunities:

## 1. **Mitigate Concentration Risk by Nurturing High-Value Segments**

- **Action**: Implement a **VIP program for the top 10% of customers**. Since this small group drives 40% of revenue, targeted engagement through exclusive offers, priority support, and early access to new products is critical for retention.
- **Data-Driven Rationale**: The high dependency on this segment makes their loyalty a strategic 

## 2. **Optimize the Product Portfolio and Sales Strategy**

- **Action**: **Double-down on the high-cost "Bikes" category** while repositioning "Accessories" and "Clothing" as retention and acquisition tools. Use low-cost items in promotional bundles to drive initial bike sales and encourage repeat purchases.

- **Data-Driven Rationale**: With bikes generating 96% of revenue, resources should be focused on this core driver. Low-cost items are more valuable for building customer loyalty than for their direct profit contribution.

## 3. **Improve the Marketing Strategy of New Products to Ensure the Positive Performance**

- **Action**: **Refine the product launch process**. Before retiring a successful product, conduct market testing and ensure the replacement model (e.g., the next "Road" series bike) has validated demand to avoid negative cannibalization.

- **Data-Driven Rationale**: The underperformance of the Road-250 model after replacing the Road-150 highlights the financial risk of flawed product succession.

## 4. **Enhance Operational Efficiency to Improve Customer Experience**

- **Action**: **Conduct a root-cause analysis of the 7-day order processing time**. The goal should be to reduce this internal delay to be significantly shorter than the 5-day delivery time.

- **Data-Driven Rationale**: Long processing times create a poor customer experience and risk jeopardizing the loyalty of all customer segments, especially the high-value buyers who expect premium service. Improving this KPI will directly enhance customer satisfaction and lifetime value.

## 5. **Implement Geographically-Tailored Marketing Campaigns**

- **Action**: **Design distinct marketing strategies for the United States (volume-driven) and Australia (value-driven)**. Focus on bundles and promotions in the U.S. to drive order frequency, while emphasizing premium features and quality in Australia to maximize AOV.

- **Data-Driven Rationale**: These two markets, while contributing equally to revenue, exhibit fundamentally different purchasing behaviors. A one-size-fits-all approach is inefficient.

## 6. **Activate the Long-Tail Customer Base**

- **Action**: **Launch targeted re-engagement campaigns for the ~72% of customers who contribute only 20% of revenue**. Focus on converting one-time buyers into repeat customers with personalized follow-up offers for accessories or complementary products.

- **Data-Driven Rationale**: This segment represents a significant untapped opportunity. A small increase in their average spend or purchase frequency could unlock substantial, diversified revenue growth.

---

# **Dataset**

The dataset was sourced from **datawithbara.com**, consists of **6 interconnected tables** linked via foreign keys. You can see the list of tables and its connection in the diagram below

<p align="center">
  <img src="image/Fig.1 Data Integration Model.png" alt="" />
</p>

<p align="center"><b>Fig.1 Data Integration Model</b></p>

📂 You can access the dataset [`here: dataset`](dataset).

# **Analysis Problem**

The analysis was guided by the following key business questions:  

1. [How are total sales trending over time?](#1-how-are-total-sales-trending-overtime)  
2. [What is the YoY or MoM growth rate?](#2-what-is-the-year-over-year-yoy-or-month-over-month-mom-growth-rate)  
3. [Which months/quarters contribute the most to sales?](#3-which-monthsquarters-contribute-the-most-to-sales-seasonality-analysis)  
4. [What is the Average Order Value (AOV) and how has it changed over time?](#4-what-is-the-average-order-value-aov-and-how-has-it-changed-over-time)  
5. [Who are the top customers by revenue contribution (Pareto 80/20)?](#5-who-are-the-top-customers-by-revenue-contribution-pareto-8020-analysis)  
6. [How do customer segments (marital status, gender) affect behavior?](#6-how-do-customer-segments-marital-status-gender-affect-purchasing-behavior)  
7. [What is the customer retention rate (repeat vs. one-time buyers)?](#7-what-is-the-retention-rate-of-customers-repeat-vs-one-time-buyers)
8. [Are there geographic sales trends?](#8-how-is-the-country-wise-performance)  
9. [Which products generate the highest revenue and profit?](#9-which-products-generate-the-highest-revenue-and-profit-margin)  
10. [Which product categories perform best?](#10-which-product-categories-perform-best-road-bikes-mountain-bikes-components)  
11. [Is there a product cannibalization effect?](#11-is-there-product-cannibalization-new-products-reducing-old-product-sales)
12. [What is the sales mix of high/mid/low-cost products?](#12-what-is-the-distribution-of-high-cost-vs-low-cost-products-in-the-sales-mix)
13. [What is the average order processing and delivery time?](#13-what-is-the-average-order-processing-time-and-delivery-time)  
14. [How concentrated is revenue among top customers?](#14-how-concentrated-is-revenue-among-top-customers)
15. [How concentrated is revenue among top products?](#15-how-concentrated-is-revenue-among-top-products)

> 📌 *Click to navigate*

# **Project Workflow**

This project follows real word data analysis process from raw ad chaos data sources into insightfull business findings. The workflow follows:

1. **Building Data Warehouse Architecture**
2. **ETL Pipelines**
3. **Data Analysis**
4. **Data Visualization**
5. **Interpreting The Results**

> ✅ *Note: Data cleaning, data validation, data integration, and data modeling are embedded within the ETL process.*  

# **Tools**

The following tools were used throughout the project:  

- 🛠️ **SQL** → Core language for ETL, transformation, querying, and analysis.  
- 💻 **SQL Server Management Studio (SSMS)** → IDE for developing and managing SQL scripts.  
- 📊 **Tableau** → Visualization platform for building dashboards and extracting insights.  
- 🌐 **Git & GitHub** → Version control, collaboration, and project tracking.  
- 📝 **Draw.io** → Designing architecture, data models, flows, and diagrams. 

# **Data Warehouse Architecture**

The data architecture follows the **Medallion Architecture** with **Bronze**, **Silver**, and **Gold** layers:

<p align="center">
  <img src="image/Fig.2 DWH Diagram.png" alt="" />
</p>

<p align="center"><b>Fig.2 Data Architecture Diagram </b></p>

The dataset from datasource will be stored in:
- 🥉 **Bronze Layer**: Stores raw data *as-is* from the source systems. Data is ingested from CSV files into SQL Server.  
- 🥈 **Silver Layer**: Cleansed, standardized, and normalized data prepared for analysis.  
- 🥇 **Gold Layer**: Business-ready data modeled into a **star schema** for reporting and analytics.  

The **data warehouse** is built as a database in **SQL Server**, with each layer implemented as **schemas** inside the database.  

# **ETL Pipelines**

## **1. Building Bronze Layer**  

Steps include:  
- 📑 **Table Creation**: All Bronze tables are defined upfront. We create the suitable tables that macth with the quality of data sources.
- 📥 **Data Ingestion**: Source CSV files are loaded via `BULK INSERT`, wrapped in stored procedures for reusability.

## **2. Building Silver Layer**

Steps include:  
- 🧹 **Data Cleaning**: Handling missing values, duplicates, inconsistent keys, and invalid records.  
- ⚖️ **Standardization**: Ensuring consistency in formats (e.g., gender, marital status, dates).  
- 🔗 **Normalization**: Preserving referential integrity across related tables. 

<details>
<summary><code>Expand The Cleaning Process</code></summary>

### **A. crm_cust_info Table**  
Issues found:  
- Missing and duplicates values on primary key.
- Historical records.
- Unwanted spaces in `cst_firstname`, `cst_lastname`.
- Poor standardization in `cst_marital_status` and `cst_gndr`.

🛠️ **Cleaning Approach:** 

- The **missing values of primary key** seems like an error data input, proven by the unlogic record on `cst_key` column, furthermore all the record on the other column is missing too, so we can assume the missing value comes from data record itself. `WHERE` clause will be used to filtered out the data.
- **Duplicates values** seems like caused by **historical record** in the dataset. To handle this, we will use `RANK` as `WINDOW FUNCTION` to rank the data by newest date, so the historical data can be filtered out.
- Unwanted spaces was handled using `TRIM` function.
- `CASE` statement was used to standardizing the data

<details>
<summary><code>Click to Expand the SQL cleaning code</code></summary>

```sql
SELECT
	*
FROM (SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname, --Clean unwanted spaces
	TRIM(cst_lastname) as cst_lastname, --Clean unwanted spaces
	CASE
		WHEN cst_marital_status = 'M' THEN 'Married'
		WHEN cst_marital_status = 'S' THEN 'Single'
		ELSE 'n/a'
	END AS cst_marital_status, --Standardize the data
	CASE
		WHEN cst_gndr = 'M' THEN 'Male'
		WHEN cst_gndr = 'F'	THEN 'Female'
		ELSE 'n/a'
	END AS cst_gndr, --Standardize the data
	cst_create_date,
	RANK() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as newest_data
FROM bronze.crm_cust_info)s
WHERE newest_data = 1 AND cst_id IS NOT NULL --Handling historical and null data
```
</details>

👉 Full process from spotting the error, cleaning, and validation can be accessed [`here: 5.1 Cleaning and Validating silver.crm_cust_info.sql`](<code/scratch/5.1 Cleaning and Validating silver.crm_cust_info.sql>)

### **B. crm_prd_info Table**  
Issues found:  
- 🔗 Combined information in `prd_key`  
- ⚠️ Missing values in `cost` and `prd_line`  
- ⚖️ Poor standardization in `prd_line`  
- ⏳ Invalid data: `prd_start_date` > `prd_end_date` 

🛠️ **Cleaning Approach:** 
- `prd_key` contains 2 dimension: category id and product key. `SUBSTRING` was used to extract those 2 dimesion seperately.
- `ISNULL` was used to handling missing data on `cost` column, and `CASE` statement was used to handle the missing value on `prd_line` while standardizing its data in the same time.
- The invalid date data is caused by the historical data record, we will re-adjust the error `prd_end_dt` using `DATEADD` and `LEAD` function. 

<details>
<summary><code>Click to Expand the SQL cleaning code</code></summary>

```sql
SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as prd_cat_id, --Data enrinchment, extract cat_id form prd_key
	SUBSTRING(prd_key,7, LEN(prd_key) - 6) as prd_key, --Clean the cat_id form prd_key
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost, --Handling null values
	CASE
		WHEN prd_line = 'M' THEN 'Mountain'
		WHEN prd_line = 'R' THEN 'Road'
		WHEN prd_line = 'T' THEN 'Touring'
		WHEN prd_line = 'S' THEN 'Other Sales'
		ELSE 'n/a'
	END AS prd_line, --Data standardization, handling null values
	prd_start_dt,
	DATEADD(DAY, -1, (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))) as prd_end_dt --Handling error data
FROM bronze.crm_prd_info
```
</details>

👉 Full process from spotting the error, cleaning, and validation can be accessed [`here: 5.2 Cleaning and Validating silver.crm_prd_info.sql`](<code/scratch/5.2 Cleaning and Validating silver.crm_prd_info.sql>)

### **C. crm_sales_details Table**  
Issues found:  
- 📅 Invalid date formatting on `sls_order_date` (e.g 0, 5489, etc) which didn't make any sense.  
- 🔢 Wrong data types for date columns  
- ➗ Incorrect calculations (`sls_sales` ≠ `price * quantity`) 

🛠️ **Cleaning Approach:** 
- For invalid date formating in `sls_order_dt`, `CASE` statement was used to handle those bad formating data and transform it into `NULL`
- `CAST` was used to conver the datatype of date data from `NVARCHAR` into `DATE`.
- We will do re-calculation with the help of `CASE` statement to provide a correct calculation for each condition.

<details>
<summary><code>Click to Expand the SQL cleaning code</code></summary>

```sql
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CAST(CAST(CASE
		WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) <> 8 THEN NULL
		ELSE sls_order_dt
	END AS NVARCHAR) AS DATE) as sls_order_dt, --Handling error data and transform dtataype
	CAST(CAST(sls_ship_dt AS nvarchar) AS DATE) AS sls_ship_dt, --Transform datatype
	CAST(CAST(sls_due_dt AS nvarchar) AS date) AS sls_due_dt, --Transform datatype
	CASE
		WHEN sls_sales = 0 THEN ABS(sls_price * sls_quantity)
		WHEN sls_sales < 0 THEN ABS(sls_quantity * sls_price)
		WHEN sls_sales IS NULL THEN ABS(sls_price * sls_quantity)
		WHEN sls_sales <> sls_price * sls_quantity THEN ABS(sls_price * sls_quantity)
		ELSE sls_sales
	END as sls_sales, --Handling uncorrect data
	sls_quantity,
	CASE
		WHEN sls_price = 0 THEN ABS(sls_sales/sls_quantity)
		WHEN sls_price IS NULL THEN ABS(sls_sales/sls_quantity)
		WHEN sls_price < 0 THEN ABS(sls_price)
		ELSE sls_price
	END AS sls_price --Handling uncorrect data
FROM bronze.crm_sales_details
```
</details>

👉 Full process from spotting the error, cleaning, and validation can be accessed [`here: 5.3 Cleaning and Validating silver.crm_sales_details.sql`](<code/scratch/5.3 Cleaning and Validating silver.crm_sales_details.sql>)

### **D. erp_cust_az12 Table**  
Issues found:  
- ✖️ Unwanted characters in `cid`  
- ⏳ Invalid `bdate` values  (e.g. 9999-05-10, 1917-06-05) which didn't make any sense since either its too old or its born from the future.
- ⚖️ Poor standardization in `gen`  

🛠️ **Cleaning Approach:** 
- `REPLACE` function was used to remove extra characters.
- `CASE` statement was used to transform the unlogic date data into `NULL` and handle the poor standardization on `gen` column.

<details>
<summary><code>Click to Expand the SQL cleaning code</code></summary>

```sql
SELECT
	REPLACE(cid, 'NAS', '') AS cid, --Removing extra characters
	CASE
		WHEN bdate >= GETDATE() OR bdate < '1925-01-01' THEN NULL
		ELSE bdate
	END AS bdate, --Handling error value
	CASE
		WHEN TRIM(gen) = 'F' OR TRIM(gen) = 'Female' THEN 'Female'
		WHEN TRIM(gen) = 'M' OR TRIM(gen) = 'Male' THEN 'Male'
		ELSE 'n/a'
	END AS gen --Standardizing the dataset.
FROM bronze.erp_cust_az12
```
</details>

👉 Full process from spotting the error, cleaning, and validation can be accessed [`here: 5.4 Cleaning and Validating silver.erp_cust_az12.sql`](<code/scratch/5.4 Cleaning and Validating silver.erp_cust_az12.sql>)

### **E. erp_loc_a101 Table**  
Issues found:  
- ✖️ Unwanted characters in `cid`  
- ⚖️ Inconsistent standardization in `cntry` (e.g. DE and Germany, USA and United States, etc)

🛠️ **Cleaning Approach:** 
- `REPLACE` was used to clean the unwanted characters in `cid`.
- Applied `CASE` statement for data standardizing in `cntry` column.

<details>
<summary><code>Click to Expand the SQL cleaning code</code></summary>

```sql
SELECT
	REPLACE(cid, '-', '') AS cid, --Removing extra characters
	CASE
		WHEN cntry = 'DE' OR cntry = 'Germany' THEN 'Germany'
		WHEN cntry = 'USA' OR cntry = 'US' OR cntry = 'United States' THEN 'United States'
		WHEN cntry = '' OR cntry IS NULL THEN 'n/a'
		ELSE cntry
	END AS cntry --Standardizing the data
FROM bronze.erp_loc_a101
```
</details>

👉 Full process from spotting the error, cleaning, and validation can be accessed [`here: 5.5 Cleaning and Validating silver.erp_loc_a101.sql`](<code/scratch/5.5 Cleaning and Validating silver.erp_loc_a101.sql>)

### **F. erp_px_cat_giv2 Table**  
✅ No major issues identified.  

👉 Full process from spotting the error, cleaning, and validation can be accessed [`here: 5.6 Cleaning and Validating silver.erp_px_cat_giv2.sql`](<code/scratch/5.6 Cleaning and Validating silver.erp_px_cat_giv2.sql>)

</details>

## **3. Building Gold Layer**  

<p align="center">
  <img src="image/Fig.3 Data Model.png" alt="" />
  <p align="center"><b>Fig.3 Data Model and Marts</b></p>
</p>

The **Gold** layer contains **business-ready data** aggregated from the Silver layer. It is optimized for reporting, dashboards, and BI.  

Key steps:  
- 📐 **Data Modeling**: Designing a **star schema** (fact + dimension tables).  
- 🔗 **Data Integration**: Consolidating data from Silver into facts/dimensions.  
- 🏷️ **Business-Friendly Transformation**: Renaming and restructuring for clarity and usability.  

👉 The Gold layer serves as the **single source of truth** for decision-making.  

<details>
<summary><code>Expand The Data Integration Process</code></summary>

### **A. Data Modeling & Integration**  

The **star schema** includes:  
- **fact_sales**: Sales transactions (order number, date, sales amount, quantity, product, customer)
	
	👉 Full integration process can be accessed [`here: 6.3 Integration process gold.sales_details.sql`](<code/scratch/6.3 Integrating process gold.sales_details.sql>)
	
- **dim_customers**: Customer details (name, country, ID, gender, age, marital status, etc.).  
	
	👉 Full integration process can be accessed [`here: 6.1 Integration process gold.dim_customers.sql`](<code/scratch/6.1 Integrating process gold.dim_customers.sql>)

- **dim_products**: Product details (name, category, cost, release date, etc.).
	
	👉 Full integration process can be accessed [`here: 6.2 Integrating process gold.dim_products.sql`](<code/scratch/6.2 Integrating process gold.dim_products.sql>)

### **B. Loading Data For The Gold Layer**

The **Gold layer** uses **SQL Views** for delivering business-ready data.  

👉 Full DDL scripts for creating Gold views [`here: 6. DDL Gold Layer.sql`](<code/6. DDL Gold Layer.sql>)

# **Data Flow**

All Gold layer objects are derived by **joining Silver tables**. The full flow is illustrated in the data flow diagram. 

<p align="center">
  <img src="image/Fig.4 Data Flow Diagram.png" alt="" />
</p>

<p align="center"><b>Fig.4 Data Flow Diagram</b></p>

</details>

# **Data Analysis, Visualization, and Interpreting Findings**

## **1. How Are Total Sales Trending Overtime?**

<details>
<summary><code>Expand Data Analysis Process</code></summary>

To analyze sales trends over time, we aggregated **total sales** using `SUM(sales)`.  
Since the focus is on **monthly trends**, we extracted the year and month from `order_date` using `YEAR` and `DATENAME`, and abbreviated the month name with `LEFT`.  

⚠️ As month names are stored as `NVARCHAR`, ordering them alphabetically would misrepresent the timeline. To ensure chronological accuracy, `DATEPART` was used to extract the **month number** for sorting.  

📈 A **line chart** was used to visualize the trend. 

```sql
SELECT
	YEAR(order_date) AS year,
	LEFT(DATENAME(MONTH, order_date), 3) AS month,
	SUM(sales) AS total_sales
FROM gold.fact_sales_details
WHERE order_date IS NOT NULL
GROUP BY 
	YEAR(order_date),
	LEFT(DATENAME(MONTH, order_date), 3),
	DATEPART(MONTH, order_date)
ORDER BY YEAR(order_date) ASC, DATEPART(MONTH, order_date) ASC;
```
</details>

![alt text](<image/Fig.5 Sales Trend Overtime.png>)
<p align="center"><b>Fig.5 Sales Trend Overtime</b></p>

### **Insights:**

- 📉 From **late 2010 until mid-2012**, sales stayed **relatively stable**, fluctuating around the **average revenue line (~$0.8M)**.
- 🚀 Starting **late 2012**, there’s a **huge acceleration in growth**, with sales surpassing the long-term average and maintaining an upward trajectory, indicates a **shift in business performance**.
- 🔝 Throughout most of **2013**, revenue consistently outperformed the long-term average, reaching **$1.8M+**, the **highest record** in this trend. It indicates a **maturity phase** where the business scaled its operations effectively.
- ⚠️ At the **end of 2013**, there is an **unusual sudden drop** from **$1.8M+ to only ~$0.04M**.
- 🛑 Based from the data, the unusual drop happen because the **data cutoff issue (incomplete data)**. Its not caused by the actual market collapse.
- ✅ This trend shows the company sales moved from **steady baseline sales** into a **growth phase**, indicating a **success business excution** from the company.

## **2. What is the Year-over-Year (YoY) or Month-over-Month (MoM) Growth Rate?**  

<details>
<summary><code>Expand Data Analysis Process</code></summary>

Growth rates were calculated by comparing sales in the **current period** against the **previous period**, then dividing the difference by the previous sales.  

To achieve this, we used `LAG` to retrieve the previous row’s value. Similar to **#1**, year and month were extracted using `YEAR` and `DATENAME`, with `LEFT` for abbreviations and `DATEPART` for chronological ordering.  

📈 A **line chart** was used to display growth patterns.

```sql
-- Month-over-Month
WITH mom AS (
SELECT
	YEAR(order_date) AS order_year,
	LEFT(DATENAME(MONTH, order_date), 3) AS order_month,
	SUM(sales) AS total_sales,
	SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY YEAR(order_date) ASC, DATEPART(MONTH, order_date) asc) sales_different,
	DATEPART(MONTH, order_date) AS month_number
FROM gold.fact_sales_details
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),
		LEFT(DATENAME(MONTH, order_date), 3),
		DATEPART(MONTH, order_date)
)
SELECT
	order_year,
	order_month,
	total_sales,
	sales_different,
	CAST(ROUND(CAST(sales_different AS float) / CAST(LAG(total_sales) OVER (ORDER BY order_year ASC, month_number ASC) AS float) * 100, 2) AS nvarchar) + '%' AS different_percentage
FROM mom
```
For the Year-over-Year (YoY), we can just remove the `DATEPART(MONTH, order_date)` and `DATENAME(MONTH, order_date)` part.

</details>

![alt text](<image/Fig.6 YoY Growth Rate.png>)
<p align="center"><b>Fig.6 Year-over-Year Growth Rate</b></p>

![alt text](<image/Fig.7 MoM Growth Rate.png>)
<p align="center"><b>Fig.7 Month-over-Month Growth Rate</b></p>

### **Insights:**

- 🔥 The **YoY growth rate** in **2011** shows an **astronomical +16195%**, which directly reflects the **initial sales** after operations began (from nearly zero in 2010).
- 📈 Similarly, the **MoM growth rate** in **Jan 2011 (+982%)** confirms that sales were just starting and scaled rapidly in the first months.
- 💡 This is a natural **“baseline effect”**: since the starting point was very small, any increase looks huge in percentage terms.
- 📉 Both **YoY and MoM** growth in **2012** show declines: **YoY -17%** and **several negative MoM months**. This aligns with the **flat-to-declining sales** trend we saw in **Problem #1 (2011–2012 section)**.
- 🚀 By 2013, sales clearly growing with **YoY growth +180%** and **MoM chart shows more frequent positive growth streaks in 2013**, reinforcing that the growth **was not a one-off**, but a **sustained upward trend**.
- ⚠️ Both charts show a **steep drop at end of 2013 (YoY ~-100%, MoM ~-98%)**, in line with **data incompleteness issue**.

## **3. Which Months/Quarters Contribute the Most to Sales (Seasonality Analysis)?**  

<details>
<summary><code>Expand Data Analysis Process</code></summary>

For seasonality analysis, the month was extracted from `order_date` using `DATENAME`, while total sales was aggregated with `SUM(sales)`.  
To order the months correctly, `DATEPART` was used to sort the output chronologically. 

```sql
SELECT
	DATENAME(MONTH, order_date) AS month,
	SUM(sales)AS total_sales
FROM gold.fact_sales_details
WHERE order_date IS NOT NULL
GROUP BY DATENAME(MONTH, order_date), DATEPART(MONTH, order_date)
ORDER BY DATEPART(MONTH, order_date) ASC
```
</details>

![alt text](<image/Fig.8 Month Seasonality Sales.png>)
<p align="center"><b>Fig.8 Month Seasonality Sales</b></p>

### **Insights:**

- 📉 Monthly sales remain almost flat **($1.7M–$1.9M)** in **Q1 and early Q2**, which explains the **fluctuation** in both **total sales trend** in **Fig.5** and **MoM** Growing Rate in **Fig.7**. Suggests a **seasonal low demand** period or **slower sales momentum** in the **first third of the year**.
- 📈 **A sharp rise** occurs in **June ($2.9M)**, followed by another high in **August ($2.7M)**. Which are consistent with the sales trend rebound in the third year especially on 2013, confirming that **mid-year is when demand accelerates**.
- 🎯 Sales climb again in **Oct ($2.9M)**, Nov **($3.0M)**, and peak in **Dec ($3.2M)** — **the highest month of the year**.
- 🔎 This aligns perfectly with the Sales Trend on **Fig.5**, where the **strongest momentum was in late 2013**.

## **4. What is the Average Order Value (AOV) and How Has It Changed Over Time?**  

<details>
<summary><code>Expand Data Analysis Process</code></summary>

**Average Order Value (AOV)** represents the average amount spent by a customer per order.  
It is calculated by dividing total sales by the number of orders.  

We retrieved year and month using `YEAR` and `DATENAME`, abbreviated with `LEFT`, and applied `DATEPART` for proper chronological order. 

```sql
SELECT
	YEAR(order_date) AS order_year,
	LEFT(DATENAME(MONTH, order_date), 3) AS order_month,
	ROUND(CAST(SUM(sales) AS float) / CAST(COUNT(order_number) AS float), 2) average_order_value
FROM gold.fact_sales_details
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), LEFT(DATENAME(MONTH, order_date), 3), DATEPART(MONTH, order_date)
ORDER BY YEAR(order_date) ASC, DATEPART(MONTH, order_date) ASC
```
</details>

![alt text](<image/Fig.9 Average Order Value Overtime.png>)
<p align="center"><b>Fig.9 AOV Trend Overtime</b></p>

### **Insights:**

- 💰 In **2010–2011**, the **Average Order Value (AOV)** was **very high (~$3,200)**, but **Fig.5** shows that the **overall sales trend** in **Problem #1** was still not significantly high.
- 🔎 It means, in **early year** around **2010–2011**, the revenue is driven by **high-value orders** with **small amount of transaction**.
- 📉 Later year, starting in **2012**, **AOV dropped sharply** below $2,000, then collapsing to below $500 by early 2013, and finally ~$23 in late 2013. But fig **Fig.5** shows that the **overall sales trend** in **Problem #1** have an increasing trends.
- 💡 It means in **later year** around **2012 - 2013**, revenue growth was **no longer driven** by **high-value orders**, but by **a surge in transaction volume**.
- ⚠️ This situation means the margin per transaction is lower than before, the revenue is highly depends on the volume of transaction count. So it have high possibility to increase the operational and logistic cost.
- 🎯 **Minimalizing cost and operation efficiently** is the best way to **maintain and generate higher revenue** since the revenue comes from **massive transaction**, not from **high revenue per transaction**. Focusing on customer retention is another good startegy since repeat purchases is critical in this situation.

## **5. Who Are the Top Customers by Revenue Contribution (Pareto 80/20 Analysis)?**  

<details>
<summary><code>Expand Data Analysis Approach</code></summary>

The **Pareto Principle** suggests that roughly **80% of effects come from 20% of causes**.  
Here, we tested whether **80% of sales revenue** is generated by **20% of customers**.   

To validate this, we:  
- Retrieved **customer key**, **customer name**, and **total sales**.  
- Applied **window functions** to calculate cumulative engagement percentages.  
- Used a **CTE** to structure the query for readability and performance.

```sql
WITH 
pareto AS (
SELECT
	c.customer_key,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	SUM(s.sales) AS revenue_generated
FROM gold.fact_sales_details As s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, CONCAT(c.first_name, ' ', c.last_name)
),
revenue_cont AS (SELECT
	customer_name,
	revenue_generated,
	SUM(revenue_generated) OVER () AS revenue_total,
	CAST(revenue_generated AS float) / CAST(SUM(revenue_generated) OVER () AS float) * 100 AS revenue_contribution
FROM pareto),
pareto_2 AS (
SELECT
	customer_name,
	revenue_generated,
	revenue_total,
	revenue_contribution,
	ROUND(SUM(revenue_contribution) OVER (ORDER BY revenue_generated DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS cumulative_revenue_contribution
FROM revenue_cont
)
SELECT
	ROW_NUMBER() OVER (ORDER BY revenue_generated DESC) AS row_index,
	customer_name,
	revenue_generated,
	revenue_total,
	revenue_contribution,
	CAST(cumulative_revenue_contribution AS nvarchar) + '%' AS cumulative_revenue_contribution
FROM pareto_2
WHERE cumulative_revenue_contribution <= 80
```
</details>

| Row Index | Customer Name  | Revenue Geerated | Revenue Total | Revenue Contribution | Cumulative Revenue Contribution |
|-----------|----------------|-------------------|---------------|----------------------|---------------------------------|
| ...       | ...			 | ...               | ...   	     | ...    			    | ...	                          |
| ...       | ...			 | ...               | ...   	     | ...    			    | ...	                          |
| ...       | ...			 | ...               | ...   	     | ...    			    | ...	                          |
| 5150      | Jordan Sharma  | 2405              | 29356250      | 0.00819246327443     | 79.97%                          |
| 5151      | Natalie Turner | 2405              | 29356250      | 0.00819246327443     | 79.97%                          |
| 5152      | Hannah Jackson | 2405              | 29356250      | 0.00819246327443     | 79.98%                          |
| 5153      | Juan Brooks    | 2405              | 29356250      | 0.00819246327443     | 79.99%                          |
| 5154      | Noah White     | 2405              | 29356250      | 0.00819246327443     | 80.00%                          |

### **Insights:**

- 📊 80% total revenue comes from only **5149 of 18484 total customers**, it means 80% of the total sales of the was generated by only **~28%** of the customer, showing **heavy reliance** on a **small group of high-value customers**.
- 📉 On the other hand, the remaining ~72% of customers only contribute to **20% of revenue**, indicating a **long tail of low-value customers**.
- ⚠️ Losing even a small fraction of the top 28% customers could significantly impact the revenue. So the **Retention of this customer segment is critical**, ensuring satisfaction of this group is a must.
- 💡 The large pool of ~13,335 customers (72.15%) contributes only 20% of revenue, meaning **their average revenue per customer is very low**. It represents **a good growth opportunity**, effective business approaches is fundamental to maximize this opportunity.

## **6. How Do Customer Segments (Marital Status, Gender) Affect Purchasing Behavior?**  

<details>
<summary><code>Expand Data Analysis Approach</code></summary>

The following metrics were analyzed by customer segment:  
- 💰 **Revenue Generated** → `SUM(sales)`  
- 📈 **Profit** → `sales - (quantity * product_cost)`  
- 🧾 **Order Count** → `COUNT(order_number)`  
- 💳 **Average Order Value (AOV)** → Revenue ÷ Order Count  
- 🔎 **Customer Share** → Revenue ÷ Total Revenue  

```sql
WITH gender_segmentation AS(
SELECT
	c.gender AS gender,
	s.sales,
	s.order_number,
	SUM(s.sales) OVER () AS total_revenue,
	COUNT(order_number) OVER () AS total_order
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
WHERE c.gender <> 'n/a'
)
SELECT
	gender,
	SUM(sales) AS revenue_generated,
	COUNT(order_number) AS order_count,
	ROUND(CAST(SUM(sales) AS float)/ CAST(COUNT(order_number) AS float), 2) AS avg_order_value,
	CAST(ROUND(CAST(SUM(sales) AS float) / CAST(total_revenue AS float) * 100, 2) AS nvarchar) + '%' AS customer_share
FROM gender_segmentation
GROUP BY gender, total_revenue, total_order;
```
**for marital status segmentation, change the `gender` column into `marital_status` column*

</details>

| Gender | Revenue Generated | Total Profit | Order Count | AVG Order Value | Revenue Share |
|--------|-------------------|--------------|-------------|-----------------|----------------|
| Male   | 14,522,393        | 5,777,484    | 30,361      | 478.32          | 49.52%         |
| Female | 14,804,168        | 5,896,084    | 30,004      | 493.41          | 50.48%         |

| Marital Status | Revenue Generated | Total Profit | Order Count | AVG Order Value | Revenue Share |
|----------------|-------------------|--------------|-------------|-----------------|----------------|
| Married        | 15,185,985        | 6,062,503    | 33,273      | 456.41          | 51.73%         |
| Single         | 14,170,265        | 5,623,254    | 27,125      | 522.41          | 48.27%         |


### **Insights:**
- 👩‍🦰👨‍🦱 **Revenue and profit** are almost **evenly split between male and female customers**. With Female customers contribute slightly more revenue **($14.8M vs $14.5M)** and profit. This balance implies gender-neutral appeal, meaning marketing should maintain inclusivity rather than favoring one gender.
- 💳 **Female customers** also show a higher **Average Order Value (AOV)** at **$493.41 vs $478.32**, suggesting they **spend more per purchase**.
- **Married customers** generate **higher revenue ($15.2M) and profit ($6.06M)** compared to Singles **($14.2M and $5.62M)**.
- 💍 **Married customers** have **higher order count (33,273) but lower AOV ($456.41)**. In other hand **single customers** have **fewer orders count (27,125) but much higher AOV ($522.41)**.
- 💡 It means the **married customers revenue** comes from a **high in transaction volume, but a low values purchases**. In other hand the **single customers revenue** comes from **higher-value purchases wwith less frequent buyers**.

## **7. What is the Retention Rate of Customers (Repeat vs. One-Time Buyers)?**  

<details>
<summary><code>Expand Data Analysis Approach</code></summary>

**Retention rate** measures the percentage of customers who continue purchasing over a given period, indicating loyalty and satisfaction.  

We calculated it by dividing the number of customers with **more than one order** by the **total number of customers**.  

```sql
WITH
retention_analysis AS (
SELECT
	customer_key,
	COUNT(customer_key) AS total_order_per_customer,
	COUNT(customer_key) OVER() AS total_customers
FROM gold.fact_sales_details
GROUP BY customer_key
),
retention_rate_count AS (
SELECT
	customer_key,
	total_customers,
	CASE
		WHEN total_order_per_customer > 1 THEN 1
		ELSE NULL
	END AS repeat_buyer,
	CASE
		WHEN total_order_per_customer = 1 THEN 1 
	END AS one_time_buyer
FROM retention_analysis
)
SELECT
	COUNT(one_time_buyer) AS one_time_buyer_count,
	COUNT(repeat_buyer) AS repeat_buyer_count,
	CAST(ROUND(CAST(COUNT(repeat_buyer) AS float) / total_customers * 100, 2) AS nvarchar) + '%' AS retention_rate
FROM retention_rate_count
GROUP BY total_customers;
```
</details>

| Count of One Time Purchaser Customer | Count of Repeat Purchaser Customer | Retention Rate |
|-----------------------|--------------------|----------------|
| 2,492                 | 15,992             | 86.52%         |

### **Insights:**

- 🔄 **The retention rate is really high (86.52%)**, with nearly **16,000 repeat buyers** compared to only **~2,500 one-time buyers**, the business shows strong customer loyalty. This indicates that once customers make their first purchase, they are highly likely to return.
- 🎯 Based on the customer concentration showed on **Problem 5** where **~28% of customers generate 80% of revenue**, the high retention rate reinforces the idea that a relatively small but loyal group of customers drives business sustainability.
- 📈 The high retention rate alligns with the findings on **Problem #4** about **AOV** and **Problem #1** about **sales revenue**. High retention rate suggest **there are a lot of repeat transaction that lead to a high volume of orders**. So Despite the decline in **Average Order Value (AOV)** over time, overall **sales revenue has grown (#1)** because repeat buyers are compensating with higher order frequency. This highlights that growth is being driven more by **volume of orders** rather than **high-value transactions**.
- 💡 The findings on **Problem #4** suggest that the company should be maximalize the retention rate since the revenue is driver by **a high volume of transaction**. Based on the retention rate we got, the company has been success to execute this business plan.

## **8. How is the Country-Wise Performance?**  

<details>
<summary><code>Expand Data Analysis Approach</code></summary>

To evaluate geographic performance, the following metrics were compared across countries:  
- 💰 **Revenue Generated** → `SUM(sales)`  
- 📈 **Profit Generated** → `SUM(sales - cost * quantity)`  
- 🧾 **Total Orders** → `COUNT(order_number)`  
- 💳 **Average Order Value (AOV)** → Revenue ÷ Total Orders  
- 🔎 **Revenue Share** → Revenue ÷ Total Revenue  

```sql
WITH country_segmentation AS (
SELECT
	c.country,
	s.sales,
	order_number,
	sales - (s.quantity * p.product_cost) AS profit,
	SUM(s.sales) OVER () AS total_revenue
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE country <> 'n/a'
)
SELECT
	country,
	SUM(sales) AS revenue_generated,
	SUM(profit) AS profit_generated,
	COUNT(order_number) AS order_count,
	ROUND(CAST(SUM(sales) AS float) / CAST(COUNT(order_number) AS float), 2) AS avg_order_value,
	CAST(ROUND(CAST(SUM(sales) AS float) / CAST(total_revenue AS float) * 100, 2) AS nvarchar) + '%' AS customer_share
FROM country_segmentation
GROUP BY country, total_revenue
ORDER BY ROUND(CAST(SUM(sales) AS float) / CAST(total_revenue AS float) * 100, 2) DESC;
```
</details>

| Country        | Revenue Generated | Profit Generated | Order Count | AVG Order Value | Revenue Share |
|----------------|-------------------|------------------|-------------|-----------------|----------------|
| United States  | 9,162,327         | 3,715,394        | 20,473      | 447.53          | 31.45%         |
| Australia      | 9,060,172         | 3,542,133        | 13,345      | 678.92          | 31.10%         |
| United Kingdom | 3,391,376         | 1,342,468        | 6,906       | 491.08          | 11.64%         |
| Germany        | 2,894,066         | 1,147,605        | 5,625       | 514.50          | 9.94%          |
| France         | 2,643,751         | 1,041,862        | 5,558       | 475.67          | 9.08%          |
| Canada         | 1,977,738         | 811,661          | 7,620       | 259.55          | 6.79%          |

### **Insights:**

- 🌍 **United States and Australia** dominate the revenue share by country with approximately **62.55% revenue generated** by those 2 countries alone.
- 🛑 It suggest there is a **major geographic concentration risk**, when either market weakens, company revenue would be heavily impacted. **Prioritizing stability** in these 2 countries is a must to maintain the stability of the company.
- 📊 **Order count** of both **United States and Australia have a big discrepancy (~7K orders)**, but the **revenue generated is nearly the same**. The **Average Order Value** metrics shows that **Australia** have much higher **AOV (~$679)** than the **United States (~$447)**. These facts suggest that even United States and Australia shares nearly same domination on revenue, these two countries have dfferent focus. United States generates the sales via **high volume of orders** , while Australia focus on high **high-value transactions & margin optimization**
- 🍁**Canada** has relatively high order count (~7K orders) compared to the United Kingdom, Germany, and France. But, Canada has the **lowest revenue generated** compared to them with only 6.79% revenue share. The **low AOV (~$260)** can be considered as the reason why this happens, which suggests that canada is a **low value market region**.
- 🌍 **United Kingdom, Germany, and France** have **moderate AOVs ($475–$515)** and contribute a meaningful chunk of revenue **(~30% combined)**. These markets are suitable for targeted expansion (localized marketing, product mix tuning).
- 💡 The finding on **Problem #1** and **Problem #4** state **AOV decreasing over time** while **total revenue rose**. Country-level view explains part of this, growth markets such **United States** are volume-driven, while premium markets such **Australia** sustain high AOV.

## **9. Which Products Generate the Highest Revenue and Profit Margin?**  

<details>
<summary><code>Expand Data Analysis Approach</code></summary>

- 💰 **Revenue** was aggregated using `SUM(sales)`.  
- 📈 **Profit** was calculated as `sales - (cost * quantity)`.  
- Results were ordered by revenue from **highest to lowest**.

```sql
WITH revenue_profit AS (
SELECT
	product_key,
	SUM(sales) AS revenue_generated,
	SUM(quantity) AS total_item_sold
FROM gold.fact_sales_details
GROUP BY product_key
)
SELECT
	p.product_name,
	revenue_generated,
	total_item_sold*p.product_cost AS cost_total,
	revenue_generated - total_item_sold*p.product_cost AS profit_margin
FROM revenue_profit AS rp
LEFT JOIN gold.dim_products AS p
ON rp.product_key = p.product_key
ORDER BY revenue_generated DESC;
```
</details>

![alt text](<image/Fig.10 Revenue Vs. Profit by Product.png>)
<p align="center"><b>Fig.10 Revenue Vs. Profit by Product</b></p>

### **Insights:**

- 📈 The visualization shows a clear **linear upward line**, meaning revenue and profit **margins are consistent and proportonal across products**. Profitability is primarily driven by sales volume rather than different cost/profit ratios.
- 🚴 The top products **Mountain Bike Type**, delivering **the highest revenue (up to $1.4M)** and **highest profit (up to $600K)**, Presenting as the **flagship products**.
- 📉 Majority of other products cluster at the bottom-left with <$200K profit and <$400K revenue. It suggests a **long-tail effect**, where there are many product that can't drive meaningful financial contribution.
- 🎯 Based on **Problem #8** result, it is best to push the flagship product into **High AOV markets** country such **Australia**, and push the lower cost products to **Volume-driven markets** such as **United States and Canada**

## **10. Which Product Categories Perform Best (Road Bikes, Mountain Bikes, Components)?**  

<details>
<summary><code>Expand Data Analysis Approach</code></summary>

The following metrics were used to compare category performance:  
- 💰 **Revenue Generated** → `SUM(sales)`  
- 📈 **Profit Generated** → `SUM(sales - cost * quantity)`  
- 🧾 **Total Orders** → `COUNT(order_number)`  
- 💳 **Average Order Value (AOV)** → Revenue ÷ Total Orders  
- 🔎 **Revenue Share** → Revenue ÷ Total Revenue  

```sql
WITH category_performance AS(
SELECT
	p.category,
	s.sales,
	s.order_number,
	SUM(sales) OVER() AS revenue_total,
	s.sales - p.product_cost*s.quantity AS profit
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
)
SELECT
	category,
	COUNT(order_number) AS total_order,
	SUM(sales) AS revenue_generated,
	SUM(profit) AS profit_generated,
	ROUND(CAST(SUM(sales) AS FLOAT) / CAST(COUNT(order_number) AS FLOAT), 2) AS avg_order_value,
	CAST(ROUND(CAST(SUM(sales) AS FLOAT) / CAST(revenue_total AS FLOAT) * 100, 2) AS nvarchar) + '%' AS revenue_share
FROM category_performance
GROUP BY category, revenue_total
ORDER BY revenue_generated DESC
```
</details>

| Category     | Total Order | Revenue Generated | Profit Generated | AVG Order Value | Revenue Share |
|--------------|-------------|-------------------|------------------|-----------------|----------------|
| Bikes        | 15,205      | 28,316,272        | 11,109,565       | 1,862.30        | 96.46%         |
| Accessories  | 36,092      | 700,262           | 439,510          | 19.40           | 2.39%          |
| Clothing     | 9,101       | 339,716           | 136,682          | 37.33           | 1.16%          |

### **Insights:**

- 🚴 Bikes account for **96.46% of total category share**, generating **$28.3M revenue** and **$11.1M profit**, making them the **core driver of business performance**. Their **average order value (AOV) of $1,862.30** far surpasses Accessories ($19.40) and Clothing ($37.33), highlighting a premium, high-ticket product strategy.
- 📦 **Accessories** have **the highest order volume (36,092 orders)** but contribute only **2.39% of revenue**. **Clothing** faces a similar issue with **9,101 orders** but only **1.16% of revenue share**. Make them serve as **complementary add-ons** rather than revenue drivers. 
- 💰 **The profitability** structure is **heavily concentrated** on **bikes category**. Bikes generated **25x more profit than Accessories despite fewer orders**.
- 🔄 Accessories & Clothing are **essential for retention and cross-sell strategies**, supporting the **86.52% retention rate** found in **Problem #7**. Customers buying high-value Bikes are **likely repeat purchases of accessories/clothing**.

## **11. Is There Product Cannibalization (New Products Reducing Old Product Sales)?**  

<details>
<summary><code>Expand Data Analysis Approach</code></summary>

We compared sales trends of **older products vs. their newer versions** to test for cannibalization:  
- ⛰️ **Mountain-100 Black-42** (Release: 2011-07-01) vs. **Mountain-200 Black-42** (Release: 2013-07-01)  
- 🚴 **Road-150 Red-44** (Release: 2011-07-01) vs. **Road-250 Red-44** (Release: 2012-07-01)  

```sql
-- 1. Mountain-100 Black- 42 (2011-07-01) and Mountain-200 Black- 42 (2013-07-01)
SELECT
	p.product_name,
	YEAR(s.order_date) AS year,
	MONTH(s.order_date) AS month,
	SUM(sales) AS revenue_generated
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE p.product_name IN ('Mountain-100 Black- 42', 'Mountain-200 Black- 42')
GROUP BY p.product_name, YEAR(s.order_date), MONTH(s.order_date)
ORDER BY YEAR(s.order_date) ASC, MONTH(s.order_date) ASC

-- 2. Road-150 Red- 44 (2011-07-01) vs. Road-250 Red- 44 (2012-07-01)
SELECT
	p.product_name,
	YEAR(s.order_date) AS year,
	MONTH(s.order_date) AS month,
	SUM(sales) AS revenue_generated
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE p.product_name IN ('Road-150 Red- 44', 'Road-250 Red- 44')
GROUP BY p.product_name, YEAR(s.order_date), MONTH(s.order_date)
ORDER BY YEAR(s.order_date) ASC, MONTH(s.order_date) ASC
```
</details>

![alt text](<image/Fig.11 Mountain 100 Vs Mountain 200.png>)
<p align="center"><b>Fig.11 Mountain 100 Vs. Mountain 200</b></p>

![alt text](<image/Fig.12 Road 150 Vs Road 250.png>)
<p align="center"><b>Fig.12 Road 150 Vs. Road 250</b></p>

### **Insights:**

- 🔄 For both comparisons (`Mountain-100 Black-42 vs. Mountain-200 Black-42` and `Road-150 Red-44 vs. Road-250 Red-44`), the introduction of the newer model led to a **sharp and permanent decline in the older product’s sales**.
- ✅ **Mountain Series (100 → 200)** suggests a classic **positive cannibalization**. Mountain-200 fully replaced Mountain-100 and delivered **higher revenues**, proving **successful product upgrade adoption**.
- ⚠️ In the other hand,  **Road Series (150 → 250)** shows a signs of **negative cannibalization**. Road-250 replaced Road-150, but its sales performance is **significantly weaker**, leading to an overall **decline in revenue contribution** from this product line.
- 💡 The Road-250 case shows that **not all product launches succeed in growing category revenue**. Poor product–market alignment can turn cannibalization into a **net loss**, where the old product is killed but the new one underperforms. Makes **Pre-launch testing, customer feedback loops, and targeted positioning essential** before retiring successful models.
- 🚨 The findings on **Problem #10** shows **bikes dominate the business (96% share)**, this condition creates a **concentration risk**, failures in specific sub-lines like Road-250 can make **the revenue significantly falls**.
- ⚠️ While there are clear signs of **product substitution (old products phasing out as new ones rise)**, the analysis is affected by **inconsistencies in the product metadata (start_date mismatch)**, where the new product appears in sales data before its official release date. As a result, this **cannibalization effect cannot be confirmed with full confidence**. **Further investigation is recommended by clarifying the metadata with the responsible team in the company**.

## **12. What is the Distribution of High-Cost vs. Low-Cost Products in the Sales Mix?**  

<details>
<summary><code>Expand Data Analysis Approach</code></summary>

Products were segmented by price:  
- 💲 **Low-Cost**: `< 100`  
- ⚖️ **Mid-Cost**: `100 – 1500`  
- 💎 **High-Cost**: `> 1500` 

```sql
WITH price_analysis AS (
SELECT
	CASE
		WHEN s.price < 100 THEN 'Low Cost'
		WHEN s.price >= 100 AND s.price < 1500 THEN 'Mid Cost'
		ELSE'High Cost'
	END AS price_tier,
	s.order_number,
	s.sales,
	s.sales - p.product_cost * s.quantity AS profit,
	SUM(sales) OVER () as revenue_total,
	SUM(s.sales - p.product_cost * s.quantity) OVER () AS profit_total,
	COUNT(order_number) OVER () AS whole_total_order
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
)
SELECT
	price_tier,
	SUM(sales) AS revenue_generated,
	CAST(ROUND(CAST(SUM(sales) AS float) / revenue_total * 100 , 2) AS nvarchar) + '%' AS revenue_share,
	COUNT(order_number) AS number_of_order,
	CAST(ROUND(COUNT(order_number) / CAST(whole_total_order AS float) * 100 ,2) AS nvarchar) + '%' AS total_order_share,
	ROUND(CAST(SUM(sales) AS float) / COUNT(order_number), 2) AS average_order_value,
	SUM(profit) AS total_profit,
	CAST(ROUND(SUM(profit) / CAST(profit_total AS float) * 100, 2) AS nvarchar) + '%' AS profit_share
FROM price_analysis
GROUP BY price_tier, revenue_total, profit_total, whole_total_order
```
</details>

| Proce Segmentation | Revenue Generated | Revenue Share | Number of Order | Total Order Share | AVG Order Value | Total Profit | Profit Share |
|------------|-------------------|----------------|-----------------|-------------------|---------------------|--------------|--------------|
| High Cost  | 23,843,170        | 81.22%         | 9,586           | 15.87%            | 2,487.29            | 9,440,965    | 80.79%       |
| Low Cost   | 961,027           | 3.27%          | 44,616          | 73.87%            | 21.54               | 526,692      | 4.51%        |
| Mid Cost   | 4,552,053         | 15.51%         | 6,196           | 10.26%            | 734.68              | 1,718,100    | 14.70%       |

### **Insights:**

- 💎 Despite representing only **15.87% of total orders**, the **High-Cost tier generates 81.22% of revenue and 80.79% of profit**. This confirms earlier findings (Bikes category dominance in **Problem #10**) that **premium products are the backbone of the business model**.
- 🪙 **Low-Cost** items account for **73.87% of all orders**, yet they only generate **3.27% of revenue and 4.51% of profit**. This indicates that while these products may play a role in customer acquisition, they contribute very **little financial impact**.
- ⚖️ **Mid-Cost** items represent a middle ground, **contributing 15.51% of revenue and 14.7% of profit**. Serve as a **transition tier**, moving customers from low-cost tier to high-cost tier. However, their share is still **minor** compared to high-cost dominance.
- ⚠️ The analysis shows **a small portion of premium products drives the majority of profit**. **Failures in specific product in high-cost can lead to revenue loss**.
- 🎯 **Focussing the business operation on high-cost tier is essential since they are the true revenue engineer**. Combined with the **high retention rate** suggested on **Problem #7**, **premium product retention strategy is critical** due a good loyality level of the customers.

## **13. What is the Average Order Processing Time and Delivery Time?**  

<details>
<summary><code>Expand Data Analysis Approach</code></summary>

- ⏱️ **Order Processing Time** → Avg. days from `order_date` → `ship_date`  
- 🚚 **Delivery Time** → Avg. days from `ship_date` → `due_date`  

```sql
WITH order_efficiency AS (
SELECT
	DATEDIFF(day, order_date, ship_date) AS order_to_ship,
	DATEDIFF(day, ship_date, due_date) AS ship_to_due
FROM gold.fact_sales_details
)
SELECT
	'Order Processing Time' AS indicator,
	AVG(CAST(order_to_ship AS float)) AS avg_in_day
FROM order_efficiency
UNION ALL
SELECT
	'Delivery Time' AS indicator,
	AVG(CAST(ship_to_due AS float))
FROM order_efficiency;
```
</details>

| Metrics             | AVG in Day |
|-----------------------|------------|
| Order Processing Time | 7          |
| Delivery Time         | 5          |

### **Insights:**

- ⏳ The **average order processing time is 7 days**, which is **longer than the delivery time of 5 days**. indicates that **internal inefficiencies** are slowing down the entire fulfillment cycle more than the external logistics itself. **The company is taking too long to prepare a product for shipment.**
- ⚠️ With **73.87% of orders coming from Low-Cost products (Problem #12)**, customers in this segment are likely to be more **price-sensitive and less patient**, which increases the risk of churn if the waiting time feels excessive. **Maximizing the efficiencies** is crucial to maintain the order volume stream.
- 🎯 While the **majority of revenue driven by a small portion of premium products drives (Problem #12)**, inefficiencies order rime processing **the company may risks the loyalty of its most profitable buyers**, so **shortening processing time is essential** to unlock faster revenue recognition and increase repeat purchase cycles, especially in High-Cost tiers.

## **14. How Concentrated is Revenue Among Top Customers?**  

<details>
<summary><code>Expand Data Analysis Approach</code></summary>

This analysis addressed **concentration risk**: whether revenue depends heavily on a few customers.  

- 👤 **Top 1% Customers** → Revenue share held by ~185 customers  
- 👥 **Top 5% Customers** → Revenue share held by ~925 customers  
- 👥 **Top 10% Customers** → Revenue share held by ~1,849 customers  

```sql
WITH 
concentration_risk AS (
SELECT
	c.customer_key,
	SUM(sales) AS revenue_generated
FROM gold.fact_sales_details AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
),
concentration_risk_2 AS (
SELECT
	ROW_NUMBER() OVER (ORDER BY revenue_generated DESC) AS row_index,
	customer_key,
	revenue_generated,
	ROUND(CAST(SUM(revenue_generated) OVER (ORDER BY revenue_generated DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS float) / SUM(revenue_generated) OVER () * 100, 2) AS customer_share_percentage 
FROM concentration_risk
GROUP BY customer_key, revenue_generated
)
SELECT
	'% of revenue from Top 1% customer' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 185
UNION ALL
SELECT TOP 925
	'% of revenue from Top 5% customer' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 925
UNION ALL
SELECT TOP 1849
	'% of revenue from Top 10% customer' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 1849
```
</details>

| % of Customers                             | % of Revenue  |
|------------------------------------|--------|
| % of revenue from Top 1% customer  | 5.62%  |
| % of revenue from Top 5% customer  | 22.49% |
| % of revenue from Top 10% customer | 40.28% |

### **Insights:**
- 📊 The **top 10% of customers contribute 40.28% of total revenue**, with the **top 5% alone contributing nearly a quarter (22.49%)**. While not extreme concentration (since it’s not >50%), this still signals **moderate-to-high dependency** on a small fraction of the customer base.
- 💎 The **top 1% of customers generate 5.62% of revenue**, meaning that losing even a handful of these accounts could cause a **direct hit to revenue stability**. This further amplifies the risk that the company’s **financial backbone rests on a small set of high-value buyers**.
- ⏳ With **order processing time averaging 7 days** showed on **Problem #13**, any delay disproportionately risks the **loyalty of top-tier customers** who are responsible for large revenue contributions. Suggesting the concentration risk is **not just financial, but also operational**, since inefficiencies in service could cause outsized financial damage if top customers churn.
- 💡 While **Low-Cost products dominate in order volume (73.87% of orders)** as showed on **Problem #12**, the **financial health of the company heavily relies on the High-Cost products(~82% of revenue share)**. This means the **top tier customers must be purchase the high-cost product** rather than the low-cost and mid-cost product.
- 🎯 Therefore, the company must be **prioritizing the operational (order processing time and delivery time) on the high-cost product** while still **maintain the low-cost product** since its **critical for sustaining brand visibility and long-term market presence**.

## **15. How Concentrated is Revenue Among Top Products?**  

<details>
<summary><code>Expand Data Analysis Approach</code></summary>

Similar to customer concentration, we analyzed **product-level concentration risk**:  

- 📦 **Top 1% Products** → Revenue share from 3 products  
- 📦 **Top 5% Products** → Revenue share from 15 products  
- 📦 **Top 10% Products** → Revenue share from 30 products 

```sql
WITH 
concentration_risk AS (
SELECT
	p.product_key,
	SUM(sales) AS revenue_generated
FROM gold.dim_products AS p
LEFT JOIN gold.fact_sales_details AS s
ON p.product_key = s.product_key
GROUP BY p.product_key
),
concentration_risk_2 AS (
SELECT
	ROW_NUMBER() OVER (ORDER BY revenue_generated DESC) AS row_index,
	product_key,
	revenue_generated,
	ROUND(CAST(SUM(revenue_generated) OVER (ORDER BY revenue_generated DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS float) / SUM(revenue_generated) OVER () * 100, 2) AS customer_share_percentage 
FROM concentration_risk
GROUP BY product_key, revenue_generated
)
SELECT
	'% of revenue from Top 1% product' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 3
UNION ALL
SELECT TOP 925
	'% of revenue from Top 5% product' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 15
UNION ALL
SELECT TOP 1849
	'% of revenue from Top 10% product' as metric,
	CAST(MAX(customer_share_percentage) AS nvarchar) + '%' AS value
FROM concentration_risk_2
WHERE row_index <= 30;
```
</details>

| % of Products                            |   % of Revenue |
|:----------------------------------|--------:|
| % of revenue from Top 1% product  |  13.88% |
| % of revenue from Top 5% product  |   55.3% |
| % of a revenue from Top 10% product |  75.55% |

### **Insights:**

- ⚠️ There is an **extreme product dependencies**, just **3 products (Top 1%) generate 13.88% of total revenue**. Expanding to **15 products (Top 5%) covers more than half of the revenue (55.3%)**, and **30 products (Top 10%) already contribute 75.55%**. It suggests that despite having a wide catalog, **the company’s financial performance is overwhelmingly driven by a very narrow set of products**.
- 💎 According to the **Problem #12**, this concentration strongly overlaps with the **High-Cost tier** that contributes **81.22% of revenue and 80.79% of profit**, the top performance product must be from High-Cost tier, making the **efficiencies of this tier product extremely important to sustain the financial health of the company**.
- 🚨 Effectively, not only are a **handful of customers** carrying revenue (findings on **Problem #14**), **but a handful of premium products** are doing the same. Together, this creates a **double concentration risk**. Losing just a few key products or their top buyers could drastically destabilize revenue streams.
- ⏳ With an **average order processing time of 7 days** (findings from **Problem #13**), even **minor supply chain or production issues** with these top products could **delay a huge portion of revenue**.
- ⚠️ **The cannibalization effect** showed on **Problem #11** confirms that the **new version of product tend to replace the old product**. **But the sales trend not always better or at least as good as the previous version, some of them are worse then the old one**. It suggests that **retiring the top performance product should be executed perfectly**, a **declining sales trend on the new version of top performance product can leave a massive destruction in the financial health of the company**.

---

# **What I Learned**

Throughout this project, I sharpened my understanding of **Data Warehousing & Business Performance Analysis for a Bike Company**, focusing on customers, products, and operational aspects. It significantly improved my technical skills in **SQL** and **Tableau**, especially in **data warehousing, ETL processes, data architecture, data modeling, data analysis, and visualization**.  

More importantly, this project enhanced my ability to derive **actionable insights** and craft **impactful stories** — turning it from just a *bunch of code* into a project that **explains what truly happens inside the business**.  

💡 Here are some of the most important takeaways:

- 🗄️ **The Importance of Data Warehousing**  
  Data warehousing provides a **centralized, structured, and reliable foundation** for business analysis. Instead of fragmented raw data, it ensures scalability, consistency, and accuracy in decision-making.

- ⚡ **ETL Process Optimization**  
  I learned the value of designing **efficient ETL pipelines** to move data from raw sources to analysis-ready tables. By optimizing tasks such as bulk loading, error handling, and incremental updates, I reduced processing time and improved reliability. A well-structured ETL process is not just about moving data — it’s about ensuring **performance, scalability, and trust in the results**.

- 🧩 **Advanced SQL Usage**  
  Leveraging advanced SQL functions and clauses enabled me to **aggregate, clean, process, and integrate** data more effectively, ensuring both **accuracy** and **optimized performance**.

- 🎯 **Analytical Skills Development**  
  I strengthened my ability to:  
  - Build efficient data warehouses and data models.  
  - Choose the most suitable ETL strategies.  
  - Detect anomalies and relationships in complex data.  
  - Identify the most impactful aspects to analyze.  
  - Design visualizations that maximize clarity.  
  - Translate findings into **actionable business insights**.

- 📖 **The Power of Storytelling**  
  At its core, data is just **raw numbers and text** — abundant but difficult to interpret. To make analysis truly impactful, **storytelling becomes essential**. Instead of simply showing SQL queries or charts, I crafted a **powerfull story** that transformed technical outputs into clear, actionable insights. This ensures even **non-technical stakeholders** can easily understand and use the findings to make better decisions.

---

# **Challenges I Faced**

This project was not without difficulties, but each challenge provided valuable learning opportunities:

- 🔗 **Combining Multiple Data Sources**  
  The analysis involved **six different sources**. Understanding each table and column, mapping relationships, and designing the best integration strategy using keys was essential but challenging.  

- ⚠️ **Poor Data Quality**  
  I encountered numerous issues such as **duplicates, null values, inconsistent formats, historical gaps, and error records**. Handling these required **strategic and creative data-cleaning techniques**.  

- 🔍 **Complex Data Analysis**  
  Defining effective approaches to answer analytical questions was demanding. It pushed me to **think critically and methodically** to achieve reliable results.  

- 📝 **Building a Powerfull Story**  
  The dataset covered multiple aspects of the business. Combining all insights into a **comprehensive narrative** that explained the company holistically was one of the most **challenging yet rewarding** parts of this project. 

--- 