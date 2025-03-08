with

source as (

    select * from {{ source('pos', 'raw_product_mf') }}

),

renamend as (
    select
        product,
        upc,
        vendor,
        brand,
        category,
        subcategory,
        item_size,
        item_unit,
        pack_qty,
        CAST(upc as int) as upc_int
    from
        source

)

select * from renamend
