# Netflix-content-strategy-analysis
Interactive Power BI executive dashboard and SQL analysis evaluating Netflix's catalog transition from Movies to TV shows(2000-2021)
# Netflix Titles Analysis

Is Netflix shifting from movies to TV shows, and which genres and countries drive it?

## Data
Kaggle "Netflix Movies and TV Shows" dataset, 8,807 titles: [Netflix Shows on Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows)

## Method
- **SQL:** CTEs, `SUM(CASE WHEN ...)` conditional aggregation, window functions, and a cleaning view (`netflix_clean`).
- **Excel / Power Query:** cleaned the data, fixed two broken CSV records, split and unpivoted the genre and country columns, and audited trailing whitespace.
- **Power BI:** one-page dashboard with DAX measures and slicers.

## Key findings
All figures are share of **titles** added to the catalogue, not viewing.

**1. TV share of titles rose across release-year groups**

| Release years | TV share | Movie share |
| :--- | :---: | :---: |
| Before 2000 | 9.3% | 90.7% |
| 2000-2015 | 22.5% | 77.5% |
| 2016 onwards | 36.0% | 64.0% |

By single year, TV share went from 20.6% (2010) to 53.2% (2021, partial year).

**2. Movies added the most titles, but TV genres grew faster.** Comparing 2010-2015 with 2016-2021, International Movies added the most titles (+967). TV genres started from a smaller base: International TV Shows grew from 261 to 1,023 titles, and Crime TV Shows from 61 to 398.

**3. Splitting multi-value columns changed the rankings.** Counting the country column as a single string showed the US with 2,818 titles. After splitting, it was 3,690. UK went from 419 to 806.

## Limitations
- The data covers titles, not subscribers or viewing, so it shows what Netflix added, not what people watched.
- 2021 is a partial year, so 53.2% may change with a full year of data.
- 16.5% of titles list 2+ countries, so country counts add up to 10,012, not 8,807. The country chart shows which countries have the most titles, not which ones drive the TV shift.

## Author
[Keerthana R](https://www.linkedin.com/in/keerthanaramachandran/)
