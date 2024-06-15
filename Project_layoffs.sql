SELECT * FROM layoffs;

-- Data Cleaning
-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null Values or Blank Values
-- 4. Remove any Columns

-- Create a Staging table
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

-- Copy all data from layoffs table to staging table
INSERT INTO layoffs_staging
SELECT * 
FROM layoffs;

-- Provide row number by partitioning over every single column
SELECT *,
ROW_NUMBER() 
OVER (partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH CTE_Duplicates AS
(
SELECT *,
ROW_NUMBER() OVER (
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM CTE_Duplicates
WHERE row_num >1;

SELECT company, COUNT(company) AS count_num
FROM layoffs_staging
GROUP BY company
ORDER BY count_num DESC;

SELECT * 
FROM layoffs_staging
WHERE company="Twitter";

-- CREATE a table with row number column
CREATE TABLE `layoffs_staging_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging_2;

INSERT INTO layoffs_staging_2
SELECT *,
ROW_NUMBER() OVER (
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE 
FROM layoffs_staging_2
WHERE row_num >1;

SET SQL_SAFE_UPDATES = 0;


-- Standardize the data like removing extra spaces using Trim
SELECT company, TRIM(company)
FROM layoffs_staging;

-- Update this trim in company column
UPDATE layoffs_staging_2
SET company=TRIM(company);

SELECT *
FROM layoffs_staging_2
WHERE industry = "Crypto";

SELECT DISTINCT country
FROM layoffs_staging_2;

SELECT *
FROM layoffs_staging_2
WHERE country="United States.";

UPDATE layoffs_staging_2
SET country = "United States"
WHERE country LIKE "United States%";

-- Convert Date field from Text type to Date type
SELECT `date`,
str_to_date(`date`,"%m/%d/%Y") AS Formatted_Date
FROM layoffs_staging_2;

UPDATE layoffs_staging_2
SET `date`= str_to_date(`date`,"%m/%d/%Y");

SELECT * 
FROM layoffs_staging_2;

ALTER TABLE layoffs_staging_2
MODIFY `date` date;

-- Handling blanks or NULL

SELECT * 
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging_2
WHERE industry IS NULL
OR industry = '';

UPDATE layoffs_staging_2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging_2;

SELECT *
FROM layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	ON t1.company=t2.company
WHERE (t1.industry IS NULL )
AND (t2.industry IS NOT NULL) ;

UPDATE layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE (t1.industry IS NULL )
AND (t2.industry IS NOT NULL) ;

-- Delete the row_num column
ALTER TABLE layoffs_staging_2
DROP column row_num;






