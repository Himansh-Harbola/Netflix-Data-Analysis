-- USE netflix ;
/* CREATE TABLE Movie_Data(
    Show_id VARCHAR(20) ,
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

) */
/* LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.3/Uploads/netflix_titles.csv'
INTO TABLE movie_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; */
-- SHOW VARIABLES LIKE 'secure_file_priv';
-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
/* SELECT
 DISTINCT type_,
 COUNT(type_)
FROM Movie_data
GROUP BY 
  1 */
-- 2. Find the most common rating for movies and TV shows
/* SELECT type_ ,rating, COUNT(*) AS count
FROM movie_data
GROUP BY 1 ,2 ; */

-- 3. List all movies released in a specific year (e.g., 2020)
/* SELECT 
 type_ as type_,
 title as title
FROM 
 movie_data
WHERE 
 type_ = 'movie' AND Release_year='2020' ;

SELECT 
  COUNT(*) AS total_movies_2020
FROM 
  movie_data
WHERE 
  type_='movie' AND Release_year='2020' ; */
-- 4. Find the top 5 countries with the most content on Netflix
-- SELECT 
--   SUBSTRING_INDEX(country, ',', 1) AS primary_country, -- USA,India, JAPAN
--   COUNT(*) AS total_titles
-- FROM Movie_Data
-- WHERE country IS NOT NULL AND country != '' -- can also use country <> ''
-- GROUP BY primary_country
-- ORDER BY total_titles DESC
-- LIMIT 5;

-- 5. Identify the longest movie REATTEMPT
-- SELECT 
--   duration,
--   title,
--   CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) AS duration_mins,
--   RANK() OVER (ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC) AS rank_
-- FROM 
--   movie_data
-- WHERE 
--   type = 'Movie'
--   AND duration IS NOT NULL
--   AND duration <> ''
--   AND duration LIKE '%min%';


-- 6. Find content added in the last 5 years
-- SELECT 
--   date_added,
--   title,
--   CAST(SUBSTRING_INDEX(date_added,',',-1) AS UNSIGNED) AS year_released
-- FROM 
--   movie_data
-- WHERE
--   Date_Added IS NOT NULL AND CAST(SUBSTRING_INDEX(date_added,',',-1) AS UNSIGNED) >= 2019
-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
-- 8. List all TV shows with more than 5 seasons
-- SELECT 
--  duration,
--  title,
--  CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) AS seasons
-- FROM 
--  movie_data
-- WHERE 
--  Duration IS NOT NULL AND CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) > 5 AND type_ = 'TV SHOW' 

-- 9. Count the number of content items in each genre

-- 10.Find each year and the average numbers of content release in India on netflix.return top 5 year with highest avg content release!
-- SELECT 
--  CAST(SUBSTRING_INDEX(date_added,',',-1) AS UNSIGNED) AS year_released,
--  COUNT(title)
-- FROM
--  movie_data
-- WHERE
--  Country LIKE '%India%' 
-- AND Country IS NOT NULL
-- GROUP BY year_released

-- 11. List all movies that are documentaries
-- SELECT 
--  title,
--  type_
-- FROM 
--  movie_data
-- WHERE 
--  listed_in LIKE '%Documentaries%'
--  AND type_ = 'Movie'

-- 12. Find all content without a director
-- SELECT 
--  title ,
--  type_
-- FROM 
--  movie_data
-- WHERE 
--  Director IS NULL OR Director = ''

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!-
-- SELECT 
--  title
-- FROM 
--  Movie_data
-- WHERE 
--  Cast LIKE '%Salman Khan%' 

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
-- SELECT 
--  title,
--  cast
-- FROM 
--  movie_data
-- WHERE 
--  Country LIKE '%India%' 
-- UNION ALL
-- SELECT 
--  SUBSTRING_INDEX(cast,',',1) AS Actor,
--  COUNT(DISTINCT SUBSTRING_INDEX(cast,',',1))
-- FROM 
--  movie_data
-- GROUP BY 
--  1
-- ORDER BY 
--  1 DESC
-- LIMIT 10 
 

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
SELECT 
  CASE 
    WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad'
    ELSE 'Good'
  END AS content_rating,
  COUNT(*) AS total_items
FROM 
  movie_data
WHERE 
  description IS NOT NULL
GROUP BY 
  content_rating;




