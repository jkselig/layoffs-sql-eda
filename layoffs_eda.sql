-- Monthly Layoffs Trend (YYYY-MM format)
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH`;

-- Rolling Total Layoffs by Month
WITH Rolling_Total AS (
  SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
  FROM layoffs_staging2
  WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
  GROUP BY `MONTH`
)
SELECT 
  `MONTH`,
  total_off,
  SUM(total_off) OVER(ORDER BY `MONTH`) AS Rolling_Total
FROM Rolling_Total;

-- Total Layoffs by Company (All Time)
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

-- Total Layoffs by Company Per Year
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company, year;

-- Top 5 Companies with the Most Layoffs per Year
WITH Company_Year(company, years, total_layoffs) AS (
  SELECT company, YEAR(`date`), SUM(total_laid_off)
  FROM layoffs_staging2
  GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS (
  SELECT *,
         DENSE_RANK() OVER (PARTITION BY years ORDER BY total_layoffs DESC) AS ranking
  FROM Company_Year
  WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;

-- Layoffs by Funding Level Category
SELECT 
  CASE 
    WHEN funds_raised_millions < 50 THEN 'Under $50M'
    WHEN funds_raised_millions BETWEEN 50 AND 200 THEN '$50M–$200M'
    WHEN funds_raised_millions BETWEEN 200 AND 500 THEN '$200M–$500M'
    WHEN funds_raised_millions > 500 THEN 'Over $500M'
    ELSE 'Unknown'
  END AS funding_category,
  COUNT(*) AS companies,
  SUM(total_laid_off) AS total_laid_off,
  AVG(percentage_laid_off) AS avg_pct_laid_off
FROM layoffs_staging2
GROUP BY funding_category
ORDER BY total_laid_off DESC;

-- Layoffs by Startup Stage
SELECT 
  stage,
  COUNT(*) AS company_count,
  SUM(total_laid_off) AS total_laid_off,
  AVG(percentage_laid_off) AS avg_pct_laid_off
FROM layoffs_staging2
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY total_laid_off DESC;

-- Companies with the Highest Average % Laid Off
SELECT 
  company,
  COUNT(*) AS layoff_events,
  AVG(percentage_laid_off) AS avg_pct_laid_off,
  SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY avg_pct_laid_off DESC
LIMIT 20;

-- Normalized Layoffs: Layoffs per $1M Funded
SELECT 
  company,
  funds_raised_millions,
  SUM(total_laid_off) AS total_laid_off,
  ROUND(SUM(total_laid_off) / NULLIF(funds_raised_millions, 0), 2) AS layoffs_per_million
FROM layoffs_staging2
WHERE funds_raised_millions IS NOT NULL
GROUP BY company, funds_raised_millions
HAVING layoffs_per_million IS NOT NULL
ORDER BY layoffs_per_million DESC
LIMIT 20;

-- Layoffs by Country (Totals and Averages)
SELECT 
  country,
  COUNT(*) AS layoff_events,
  SUM(total_laid_off) AS total_laid_off,
  AVG(percentage_laid_off) AS avg_pct_laid_off
FROM layoffs_staging2
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_laid_off DESC;

-- Countries with the Highest Average % Laid Off
SELECT 
  country,
  COUNT(*) AS layoff_events,
  ROUND(AVG(percentage_laid_off) * 100, 2) AS avg_pct_laid_off
FROM layoffs_staging2
WHERE country IS NOT NULL AND percentage_laid_off IS NOT NULL
GROUP BY country
ORDER BY avg_pct_laid_off DESC;

-- Total Layoffs by Industry
SELECT 
  industry,
  COUNT(*) AS layoff_events,
  SUM(total_laid_off) AS total_laid_off,
  ROUND(AVG(percentage_laid_off) * 100, 2) AS avg_pct_laid_off
FROM layoffs_staging2
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Industries with the Highest Average % Laid Off
SELECT 
  industry,
  COUNT(*) AS layoff_events,
  ROUND(AVG(percentage_laid_off) * 100, 2) AS avg_pct_laid_off
FROM layoffs_staging2
WHERE industry IS NOT NULL AND percentage_laid_off IS NOT NULL
GROUP BY industry
ORDER BY avg_pct_laid_off DESC;