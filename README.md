# 🏛️ Museum Collection Insights
![Dashboard Preview](Datasets/wp2186239-museum-wallpapers.jpg)

**A Data Analytics & Visualization Project Using Microsoft SQL Server & Power BI**  
Analysis period: **1929 – 2024**

This repository contains an end-to-end analytics project that transforms raw museum records into an interactive Power BI dashboard and a repeatable SQL pipeline for cleaning, normalizing, and analyzing the Museum of Modern Art collection.

> Full SQL script (step-by-step): `Museum_collection_analysis.sql` (included as PDF). :contentReference[oaicite:1]{index=1}

---

## 📦 Repository Contents

- `Datasets/` — raw CSVs and dashboard preview images
- `sql/` — main SQL script and modular SQL snippets (see `Museum_collection_analysis.sql`) :contentReference[oaicite:2]{index=2}
- `powerbi/` — Power BI `.pbix` (if included)
- `README.md` — this document

---

## 📌 Project Summary

This project demonstrates a full analytical workflow:
1. **Data ingestion & validation** (identify duplicates, check schemas)
2. **Data cleaning & normalization** (trim, standardize, parse dates)
3. **Normalization of multi-valued fields** (decompose `ConstituentID` into one row per artist)
4. **Feature engineering** (`Acquired_Year`, `Acquired_Month`, `Period_Category`)
5. **Exploratory analysis & reporting** (top artists, acquisition trends, classifications)
6. **Interactive visualization** in Power BI (two-page dashboard: Overview + Explorer)

All SQL steps are implemented in the main script. See the script for the exact, runnable sequence. :contentReference[oaicite:3]{index=3}

---

## 🔍 Data Cleaning & Transformation — Key Steps (as implemented)

Below are the core SQL steps executed in the project (these mirror the provided script). The full script contains these and additional checks/comments. :contentReference[oaicite:4]{index=4}

### 1. Database & basic checks
```sql
CREATE DATABASE MUSEUM_COLLECTION;
USE MUSEUM_COLLECTION;

SELECT COUNT(*) FROM ARTWORKS;
SELECT DISTINCT COUNT(*) FROM ARTWORKS;
SELECT COUNT(*) FROM ARTISTS;
SELECT DISTINCT COUNT(*) FROM ARTISTS;
````

### 2. Trim whitespace and normalize text fields

```sql
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
```

### 3. Remove obviously invalid rows

```sql
-- Remove rows with no title & no artist
DELETE FROM ARTWORKS WHERE TITLE IS NULL AND ARTIST IS NULL;

-- Remove rows with missing OBJECTID
DELETE FROM ARTWORKS WHERE OBJECTID IS NULL OR LTRIM(RTRIM(OBJECTID)) = '';
```

### 4. Convert empty strings to `NULL`

```sql
UPDATE ARTWORKS
SET TITLE = NULLIF(TITLE, ''),
    MEDIUM = NULLIF(MEDIUM, ''),
    DEPARTMENT = NULLIF(DEPARTMENT, '');
```

### 5. Remove duplicates (keep one row per ObjectID)

```sql
WITH CTE AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY ObjectID ORDER BY ObjectID) AS rn
  FROM Artworks
)
DELETE FROM CTE WHERE rn > 1;
```

### 6. Normalize `ConstituentID` → create `Artworks_Expanded`

```sql
-- create normalized table
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

-- populate by splitting comma-separated ConstituentID
INSERT INTO Artworks_Expanded (
  ConstituentID, Title, Artist, Medium, Dimensions, Classification,
  Department, DateAcquired, Cataloged, ObjectID, Height_cm, Width_cm
)
SELECT 
  TRY_CAST(LTRIM(RTRIM(value)) AS INT),
  Title, Artist, Medium, Dimensions, Classification,
  Department, DateAcquired, Cataloged, ObjectID, Height_cm, Width_cm
FROM Artworks
CROSS APPLY STRING_SPLIT(ConstituentID, ',');
```

### 7. Fill missing artist metadata defaults

```sql
UPDATE ARTISTS SET NATIONALITY = 'Unknown' WHERE NATIONALITY IS NULL;
UPDATE ARTISTS SET GENDER = 'Unknown' WHERE GENDER IS NULL;
```

### 8. Derive acquisition year and month

```sql
ALTER TABLE Artworks_Expanded ADD Acquired_Year INT;
ALTER TABLE Artworks_Expanded ADD Acquired_Month VARCHAR(255);

UPDATE Artworks_Expanded
SET Acquired_Year = YEAR(DateAcquired),
    Acquired_Month = DATENAME(MONTH, DateAcquired);
```

---

## 📈 Analysis Queries (representative)

These are the main analytical queries included in the script; use them for reporting and dashboards. Full queries and results are available in the SQL script.&#x20;

### How modern are the artworks?

```sql
SELECT 
  CASE 
    WHEN ACQUIRED_YEAR BETWEEN 1924 AND 1945 THEN 'Foundational Collection (1924–1945)'
    WHEN ACQUIRED_YEAR BETWEEN 1946 AND 1965 THEN 'Post-War Expansion (1946–1965)'
    WHEN ACQUIRED_YEAR BETWEEN 1966 AND 1985 THEN 'Modern Growth (1966–1985)'
    WHEN ACQUIRED_YEAR BETWEEN 1986 AND 2005 THEN 'Contemporary Wave (1986–2005)'
    WHEN ACQUIRED_YEAR BETWEEN 2006 AND 2024 THEN '21st Century Collection (2006–2024)'
    ELSE 'Unclassified Period'
  END AS ACQUISITION_PERIOD,
  COUNT(TITLE) AS ARTWORK_COLLECTION
FROM Artworks_Expanded
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
```

### Top artists (overall)

```sql
SELECT TOP 10
  ARTIST AS ARTIST_NAME,
  DEPARTMENT,
  COUNT(*) AS TOTAL_ARTWORK_COLLECTION
FROM Artworks_Expanded
GROUP BY ARTIST, DEPARTMENT
ORDER BY TOTAL_ARTWORK_COLLECTION DESC;
```

### Top classifications

```sql
SELECT TOP 10 CLASSIFICATION, COUNT(*) AS ARTWORK_COLLECTION
FROM Artworks_Expanded
WHERE CLASSIFICATION IS NOT NULL
GROUP BY CLASSIFICATION
ORDER BY ARTWORK_COLLECTION DESC;
```

### Top artist per department

```sql
WITH DEPT_ARTIST_COUNT AS (
  SELECT DEPARTMENT, ARTIST, COUNT(*) AS TOTAL_ARTWORK_COLLECTION
  FROM Artworks_Expanded
  GROUP BY DEPARTMENT, ARTIST
),
RANKED_ARTIST AS (
  SELECT *, RANK() OVER (PARTITION BY DEPARTMENT ORDER BY TOTAL_ARTWORK_COLLECTION DESC) AS DEPT_RANK
  FROM DEPT_ARTIST_COUNT
)
SELECT DEPARTMENT, ARTIST, TOTAL_ARTWORK_COLLECTION
FROM RANKED_ARTIST
WHERE DEPT_RANK = 1
ORDER BY TOTAL_ARTWORK_COLLECTION DESC;
```

### Nationality breakdown (top 10)

```sql
SELECT TOP 10 A.NATIONALITY, COUNT(*) AS ARTWORK_COLLECTION
FROM Artworks_Expanded AE
JOIN Artists A ON AE.CONSTITUENTID = A.CONSTITUENTID
GROUP BY A.NATIONALITY
ORDER BY ARTWORK_COLLECTION DESC;
```

---

## 📌 Notes, Assumptions & Data Quality

* The pipeline assumes `ConstituentID` values are comma-separated and aligned with `Artist` text; if positional mismatches exist they require manual remediation.
* Date parsing uses SQL date functions; messy `DateCreated`/`BeginDate` strings were cleaned with substring/PATINDEX heuristics in the script.
* Gender and nationality normalization follow rule-based transformations; where ambiguous, values default to `'Unknown'`.
* The script includes commented sections for alternative approaches (XML-based splitting, advanced deduplication) — see the full script.&#x20;

---

## 📊 Power BI Dashboard (two-page design)

**Page 1 — Overview**

* KPIs (Total artworks, Total artists, Earliest/Latest acquisition)
* Acquisition trend (line chart)
* Classification treemap / bar
* Top artists (bar chart)
* Nationality distribution (map / bar)

**Page 2 — Explorer**

* Department → Top artist matrix
* Interactive Artist Profile (cards + gallery)
* Size analysis (height × width scatter)
* Cross-filtering and drill-through enabled

---

## 🔗 References & Full SQL

* Full SQL processing script (annotated): `Museum_collection_analysis.sql` (PDF uploaded to repo).&#x20;

---

## 🧑‍💼 Project Author

**Sahil Jena**
*Data Analytics Project | 2025*

🔗 [LinkedIn](https://www.linkedin.com/in/shreya-pandey-97252431b/)
📁 GitHub: [github.com/Shreya579/MoMA-ModernArt-Analytics](https://github.com/shreya579/MoMA-ModernArt-Analytics)

---
::contentReference[oaicite:8]{index=8}
```
