USE netflix;

CREATE TABLE Movie_Data (
    Show_id VARCHAR(20),
    type_ VARCHAR(50),
    Title VARCHAR(200),
    Director VARCHAR(500),
    Cast VARCHAR(1500),
    Country VARCHAR(200),
    Date_Added VARCHAR(100),
    Release_year VARCHAR(5),
    Rating VARCHAR(20),
    Duration VARCHAR(20),
    Listed_in VARCHAR(200),
    Description_ VARCHAR(1500)
);

-- Load data 
-- SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.3/Uploads/netflix_titles.csv'
INTO TABLE Movie_Data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 1. Count the number of Movies vs TV Shows
SELECT 
  type_, 
  COUNT(*) AS total_count
FROM Movie_Data
GROUP BY type_;

-- 2. Find the most common rating for movies and TV shows
SELECT 
  type_, 
  rating, 
  COUNT(*) AS count
FROM Movie_Data
GROUP BY type_, rating
ORDER BY count DESC;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT 
  type_ AS type,
  title AS title
FROM Movie_Data
WHERE type_ = 'Movie' AND Release_year = '2020';

SELECT 
  COUNT(*) AS total_movies_2020
FROM Movie_Data
WHERE type_ = 'Movie' AND Release_year = '2020';

-- 4. Find the top 5 countries with the most content on Netflix
SELECT 
  SUBSTRING_INDEX(country, ',', 1) AS primary_country,
  COUNT(*) AS total_titles
FROM Movie_Data
WHERE country IS NOT NULL AND country <> ''
GROUP BY primary_country
ORDER BY total_titles DESC
LIMIT 5;

-- 5. Identify the longest movie
SELECT 
  title,
  duration,
  CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) AS duration_mins
FROM Movie_Data
WHERE 
  type_ = 'Movie'
  AND duration IS NOT NULL
  AND duration LIKE '%min%'
ORDER BY duration_mins DESC
LIMIT 1;

-- 6. Find content added in the last 5 years
SELECT 
  date_added,
  title,
  CAST(SUBSTRING_INDEX(date_added, ',', -1) AS UNSIGNED) AS year_added
FROM Movie_Data
WHERE 
  date_added IS NOT NULL 
  AND CAST(SUBSTRING_INDEX(date_added, ',', -1) AS UNSIGNED) >= YEAR(CURDATE()) - 5;

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
SELECT 
  title, 
  type_, 
  director
FROM Movie_Data
WHERE 
  LOWER(director) = 'rajiv chilaka';

-- 8. List all TV shows with more than 5 seasons
SELECT 
  title,
  duration,
  CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) AS seasons
FROM Movie_Data
WHERE 
  type_ = 'TV Show'
  AND duration LIKE '%Season%'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- 9. Count the number of content items in each genre
SELECT 
  listed_in,
  COUNT(*) AS total_count
FROM Movie_Data
GROUP BY listed_in
ORDER BY total_count DESC;

-- 10. Find each year and the average number of content releases in India; return top 5 years with highest counts
SELECT 
  CAST(SUBSTRING_INDEX(date_added, ',', -1) AS UNSIGNED) AS year_released,
  COUNT(*) AS content_count
FROM Movie_Data
WHERE 
  country LIKE '%India%' 
  AND date_added IS NOT NULL
GROUP BY year_released
ORDER BY content_count DESC
LIMIT 5;

-- 11. List all movies that are documentaries
SELECT 
  title,
  type_
FROM Movie_Data
WHERE 
  type_ = 'Movie'
  AND listed_in LIKE '%Documentaries%';

-- 12. Find all content without a director
SELECT 
  title,
  type_
FROM Movie_Data
WHERE 
  director IS NULL OR director = '';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years
SELECT 
  COUNT(*) AS total_movies_salman
FROM Movie_Data
WHERE 
  cast LIKE '%Salman Khan%'
  AND Release_year >= YEAR(CURDATE()) - 10
  AND type_ = 'Movie';

-- 14. Top 10 actors with highest number of appearances in Indian movies
SELECT 
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', n.n), ',', -1)) AS Actor,
  COUNT(*) AS appearance_count
FROM 
  Movie_Data
  JOIN (
    SELECT a.N + b.N * 10 + 1 AS n
    FROM 
      (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
       UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
      (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
       UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
  ) n ON n.n <= 1 + LENGTH(cast) - LENGTH(REPLACE(cast, ',', ''))
WHERE 
  country LIKE '%India%'
  AND cast IS NOT NULL
GROUP BY Actor
ORDER BY appearance_count DESC
LIMIT 10;

-- 15. Categorize content based on 'kill' or 'violence' in description
SELECT 
  CASE 
    WHEN LOWER(description_) LIKE '%kill%' OR LOWER(description_) LIKE '%violence%' THEN 'Bad'
    ELSE 'Good'
  END AS content_rating,
  COUNT(*) AS total_items
FROM Movie_Data
WHERE 
  description_ IS NOT NULL
GROUP BY content_rating;
