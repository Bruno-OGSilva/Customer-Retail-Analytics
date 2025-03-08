with date_spine as (
    select date_add(date '2020-01-01', interval day * 1 day) as date
    from
        unnest(generate_array(0, 365 * 6)) as day
),

calendar as (
    select
        date,
        extract(year from date) as year,
        extract(month from date) as month,
        extract(day from date) as day,
        extract(dayofweek from date) as weekday,
        extract(quarter from date) as quarter,
        coalesce(extract(dayofweek from date) in (1, 7), false) as is_weekend,
        format_date('%b', date) as month_name,  -- Jan, Feb, etc.
        format_date('%b/%y', date) as month_year,  -- Jan/22, Feb/22, etc.

        -- Find the Thursday of the current week
        date_sub(date, interval mod(extract(dayofweek from date) - 5, 7) day)
            as week_start,

        -- Add 6 days to get the Wednesday (week-end date)
        date_add(
            date_sub(
                date, interval mod(extract(dayofweek from date) - 5, 7) day
            ),
            interval 6 day
        ) as week_end_date
    from date_spine
)

select
    c.*,
    r.`Week` as w_no,
    r.`Week_Index` as week_index  -- Bringing the 'Week' column from raw_wno
from calendar as c
left join `soft-drink-grocery.raw.raw_wno` as r
    on c.`week_end_date` = date(r.`End Week`)
