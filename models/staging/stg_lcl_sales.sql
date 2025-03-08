with

source as (

    select * from {{ source('pos', 'raw_lcl_sales') }}

),

renamend as (
    select
        `Site Number` as store_id,
        upc_description as product,
        `UPC` as upc_no,
        retail_group,
        CAST(`UPC` as int) as upc_int,
        CAST(REPLACE(REPLACE(`Sales`, '$', ''), ',', '') as float64)
            as dollar_sales,
        CAST(`Units` as int64) as unit_sales,
        CAST(REPLACE(REPLACE(`Promo Sales`, '$', ''), ',', '') as float64)
            as promo_dollar_sales,
        CAST(`Promo Units` as int64) as promo_unit_sales,
        CAST(`Week End Date` as date) as week_end_date,
        CONCAT(retail_group, '|', `Site Number`) as unique_store_id,
        CONCAT(retail_group, '|', `Site Number`, '|', `UPC`) as pod
    from
        source

)

select * from renamend
