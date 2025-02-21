with renamend as (
    select
        Geography as store_name,
        Product as product,
        `UPC No` as upc_no,
        CAST(`UPC No` as int) as upc_int,
        CAST(`Dollar Sales All Sales` AS float64) as dollar_sales,
        CAST(`Unit Sales All Sales` AS int64) as unit_sales,
        CAST(`Time` AS DATE) as week_end_date
    from
        {{ref('raw_sobeys_sales')}}

)

select * from renamend
