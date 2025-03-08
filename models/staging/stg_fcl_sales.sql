with

source as (

    select * from {{ source('pos', 'raw_fcl_sales') }}

),

renamend as (
    select
        `Store Number` as store_id,
        `Product Name` as product,
        upc as upc_no,
        retail_group,
        `Promotion Type Name` as promo_type,
        CAST(`UPC` as int) as upc_int,
        CAST(`Dollar Sales` as float64) as dollar_sales,
        CAST(`Unit Sales` as int64) as unit_sales,
        CAST(`Week End Date` as date) as week_end_date,
        CONCAT(retail_group, '|', `Store Number`) as unique_store_id,
        CONCAT(retail_group, '|', `Store Number`, '|', `UPC`) as pod
    from
        source

)

select * from renamend
