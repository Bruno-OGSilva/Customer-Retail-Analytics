with

source as (

    select * from {{ source('pos', 'raw_metro_stores') }}

),

renamend as (
    select
        `Store Name` as store_name,
        `Operational Site` as store_id,
        province,
        retail_group,
        case
            when lower(`Banner Description`) = 'food basics' then 'Food Basics'
            else `Banner Description`
        end as banner,
        concat(retail_group, '|', `Operational Site`) as unique_store_id
    from
        source

)

select * from renamend
