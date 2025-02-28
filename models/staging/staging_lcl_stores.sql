with

source as (

    select * from {{ source('pos', 'raw_lcl_stores') }}

),

renamend as (
    select
        `Store Name` as store_name,
        `Store No` as store_id,
        Division as division,
        `Store Banner` as banner,
        Prv as province,
        retail_group,
        CONCAT(retail_group, '|', `Store No`) as unique_store_id
    from
        source

)

select * from renamend
