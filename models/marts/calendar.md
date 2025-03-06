# Mart Model: calendar

## Overview
The `calendar` model constructs a comprehensive date dimension that spans a six-year period starting from January 1, 2020. This model generates a date spine and then enriches it by extracting key date components (year, month, day, weekday, quarter) and calculating additional attributes such as the month name, month/year combination, week start, and week end dates. Finally, it joins this enriched calendar with a raw week number table (`raw_wno`) to incorporate the business-specific week identifier (`w_no`).

## Source Data
- **Generated Date Spine:**
  - The model creates a date spine by generating an array of numbers (from 0 to 365*6) and adding each as days to the start date `2020-01-01`.

- **Raw Week Number Data:**
  - The raw table `soft-drink-grocery.raw.raw_wno` is used to bring in the `Week` column, which is aliased as `w_no`. This table provides the week numbers corresponding to specific week end dates.

## Transformations Applied
### Date Spine Generation
- **Date Calculation:**
  The `date_spine` CTE uses `generate_array(0, 365*6)` to create a series of integers representing days, which are then added to the base date `2020-01-01` to form a continuous series of dates.

### Calendar Enrichment
- **Extracting Date Components:**
  The `calendar` CTE extracts:
  - **Year, Month, and Day:** Using the `extract()` function.
  - **Weekday:** Using `extract(dayofweek from date)`.
  - **Quarter:** Using `extract(quarter from date)`.

- **Flagging Weekends:**
  - The model sets an `is_weekend` flag by checking if the weekday is either 1 or 7.

- **Formatting Date Values:**
  - **Month Name:** Formatted as abbreviated month names (e.g., Jan, Feb).
  - **Month/Year Combination:** Formatted as `Mon/yy` (e.g., Jan/22).

- **Calculating Week Boundaries:**
  - **Week Start:**
    The model calculates the start of the week (using Thursday as a reference) by subtracting an interval from the current date.
  - **Week End Date:**
    Derived by adding 6 days to the computed week start, marking the end of the week (Wednesday).

### Joining Raw Week Data
- **Week Number Integration:**
  The final step joins the enriched calendar with the `raw_wno` table:
  - A left join is performed on the condition that the calculated `week_end_date` matches the date value from `raw_wno` (converted appropriately).
  - The `Week` column from `raw_wno` is then included in the final output as `w_no`.

## Business Logic & Rationale
- **Time-Series Analysis Foundation:**
  The calendar model provides a robust date dimension critical for time-based reporting and analytics.

- **Standardized Date Attributes:**
  Extracting and formatting various date parts (e.g., year, month, weekday) allows for consistent slicing and dicing of data across reports.

- **Customized Week Boundaries:**
  By calculating week start and end dates based on business logic (using Thursday as the reference), the model aligns with organizational reporting standards.

- **Integration with Business Week Numbers:**
  The join with the `raw_wno` table ensures that the calendar dimension is synchronized with business-specific week identifiers, which may be used across multiple datasets.

## Dependencies & Testing Considerations
- **Source Dependencies:**
  - The model depends on the successful generation of the date spine.
  - It relies on the raw week number table (`soft-drink-grocery.raw.raw_wno`) to supply the correct week numbers.

- **Testing Recommendations:**
  - **Date Range Verification:** Ensure the date spine covers the full six-year period from January 1, 2020.
  - **Date Component Accuracy:** Validate that extracted components (year, month, day, weekday, quarter) match the expected values.
  - **Week Boundary Calculations:** Confirm that the computed `week_start` and `week_end_date` accurately represent the business-defined week.
  - **Join Integrity:** Verify that the left join correctly appends the `w_no` value from the `raw_wno` table based on the matching `week_end_date`.

## Conclusion
The `calendar` mart model serves as a foundational dimension for time-series analysis, delivering a fully enriched and standardized date table. By integrating detailed date components and aligning week boundaries with business-specific logic, this model ensures that downstream reports and analytics have access to consistent and accurate temporal data.
