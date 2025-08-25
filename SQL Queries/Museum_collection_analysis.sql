CREATE DATABASE MUSEUM_COLLECTION;

USE MUSEUM_COLLECTION;

SELECT * FROM ARTWORKS;

SELECT * FROM ARTISTS;


-- CHECK DUPLICATE VALUES

SELECT COUNT(*) FROM ARTWORKS;
SELECT DISTINCT COUNT(*) FROM ARTWORKS;

SELECT COUNT(*) FROM ARTISTS;
SELECT DISTINCT COUNT(*) FROM ARTISTS;

-- REMOVE LEADING/TRAILING SPACES     

UPDATE ARTWORKS
SET 
    TITLE = LTRIM(RTRIM(TITLE)),
    ARTIST = LTRIM(RTRIM(ARTIST)),
    GENDER = LTRIM(RTRIM(GENDER)),
    MEDIUM = LTRIM(RTRIM(MEDIUM)),
    DEPARTMENT = LTRIM(RTRIM(DEPARTMENT)),
    CLASSIFICATION = LTRIM(RTRIM(CLASSIFICATION)),
    CREDITLINE = LTRIM(RTRIM(CREDITLINE)),
    ONVIEW = LTRIM(RTRIM(ONVIEW));

-- REMOVE ROWS WHERE TITLE AND ARTIST, BOTH ARE NULL

DELETE FROM ARTWORKS
WHERE TITLE IS NULL AND ARTIST IS NULL;

-- REMOVE ROWS WHERE OBJECTID IS NULL

DELETE FROM ARTWORKS
WHERE OBJECTID IS NULL OR LTRIM(RTRIM(OBJECTID)) = ''; 

-- REPLACE BLANK SPACE WITH NULL IN TITLE, MEDIUM AND DEPARTMENT FIELD

UPDATE ARTWORKS
SET TITLE = NULLIF(TITLE, ''),
    MEDIUM = NULLIF(MEDIUM, ''),
    DEPARTMENT = NULLIF(DEPARTMENT, '');

-- NULLIF('American', '') → 'American'  
-- NULLIF('', '') → NULL 



-- CONVERT DATATYPES STORED AS STRINGS

-- NATIONALITY 

--SELECT DISTINCT NATIONALITY FROM ARTWORKS;


--UPDATE ARTWORKS
--SET NATIONALITY = TRY_CAST(LTRIM(RTRIM(REPLACE(REPLACE(NATIONALITY, '(', ''),')',''))) AS VARCHAR(255));

-- First replace double spaces

--UPDATE ARTWORKS
--SET NATIONALITY = REPLACE(NATIONALITY, '  ', ' ')
--WHERE NATIONALITY IS NOT NULL;

-- Repeat if data has more than two spaces in a row

--UPDATE ARTWORKS
--SET NATIONALITY = REPLACE(NATIONALITY, '  ', ' ')
--WHERE NATIONALITY IS NOT NULL;

-- Convert space-separated values to comma-separated values

--UPDATE ARTWORKS
--SET NATIONALITY = REPLACE(NATIONALITY, ' ', ',')  
--WHERE NATIONALITY IS NOT NULL AND NATIONALITY <> '';

-- Clean up values that became empty or meaningless (like ,)

--UPDATE ARTWORKS
--SET NATIONALITY = 'Unknown'
--WHERE NATIONALITY IS NULL 
--   OR NATIONALITY = '' 
--   OR NATIONALITY = ',' 
--   OR NATIONALITY = ', ';

-- GENDER

--UPDATE ARTWORKS
--SET GENDER = LTRIM(RTRIM(REPLACE(REPLACE(GENDER, '(', ''),')','')));

--UPDATE ARTWORKS
--SET GENDER = REPLACE(GENDER, '  ', ' ')
--WHERE GENDER IS NOT NULL;

--UPDATE ARTWORKS
--SET GENDER = REPLACE(GENDER, '  ', ' ')
--WHERE GENDER IS NOT NULL;

--UPDATE ARTWORKS
--SET GENDER = LOWER(GENDER);

--UPDATE ARTWORKS
--SET GENDER = REPLACE(GENDER, ' ', ',')
--WHERE GENDER IS NOT NULL AND GENDER <> '';


--ALTER TABLE ARTWORKS
--ADD GENDER_CLEAN VARCHAR(MAX);

--UPDATE ARTWORKS
--SET GENDER_CLEAN =  
--     CASE
--        WHEN GENDER IS NULL OR LTRIM(RTRIM(GENDER)) = '' THEN 'unknown'
--        WHEN GENDER LIKE '%transgender%' THEN 'transgender'
--        WHEN GENDER LIKE '%gender non-conforming%' THEN 'not-confirmed'
--        WHEN (LEN(GENDER) - LEN(REPLACE(GENDER, 'female', ''))) / LEN('female') > 1 THEN 'female (multiple)'
--        WHEN LTRIM(RTRIM(GENDER)) = 'female' THEN 'female'
--        WHEN (LEN(GENDER) - LEN(REPLACE(GENDER, 'male', ''))) / LEN('male') > 1 THEN 'male (multiple)'
--        WHEN LTRIM(RTRIM(GENDER)) = 'male' THEN 'male'
--        WHEN GENDER LIKE '%female%' AND GENDER LIKE '%male%' THEN 'mixed'

--        ELSE 'unknown'
--    END;

--ALTER TABLE ARTWORKS
--DROP COLUMN GENDER;

--EXEC SP_RENAME 'ARTWORKS.GENDER_CLEAN', 'Gender', 'COLUMN';

--SELECT DISTINCT GENDER FROM ARTWORKS;

---- BEGIN DATE

--SELECT DISTINCT BEGINDATE FROM ARTWORKS;


--ALTER TABLE ARTWORKS
--ADD BEGINDATE_CLEAN VARCHAR(MAX);

--SELECT DISTINCT BEGINDATE_CLEAN FROM ARTWORKS;

---- REMOVE PARENTHESES AND DOTS, NORMALIZING SPACING

--UPDATE ARTWORKS
--SET BEGINDATE_CLEAN = 
--    REPLACE(REPLACE(REPLACE(REPLACE(BEGINDATE, '(', ''), ')', ''), '.',''),'  ',' ')
--WHERE BEGINDATE IS NOT NULL;

---- REMOVE ALL INSTANCES OF 0 (SINGLE 0 OR SURROUNDED BY SPACES)

--UPDATE ARTWORKS
--SET BEGINDATE_CLEAN = 
--    LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(BEGINDATE_CLEAN, ' 0 ', ' '), '0 ', ''),' 0', '')))
--WHERE BEGINDATE_CLEAN IS NOT NULL;

--UPDATE ARTWORKS
--SET BEGINDATE_CLEAN = REPLACE(BEGINDATE_CLEAN, ' ', ',')
--WHERE BEGINDATE_CLEAN IS NOT NULL AND BEGINDATE_CLEAN <> '';

--UPDATE ARTWORKS
--SET BEGINDATE_CLEAN = 'Unknown'
--WHERE BEGINDATE_CLEAN IS NULL
--   OR BEGINDATE_CLEAN = '0'
--   OR BEGINDATE_CLEAN = '' 
--   OR BEGINDATE_CLEAN = ',' 
--   OR BEGINDATE_CLEAN = ', ';


--ALTER TABLE ARTWORKS
--DROP COLUMN BEGINDATE;

--EXEC SP_RENAME 'ARTWORKS.BEGINDATE_CLEAN', 'Begin_Date', 'COLUMN';  -- RENAME COLUMN PROCEDURE

---- END DATE

--SELECT DISTINCT ENDDATE FROM ARTWORKS;


--ALTER TABLE ARTWORKS
--ADD ENDDATE_CLEAN VARCHAR(MAX);

--SELECT DISTINCT ENDDATE_CLEAN FROM ARTWORKS;

---- REMOVE PARENTHESES AND DOTS, NORMALIZING SPACING

--UPDATE ARTWORKS
--SET ENDDATE_CLEAN = 
--    REPLACE(REPLACE(REPLACE(REPLACE(ENDDATE, '(', ''), ')', ''), '.',''),'  ',' ')
--WHERE ENDDATE IS NOT NULL;

---- REMOVE ALL INSTANCES OF 0 (SINGLE 0 OR SURROUNDED BY SPACES)

--UPDATE ARTWORKS
--SET ENDDATE_CLEAN = 
--    LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(ENDDATE_CLEAN, ' 0 ', ' '), '0 ', ''),' 0', '')))
--WHERE ENDDATE_CLEAN IS NOT NULL;

--UPDATE ARTWORKS
--SET ENDDATE_CLEAN = REPLACE(ENDDATE_CLEAN, ' ', ',')
--WHERE ENDDATE_CLEAN IS NOT NULL AND ENDDATE_CLEAN <> '';

--UPDATE ARTWORKS
--SET ENDDATE_CLEAN = 'Unknown'
--WHERE ENDDATE_CLEAN IS NULL
--   OR ENDDATE_CLEAN = '0'
--   OR ENDDATE_CLEAN = '' 
--   OR ENDDATE_CLEAN = ',' 
--   OR ENDDATE_CLEAN = ', ';


--ALTER TABLE ARTWORKS
--DROP COLUMN ENDDATE;

--EXEC SP_RENAME 'ARTWORKS.ENDDATE_CLEAN', 'End_Date', 'COLUMN';







-- DATEACQUIRED

SELECT
     DATEACQUIRED,
	 TRY_CONVERT(DATE, DATEACQUIRED) AS FORMATTED_DATE
FROM ARTWORKS
WHERE DATEACQUIRED IS NOT NULL AND TRY_CONVERT(DATE, DATEACQUIRED) IS NULL;



-- CHECK DATATYPE OF CATALOGED, OBJECTID


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ARTWORKS' AND COLUMN_NAME = 'CATALOGED';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ARTWORKS' AND COLUMN_NAME = 'OBJECTID';


-- CHECK DATATYPE OF HEIGHT_CM, WIDTH_CM

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ARTWORKS' AND COLUMN_NAME = 'HEIGHT_CM';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ARTWORKS' AND COLUMN_NAME = 'WIDTH_CM';

SELECT * FROM ARTWORKS;

-- NEW TABLE CREATE ARTWORKS_EXPANDED

CREATE TABLE Artworks_Expanded (
    ConstituentID INT,
    Title NVARCHAR(MAX),
    Artist NVARCHAR(MAX),
    Medium NVARCHAR(MAX),
    Dimensions NVARCHAR(MAX),
    Classification NVARCHAR(MAX),
    Department NVARCHAR(MAX),
    DateAcquired DATE,
    Cataloged INT,
    ObjectID INT,
    Height_cm FLOAT,
    Width_cm FLOAT
);

-- INSERT SPLIT DATA INTO THE NEW TABLE

INSERT INTO Artworks_Expanded (
    ConstituentID,
    Title,
    Artist,
    Medium,
    Dimensions,
    Classification,
    Department,
    DateAcquired,
    Cataloged,
    ObjectID,
    Height_cm,
    Width_cm
)
SELECT 
    TRY_CAST(TRIM(value) AS INT) AS ConstituentID,
    Title,
    Artist,
    Medium,
    Dimensions,
    Classification,
    Department,
    DateAcquired,
    Cataloged,
    ObjectID,
    Height_cm,
    Width_cm
FROM Artworks
CROSS APPLY STRING_SPLIT(ConstituentID, ',');


SELECT * FROM ARTWORKS_EXPANDED;
SELECT * FROM ARTISTS;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ARTISTS' AND COLUMN_NAME = 'ENDDATE';


UPDATE ARTISTS
SET NATIONALITY = 'Unknown'
WHERE NATIONALITY IS NULL;

UPDATE ARTISTS
SET GENDER = 'Unknown'
WHERE GENDER IS NULL;

-- Add column for Year and Month

ALTER TABLE ARTWORKS_EXPANDED ADD Acquired_Year INT;
ALTER TABLE ARTWORKS_EXPANDED ADD Acquired_Month VARCHAR(255);

-- Update them

UPDATE ARTWORKS_EXPANDED
SET 
    Acquired_Year = YEAR(DATEACQUIRED),
    Acquired_Month = DATENAME(MONTH, DATEACQUIRED);


SELECT 
     A.CONSTITUENTID,
	 A.DISPLAYNAME,
	 ARTISTBIO,
	 NATIONALITY,
	 GENDER,
	 BEGINDATE,
	 ENDDATE,
	 TITLE,
	 CLASSIFICATION,
	 DEPARTMENT,
	 DATEACQUIRED,
	 ACQUIRED_YEAR,
	 ACQUIRED_MONTH,
	 CATALOGED,
	 OBJECTID,
	 MEDIUM,
	 DIMENSIONS,
	 HEIGHT_CM,
	 WIDTH_CM
FROM ARTWORKS_EXPANDED AE
JOIN ARTISTS A
ON AE.CONSTITUENTID = A.CONSTITUENTID;

--1. How modern are the artworks at the Museum?

SELECT DISTINCT 
    CASE 
        WHEN ACQUIRED_YEAR BETWEEN 1924 AND 1945 THEN 'Foundational Collection (1924–1945)'
        WHEN ACQUIRED_YEAR BETWEEN 1946 AND 1965 THEN 'Post-War Expansion (1946–1965)'
        WHEN ACQUIRED_YEAR BETWEEN 1966 AND 1985 THEN 'Modern Growth (1966–1985)'
        WHEN ACQUIRED_YEAR BETWEEN 1986 AND 2005 THEN 'Contemporary Wave (1986–2005)'
        WHEN ACQUIRED_YEAR BETWEEN 2006 AND 2024 THEN '21st Century Collection (2006–2024)'
        ELSE 'Unclassified Period'
    END AS ACQUISITION_PERIOD,
    COUNT(TITLE) AS ARTWORK_COLLECTION
FROM ARTWORKS_EXPANDED
GROUP BY 
    CASE 
        WHEN ACQUIRED_YEAR BETWEEN 1924 AND 1945 THEN 'Foundational Collection (1924–1945)'
        WHEN ACQUIRED_YEAR BETWEEN 1946 AND 1965 THEN 'Post-War Expansion (1946–1965)'
        WHEN ACQUIRED_YEAR BETWEEN 1966 AND 1985 THEN 'Modern Growth (1966–1985)'
        WHEN ACQUIRED_YEAR BETWEEN 1986 AND 2005 THEN 'Contemporary Wave (1986–2005)'
        WHEN ACQUIRED_YEAR BETWEEN 2006 AND 2024 THEN '21st Century Collection (2006–2024)'
        ELSE 'Unclassified Period'
    END
ORDER BY ARTWORK_COLLECTION DESC;

--Over 51,000 artworks were acquired between 2006–2024 (21st Century Collection),
--Followed by nearly 47,000 from 1966–1985 (Modern Growth),
--And more than 32,000 from 1986–2005 (Contemporary Wave).
--Together, these modern and contemporary works make up over 80% of the entire collection, 
--clearly indicating that the Museum emphasizes modern and recent artworks, 
--with a strong focus on expanding its 21st-century collection.

--2. Which artists are featured the most?

SELECT TOP 10
     ARTIST AS ARTIST_NAME,
	 DEPARTMENT, 
	 COUNT(*) AS TOTAL_ARTWORK_COLLECTION
FROM ARTWORKS_EXPANDED
GROUP BY ARTIST,DEPARTMENT
ORDER BY 3 DESC;

-- `Ludwig Mies van der Rohe` is the most featured artist in the Museum's collection with over 15,000 artworks,
-- followed by Eugène Atget and Louise Bourgeois. This shows the Museum has a strong focus on modern architecture,
-- photography, and sculpture. The presence of artists like Picasso and Matisse highlights the importance of modern art in the collection.

-- 3. Are there any trends in the dates of acquisition?

-- There is a clear upward trend in acquisitions over time, with the highest number of artworks acquired between 2006 and 2024, labeled as the “21st Century Collection”.
-- This suggests that the museum has been actively expanding its collection in recent decades, especially in the 21st century,
-- reflecting a growing interest in modern and contemporary art.

-- 4. What types of artwork are most common?

SELECT TOP 10 CLASSIFICATION,
              COUNT(*) AS ARTWORK_COLLECTION
FROM ARTWORKS_EXPANDED
WHERE CLASSIFICATION IS NOT NULL
GROUP BY CLASSIFICATION
ORDER BY 2 DESC;

--The museum mostly collects photographs, prints, and illustrated books, showing a strong focus on visual and reproducible art.
--Other types like design and architecture are also well-represented.

-- SOME EXTRA ANALYSIS

-- 5. Number of Artworks per Artist Nationality >>

SELECT TOP 10 NATIONALITY,
              COUNT(*) AS ARTWORK_COLLECTION
FROM ARTWORKS_EXPANDED AE
JOIN ARTISTS A
ON AE.CONSTITUENTID = A.CONSTITUENTID
GROUP BY NATIONALITY
ORDER BY 2 DESC;

-- The collection features a strong emphasis on American artists, followed by French and German contributors. 
-- This highlights a dominant Western influence in the museum’s holdings.

-- 6. Top artist of each Department (by artwork collection) 

WITH DEPT_ARTIST_COUNT AS (
SELECT
     DEPARTMENT,
     ARTIST,
	 COUNT(*) AS TOTAL_ARTWORK_COLLECTION
FROM ARTWORKS_EXPANDED
GROUP BY DEPARTMENT,ARTIST
),
RANKED_ARTIST AS (
SELECT *,
       RANK() OVER (PARTITION BY DEPARTMENT ORDER BY TOTAL_ARTWORK_COLLECTION DESC) AS DEPT_RANK
FROM DEPT_ARTIST_COUNT
)
SELECT
     DEPARTMENT,
	 ARTIST,
	 TOTAL_ARTWORK_COLLECTION
FROM RANKED_ARTIST
WHERE DEPT_RANK = 1
ORDER BY 3 DESC;

--The top artists in each department highlight the diversity and specialization of the museum's collection.
--`Ludwig Mies van der Rohe` dominates both Architecture & Design and its Image Archive, showing his strong influence in that field.
--`Louise Bourgeois` leads Drawings & Prints, while `Eugène Atget` is most featured in Photography.
--Departments like Painting & Sculpture and Film showcase globally recognized names like `Pablo Picasso` and collaborative works.
--This indicates the museum's focus on top talent in each field.




