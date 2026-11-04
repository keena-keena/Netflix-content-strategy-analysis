/*
Project: Netflix Content Strategy & Catalog Analysis (2000-2021)
Database: SQLite (netflix.csv, 8,807 rows)
Author: Keerthana R
*/

--Q1. Baseline Catalog Count
--Question : What is the overall split of Movie vs TV Shows in the catalog?
--Concepts: COUNT(*),GROUP BY 
--Result : Movie: 6,131 (69.6%) | TV Show: 2,676 (30.4%) | Total: 8,807

Select
 type,
 COUNT(*) AS total_count,
 ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM netflix),1) as pct_share
FROM netflix
GROUP BY type;

--Q2. Movie vs TV split inside each bucket
--Question : Within each bucket, what share of titles are TV Shows?
--Concepts : SUM(CASE..),conditional aggregation,ROUND
--Result : New (3619/2037) - 36.0%,Recent (2036/590)-22.5%,Old(476/49)-9.3%

WITH cte AS (
  SELECT
    type,
    CASE WHEN release_year < 2000 THEN 'Old'
         WHEN release_year BETWEEN 2000 AND 2015 THEN 'Recent'
         WHEN release_year > 2015 THEN 'New'
         ELSE 'Unknown'
    END AS label
  FROM netflix
)
SELECT
  label,
  SUM(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) AS movies,
  SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS tv_shows,
  COUNT(*) AS total,
  ROUND(100.0 * SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) / COUNT(*), 1) AS tv_share_pct
FROM cte
GROUP BY label
ORDER BY total DESC;

--Q2A. TV Share by release year
--Question : Is the rise in TV share steady and was the 2018 peak drive by the TV Share?
--Concepts : Conditional aggregation,where ,ORDER BY
--Result : TV Share - 2010(20.6%), 2017(25.7%),2018(33.1%),2020(45.8%),2021 (53.1%).Movies were 767 in both 2017 and 2018; TV shows rose from 265 to 380
--Note: The 2018 jump of +115 titles came entirely from TV shows,2021 is a partial year, so compare its share,not its count

WITH cte AS (
  SELECT
    type,
    CASE WHEN release_year < 2000 THEN 'Old'
         WHEN release_year BETWEEN 2000 AND 2015 THEN 'Recent'
         WHEN release_year > 2015 THEN 'New'
         ELSE 'Unknown'
    END AS label
  FROM netflix
)
SELECT
  label,
  SUM(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) AS movies,
  SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS tv_shows,
  COUNT(*) AS total,
  ROUND(100.0 * SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) / COUNT(*), 1) AS tv_share_pct
FROM cte
GROUP BY label
ORDER BY total DESC;

--Q3. Movies vs TV shows per country
--Question : which countries have the most titles, and how does the movie/TV mix differ?
--Concepts : COUNT with CASE, NULL filtering,ORDER BY ,LIMIT
--Result : United states(2058/760),India(893/79),UK (206/213),Japan(76/169),South korea(41/158)
--Note:This is not exact share ,It is from co-produced countries (UK,India).splitted count is done in power query

select 
country,
count (case when type = 'Movie' THEN 1 END) AS movie_count,
COUNT( case when type = 'TV Show' THEN 1 END) AS show_count,
COUNT(*) AS total
from netflix
where country IS NOT NULL
Group by country 
order by total DESC LIMIT 10

--Q4. Cumulative catalog growth (running total)
--Question : How has Netflix's catalog grown cumulatively over release_years?
--Concepts: CTE,Window Function (SUM() OVER (ORDER BY..))
--Result : Tracks annual title additions and running total upto the 8,807 total catalog size.

with year_counts as(
select 
release_year,
COUNT(title) As ann_additions
From netflix
group by release_year
)
SELECT
 release_year,
 ann_additions,
 SUM(ann_additions) OVER (ORDER BY release_year) AS cum_catalog
 from year_counts
 ORDER BY release_year DESC LIMIT 10;
