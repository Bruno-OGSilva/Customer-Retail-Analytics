with

source as (

    select * from {{ source('pos', 'raw_metro_sales') }}

),

renamend as (
    select
        `Store No` as store_id,
        product,
        `UPC ID` as upc_no,
        retail_group,
        CAST(`UPC ID` as int) as upc_int,
        CAST(`Dollar Sales` as float64) as dollar_sales,
        CAST(`Unit Sales` as int64) as unit_sales,
        PARSE_DATE('%m/%d/%Y', `Week End Date`) as week_end_date,
        CONCAT(retail_group, '|', `Store No`) as unique_store_id,
        CONCAT(retail_group, '|', `Store No`, '|', `UPC ID`) as pod
    from
        source

)

select * from renamend
