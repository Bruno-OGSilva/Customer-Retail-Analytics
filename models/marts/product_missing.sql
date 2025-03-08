with product as (
    select * from {{ ref('stg_product') }}
),

sales as (
    select * from {{ ref('sales') }}
),

product_missing as (
    select
        a.product,
        a.upc_no,
        a.retail_group,
        b.brand
    from sales as a
    left join product as b
        on a.`upc_no` = b.`upc`
    where b.brand is null
)

select * from product_missing
