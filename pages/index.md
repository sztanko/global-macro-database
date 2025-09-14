---
title: Macroeconomic Variables and Their Causal Relationship with Money Laundering

description: Analysis of insight from the Global Macro Database (GMD) to understand how macroeconomic variables influence money laundering activities.
---


# Global GDP Trends Since 1900
<LastRefreshed prefix="Data last updated"/>

This dashboard analyzes global GDP data from the Global Macro Database, showing aggregate GDP trends across all countries since 1900.

```sql global_gdp_by_year
SELECT 
    year,
    AVG(nGDP_USD) as avg_gdp_usd_billions,
    COUNT(countryname) as countries_with_data
FROM gmd 
WHERE year >= 1900 
    AND nGDP_USD IS NOT NULL 
    AND nGDP_USD > 0
GROUP BY year 
ORDER BY year
```

## Total Global GDP in USD (Billions) Since 19

<LineChart 
    data={global_gdp_by_year}
    x=year
    y=total_gdp_usd_billions
    title="Global GDP in USD (Billions)"
    yAxisTitle="GDP (Billions USD)"
    xAxisTitle="Year"
    yFmt="#,##0,,"
/>

### Key Statistics

- **Countries in Dataset**: <Value data={global_gdp_by_year} column=countries_with_data agg=max/> countries have GDP data
- **Latest Year GDP**: $<Value data={global_gdp_by_year} column=total_gdp_usd_billions agg=max fmt="#,##0,,"/> trillion USD
- **Data Coverage**: <Value data={global_gdp_by_year} column=year agg=min/> - <Value data={global_gdp_by_year} column=year agg=max/>

