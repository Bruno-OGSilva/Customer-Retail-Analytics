{% docs __overview__ %}

# DBT Project Overview: Customer Retail Analytics

This documentation provides an overview of the key models and transformations in the Customer Retail Analytics project. The project is organized into multiple layers, each serving a specific purpose in the data transformation pipeline. This overview page outlines the raw, staging, intermediate, and mart layers, along with a brief description of each model.


## Project Architecture

![image](assets/Project_ Architecture.png)

---

## Project Layers

### Raw Layer
- **Raw Data Ingestion:**
  Raw data is loaded directly from the source systems into tables (e.g., `pos.raw_product_mf`, `pos.raw_discount_banners`, `soft-drink-grocery.raw.raw_wno`). These tables serve as the starting point for all transformations.

### Staging Layer
- **Purpose:**
  Clean and standardize the raw data.

- **Key Models:**
  - **stg_product:**
    Extracts product data from `pos.raw_product_mf` and performs type conversions (e.g., casting UPC to integer) and cleaning.
  - **stg_sobeys_sales, stg_ccl_sales, stg_pfg_sales, stg_metro_sales, stg_fcl_sales:**
    Transform raw sales data for various retail accounts by renaming columns, converting data types, and deriving key identifiers.
  - **stg_ccl_stores, stg_fcl_stores, stg_metro_stores, stg_sobeys_stores:**
    Extract and standardize store data for each retail account.

### Intermediate Layer
- **Purpose:**
  Further refine and enrich the staging data with additional business logic.

- **Key Models:**
  - **Sales Models:**
    - **int_lcl_sales:**
      Refines local sales data by excluding promotional sales columns to ensure a consistent schema.
    - **int_fcl_sales:**
      Processes FCL sales data by removing the `promo_type` column for schema uniformity.
  - **Store Models (Channel Classification):**
    - **int_lcl_stores, int_fcl_stores, int_sobeys_stores, int_ccl_stores, int_pfg_stores, int_metro_stores:**
      Enrich store data by integrating discount banner information. A CASE statement classifies stores into "Discount" or "Conventional" channels based on whether their banner matches a list from the raw discount banners table.

### Mart Layer
- **Purpose:**
  Consolidate and prepare data for reporting and analysis.

- **Key Models:**
  - **sales:**
    Unions sales data from all retail accounts (LCL, FCL, Sobeys, CCL, PFG, Metro) into one comprehensive dataset.
  - **stores:**
    Unions store data from all intermediate store models to create a unified view of all stores.
  - **product:**
    Provides a clean, unified view of product data as transformed in the staging layer.
  - **product_missing:**
    Identifies new product items that have recorded sales but are missing from the product table, serving as a trigger for manual updates to the product dimension.
  - **calendar:**
    Constructs a comprehensive date dimension spanning six years (from January 1, 2020). This model generates a date spine, extracts date attributes (year, month, day, weekday, quarter), calculates week boundaries based on business logic, and joins with raw week number data to integrate business-specific week numbers and indices.

---

## Summary of Key Transformations

- **Data Standardization:**
  Across staging models, raw columns are renamed, and data types are cast (e.g., UPC to integer) to ensure consistency.

- **Data Enrichment:**
  Intermediate models add business logic such as sales channel classification (Discount vs. Conventional) based on discount banner information.

- **Data Consolidation:**
  Mart models combine datasets from multiple retail accounts using UNION ALL to create unified views for sales, stores, products, and a calendar dimension.

- **Calendar Dimension:**
  The calendar model is enriched with detailed date attributes and custom week calculations, forming a robust foundation for time-series analysis and reporting.

---

## Conclusion
This overview summarizes the structure and key transformations of the Customer Retail Analytics dbt project. Each model, from raw ingestion to the final mart layer, is designed to incrementally transform and enrich the data, ensuring that downstream reports and analyses are built on clean, consistent, and business-aligned datasets.

For detailed documentation on each model, please refer to the individual `.md` files generated for every model.



{% enddocs %}
