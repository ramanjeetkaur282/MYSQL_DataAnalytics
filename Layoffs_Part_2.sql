-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging_2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging_2;

SELECT * 
FROM layoffs_staging_2
WHERE percentage_laid_off=1;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company
ORDER BY 2 DESC;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY country
ORDER BY 2 DESC;

SELECT MAX(`date`),MIN(`date`)
FROM layoffs_staging_2;

SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY `date`
ORDER BY 1 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging_2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_off_CTE AS
(SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS laid_off
FROM layoffs_staging_2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,laid_off,
SUM(laid_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_off_CTE;

SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_years (company,years,total_laid_off) AS
(
SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
),
Company_Year_Rank AS
(
SELECT *,
dense_rank() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_years
WHERE total_laid_off IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5;

SELECT *
FROM layoffs_staging_2
WHERE funds_raised_millions IS NOT NULL
ORDER BY funds_raised_millions DESC;
























