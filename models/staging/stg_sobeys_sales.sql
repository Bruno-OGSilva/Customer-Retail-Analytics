with

source as (

    select * from {{ source('pos', 'raw_sobeys_sales') }}

),

renamend as (
    select
        store_id,
        product,
        `UPC No` as upc_no,
        retail_group,
        CAST(`UPC No` as int) as upc_int,
        CAST(`Dollar Sales All Sales` as float64) as dollar_sales,
        CAST(`Unit Sales All Sales` as int64) as unit_sales,
        CAST(`Time` as date) as week_end_date,
        CONCAT(retail_group, '|', store_id) as unique_store_id,
        CONCAT(retail_group, '|', store_id, '|', `UPC No`) as pod
    from
        source

)

select * from renamend
