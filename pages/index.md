# Title: Macroeconomic Variables and Their Causal Relationship with Money Laundering

### 💡 Executive Summary: A New Perspective on Financial Risk

This analysis aims to uncover the **causal link** between macroeconomic variables and the incidence of money laundering. By providing actionable insights, this research will empower companies to proactively **mitigate risk** and strengthen their preventive measures.

---

### **1. Initial Exploration of the Global Macro Database (GMD)**
To begin, let's explore the database we'll be working with to better understand its data, its possibilities, and its limitations. This will allow us to avoid unfounded conclusions or poor action plans.

```sql gmd_structure
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'gmd'
ORDER BY ordinal_position;
```

```sql columns_exploration
SELECT
    COUNT(DISTINCT countryname) AS total_countries,
    COUNT(DISTINCT year) AS total_years,
    COUNT(nGDP_USD) AS total_ngdp_records,
    COUNT(rgdp) AS total_rgdp_records,
    COUNT(pop) AS total_pop_records,
    COUNT(cpi) AS total_cpi_records
FROM gmd;
```

At first glance, having data for 245 countries over 945 years seems too good to be true. This issue warrants a double-check to understand it a bit better.

```sql record_per_year
SELECT
    year,
    COUNT(DISTINCT countryname) AS countries_with_data,
    COUNT(*) AS total_records_for_year
FROM
    gmd
GROUP BY
    year
HAVING
    COUNT(DISTINCT countryname) > 30
ORDER BY
    year;
```
From a closer look, we can see that data for more than 30 countries is only available from 1800 onwards. This means that the data before this year is likely to be very sparse and not very useful for our analysis.

Let's take the nGDP_USD variable to understand how nulls are distributed over time and if the database gains completeness as the years go by.


```sql distribution_of_nulls
SELECT
    CASE
        WHEN year >= 1800 AND year < 1850 THEN '1800-1849'
        WHEN year >= 1850 AND year < 1900 THEN '1850-1899'
        WHEN year >= 1900 AND year < 1950 THEN '1900-1949'
        WHEN year >= 1950 AND year < 2000 THEN '1950-1999'
        WHEN year >= 2000 AND year < 2050 THEN '2000-2049'
        ELSE 'Before 1800 or Unknown'
    END AS time_period,
    (SUM(CASE WHEN nGDP_USD IS NULL OR nGDP_USD = 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS ngdp_null_or_zero_percentage
FROM
    gmd
GROUP BY
    time_period
ORDER BY
    time_period;
```

<LineChart  
    data={distribution_of_nulls}
    x=time_period
    y=ngdp_null_or_zero_percentage
    title="Percentage of Null or Zero Data per Period"
    yAxisTitle="Percentage (%)"
    xAxisTitle="Period"
/>
We can observe that as the years passed, the amount of missing data was reduced. This is a favorable development. To conclude our holistic database analysis and begin delving into indicators that could show us a correlation with money laundering, we can check the percentage of missing data for four representative columns.

```sql data_quality_check
SELECT 'nGDP_USD' AS variable,
       (SUM(CASE WHEN nGDP_USD IS NULL OR nGDP_USD = 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS percentage,
       CASE WHEN (SUM(CASE WHEN nGDP_USD IS NULL OR nGDP_USD = 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*) > 50 THEN 'red' ELSE 'green' END AS color_category
FROM gmd
UNION ALL
SELECT 'cpi' AS variable,
       (SUM(CASE WHEN cpi IS NULL OR cpi = 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS percentage,
       CASE WHEN (SUM(CASE WHEN cpi IS NULL OR cpi = 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*) > 50 THEN 'red' ELSE 'green' END AS color_category
FROM gmd
UNION ALL
SELECT 'pop' AS variable,
       (SUM(CASE WHEN pop IS NULL OR pop = 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS percentage,
       CASE WHEN (SUM(CASE WHEN pop IS NULL OR pop = 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*) > 50 THEN 'red' ELSE 'green' END AS color_category
FROM gmd
UNION ALL
SELECT 'rgdp' AS variable,
       (SUM(CASE WHEN rgdp IS NULL OR rgdp = 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS percentage,
       CASE WHEN (SUM(CASE WHEN rgdp IS NULL OR rgdp = 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*) > 50 THEN 'red' ELSE 'green' END AS color_category
FROM gmd
```

<BarChart
    data={data_quality_check}
    x=variable
    y=percentage
    title="Percentage of Null or Zero Data by Variable"
    xAxisTitle="Variable"
    yAxisTitle="Percentage (%)"
    color='red'
/>
In this last case, we can observe that the composite indicators are the ones with the highest number of missing values. This may be due to the fact that they involve greater sophistication, and it's understandable that they only begin to appear more recently.
With this, we conclude our initial exploration of the GMD database. We can now proceed to the next step of our analysis.

------

### **2. Comparing Historical Context: The Evolution of indicators**

We will trace the concept of money laundering back to its origins in the 1920s to contextualize our data analysis. By slicing the data by decades, we can observe how macroeconomic variables provide a better understanding of the money laundering phenomenon.

First, to have a black market, you need an official one. With that in mind, we'll analyze institutional quality indicators to see how they've evolved over time.

```sql institutional_quality_over_time
SELECT
    time_period,
    AVG(CASE WHEN nGDP_USD IS NOT NULL AND nGDP_USD != 0 THEN nGDP_USD END) AS avg_gdp,
    -- Calculates the median (50th percentile) for inflation
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY cpi) AS median_inflation,
    -- Calculates the median (50th percentile) for government spending
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY govexp) AS median_government_spending
FROM (
    SELECT
        year,
        nGDP_USD,
        cpi,
        govexp,
        CASE
            WHEN year >= 1920 AND year < 1930 THEN '1920-1929'
            WHEN year >= 1930 AND year < 1940 THEN '1930-1939'
            WHEN year >= 1940 AND year < 1950 THEN '1940-1949'
            WHEN year >= 1950 AND year < 1960 THEN '1950-1959'
            WHEN year >= 1960 AND year < 1970 THEN '1960-1969'
            WHEN year >= 1970 AND year < 1980 THEN '1970-1979'
            WHEN year >= 1980 AND year < 1990 THEN '1980-1989'
            WHEN year >= 1990 AND year < 2000 THEN '1990-1999'
            WHEN year >= 2000 AND year < 2010 THEN '2000-2009'
            WHEN year >= 2010 AND year < 2020 THEN '2010-2019'
            WHEN year >= 2020 THEN '2020-Present'
            ELSE 'Pre-1920'
        END AS time_period
    FROM gmd
    WHERE
        year >= 1920
        AND nGDP_USD IS NOT NULL AND nGDP_USD != 0
        AND cpi IS NOT NULL AND cpi != 0
        AND govexp IS NOT NULL AND govexp != 0
) AS subquery
GROUP BY
    time_period
ORDER BY
    time_period desc;
```

<LineChart
    data={institutional_quality_over_time}
    x=time_period
    y={['avg_gdp', 'median_inflation', 'median_government_spending']}
    title="Median Macroeconomic Indicators by Decade"
    xAxisTitle="Decade"
    yAxisTitle="Median"
    yAxisOptions={{
      domain: [0,100000]
    }}
/>

An analysis of an economy's margins requires examining the relationship between government spending, inflation, and GDP. A significant rise in inflation and government expenditure not accompanied by a proportional increase in GDP creates a clear opportunity structure for illicit financial flows. This aligns with criminological research on economic crime, which posits that offenders are rational actors who identify and exploit institutional vulnerabilities. Authors like Gary Becker and the broader school of thought on rational choice theory argue that criminal behavior is a function of analyzing costs and benefits. In this context, a weakened macroeconomic framework signals a low-risk environment for activities such as money laundering, as the perceived rewards outweigh the potential costs.

```sql gdp_vs_avg_trade_openness
SELECT
    time_period,
    AVG(CASE WHEN nGDP_USD IS NOT NULL AND nGDP_USD != 0 THEN nGDP_USD END) AS avg_gdp,
    AVG(CASE WHEN exports IS NOT NULL AND imports IS NOT NULL THEN exports + imports END) AS avg_trade_openness
FROM (
    SELECT
        year,
        nGDP_USD,
        exports,
        imports,
        CASE
            WHEN year >= 1920 AND year < 1930 THEN '1920-1929'
            WHEN year >= 1930 AND year < 1940 THEN '1930-1939'
            WHEN year >= 1940 AND year < 1950 THEN '1940-1949'
            WHEN year >= 1950 AND year < 1960 THEN '1950-1959'
            WHEN year >= 1960 AND year < 1970 THEN '1960-1969'
            WHEN year >= 1970 AND year < 1980 THEN '1970-1979'
            WHEN year >= 1980 AND year < 1990 THEN '1980-1989'
            WHEN year >= 1990 AND year < 2000 THEN '1990-1999'
            WHEN year >= 2000 AND year < 2010 THEN '2000-2009'
            WHEN year >= 2010 AND year < 2020 THEN '2010-2019'
            WHEN year >= 2020 THEN '2020-Present'
            ELSE 'Pre-1920'
        END AS time_period
    FROM gmd
    WHERE year >= 1920
) AS subquery
GROUP BY
    time_period
ORDER BY
    time_period desc;
```
<LineChart
    data={gdp_vs_avg_trade_openness}
    x=time_period
    y={['avg_gdp', 'avg_trade_openness']}
    title="Average GDP vs. Trade Openness Over Time"
    xAxisTitle="Década"
    yAxisTitle="Promedio (USD)"
/>
In this case, we can also observe that trade openness has not generated a correlated leap in growth. Despite the significant increase in the exchange of goods and services between countries, this factor has not produced a substantial rise in global GDP.

This phenomenon is critical to our theory as it reveals a fundamental decoupling. If the exchange of goods and services is skyrocketing (indicating more transactions and movement of money) but the formal GDP does not keep pace, this suggests that a portion of that exchange is occurring outside the official system. This gap creates a clear opportunity for money laundering and other illicit activities that thrive on weak regulations and a lack of oversight.

In essence, the growing trade openness acts as a wider channel for the informal economy.

A crucial factor to analyze is also the regional one. For this, we'll select representative countries and compare their data in search of indicative insights that can help us understand economic crime.

```sql regional_comparison
SELECT
    region,
    AVG(CASE WHEN nGDP_USD IS NOT NULL AND nGDP_USD != 0 THEN nGDP_USD END) AS avg_gdp,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY cpi) AS median_inflation
FROM (
    SELECT
        year,
        nGDP_USD,
        cpi,
        CASE
            WHEN countryname IN ('United States', 'Canada', 'Mexico') THEN 'North America'
            WHEN countryname IN ('Argentina', 'Brazil', 'Chile', 'Colombia', 'Venezuela') THEN 'South America'
            WHEN countryname IN ('Germany', 'France', 'United Kingdom', 'Spain', 'Italy') THEN 'Europe'
            WHEN countryname IN ('China', 'Japan', 'India', 'South Korea') THEN 'Asia'
            WHEN countryname IN ('Nigeria', 'South Africa', 'Egypt') THEN 'Africa'
            ELSE 'Other'
        END AS region
    FROM gmd
    WHERE year >= 2010 AND year < 2020
) AS subquery
WHERE
    region != 'Other'
    AND nGDP_USD IS NOT NULL AND nGDP_USD != 0
    AND cpi IS NOT NULL AND cpi != 0
GROUP BY
    region
ORDER BY
    avg_gdp DESC;
```

<ScatterPlot
    data={regional_comparison}
    x=median_inflation
    y=avg_gdp
    size=avg_gdp
    color=region
    facet=region
    title="Average GDP vs. Median Inflation by Region (2010-2019)"
    xAxisTitle="Mediana de Inflación (%)"
    yAxisTitle="Promedio del PIB (USD)"
/>
Here we can see that regions with higher average GDP tend to have lower median inflation rates. This suggests that stronger economies are better at controlling inflation, which is a sign of institutional quality. Conversely, regions with lower GDP often experience higher inflation, indicating economic instability. This instability can create an environment where money laundering and other illicit financial activities are more likely to occur, as individuals and organizations seek to protect their assets from devaluation.

------

### **3. 🛡️ The FATF Risk Database: A Benchmark for Compliance**

An exploration of the Financial Action Task Force's (FATF) risk assessments to establish a critical baseline for our research.

```sql basel_risk_assessment
SELECT * FROM Basel LIMIT 100;
```

------

### **4. 🔗 Connecting the Dots: A Data-Driven Linkage**

The core of our study: merging the GMD and FATF data to reveal patterns and correlations that have previously gone unnoticed.

---

### **5. ✅ Synthesis: Insights, Recommendations, and The Road Ahead**

Presenting our key findings and offering strategic recommendations to transform risk management from reactive to predictive.


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
    SUM(nGDP_USD) as total_gdp_usd_billions,
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

