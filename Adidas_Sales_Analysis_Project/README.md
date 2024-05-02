# Adidas Sales Data Analysis

This repository hosts SQL scripts designed for the cleaning, exploration, and comprehensive analysis of Adidas sales data. The aim of this project is to unearth patterns and actionable insights that could influence strategic business decisions.

## Table of Contents
- [Introduction](#introduction)
- [Extract, Load, and Transform (ELT)](#extract-load-and-transform-elt)
- [Data Analysis](#data-analysis)
- [Conclusions and Recommendations](#conclusions-and-recommendations)

## Introduction

This project employs a series of structured SQL queries to prepare, analyze, and derive insights from Adidas sales data. These queries are organized into distinct phases: Data Cleaning, Data Exploration, and Data Analysis, each tailored to facilitate comprehensive data understanding and insight generation.

## Extract, Load, and Transform (ELT)

Given the manageable size of the dataset, approximately 10,000 rows, and to accommodate unclear data fields, the data was loaded into a MySQL database. A schema was carefully crafted to support the data integrity and query efficiency before insertion into the database.

## Data Analysis

The analysis phase kicked off by establishing a robust database and sales table schema. Each attribute was scrutinized to identify key performers. This laid the groundwork for addressing five critical business questions through detailed SQL queries:
1. What is the percentage difference in sales between 2020 and 2021?
2. Does sales growth vary by quarter?
3. How do sales trends differ across regions?
4. Which products are most affected by seasonal variations?
5. Which retailers have shown improvement in their sales performance?

## Data Visualization

I used Tableau to build a dashboard to view the total sales across 2021/01/01 to 2021/12/31 and different states. This is an interactive graph. If audiences want to see the breakdown of different sales methods and products, they can also click each state on the map to see it.

<img width="1003" alt="image" src="https://github.com/PomeloWu99/Data-Engineering-Projects/assets/100142240/aa9279ff-0e38-46cc-adfe-e13cf8113cde">


## Conclusions and Recommendations

### Conclusions:
- There was a marked sales increase of approximately 296% from 2020 to 2021.
- Sales in the second and fourth quarters generally lag behind other periods.
- The Midwest region not only saw a significant sales increase by approximately 164% but also expanded its share of total sales, unlike the Northeast and West regions.
- Seasonal effects appeared uniformly across all products, with similar variation coefficients.
- Footwear demonstrated the highest sales in July and August.
- The retailers with the most significant sales improvements were Kohl's, Sports Direct, and Foot Locker.

### Recommendations:
- Intensify promotional activities during July and August, and in the Midwest region.
- Expand business with high-performing retailers such as Kohl's, Sports Direct, and Foot Locker to capitalize on market opportunities.

---

Feel free to dive into the SQL scripts provided in this repository for a deeper analysis. Contributions and suggestions for improvements are welcome.
