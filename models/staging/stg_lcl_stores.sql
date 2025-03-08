with

source as (

    select * from {{ source('pos', 'raw_lcl_stores') }}

),

renamed as (
    select
        `Store Name` as store_name,
        `Store No` as store_id,
        division,
        prv as province,
        retail_group,
        case
            when lower(`Store Banner`) = 'nofrills' then 'NoFrills'
            when lower(`Store Banner`) = 'nofrills' then 'NoFrills'
            when lower(`Store Banner`) = 'no name store' then 'no name'
            else `Store Banner`
        end as banner,
        concat(retail_group, '|', `Store No`) as unique_store_id
    from
        source

)

select * from renamed
