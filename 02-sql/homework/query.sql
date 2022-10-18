-- 1. Birthyear
SELECT * FROM movies WHERE year = 1986;

--2. 1982
SELECT COUNT(*) FROM movies WHERE year = 1982;

--3. Stacktors
SELECT * FROM actors WHERE last_name LIKE '%stack%';

--4. Fame Name Game
SELECT first_name, last_name, COUNT(*) AS Total
FROM actors
GROUP BY LOWER(first_name), LOWER(last_name)
ORDER BY Total DESC
LIMIT 10;

-- 5. Prolific
SELECT a.first_name, a.last_name, COUNT(r.actor_id) AS total
FROM actors AS a JOIN roles AS r ON a.id = r.actor_id
GROUP BY (a.id)
ORDER BY total DESC
LIMIT 100;

-- 6. Bottom of the Barrel
SELECT genre, COUNT(*) AS total
FROM movies_genres
GROUP BY genre
ORDER BY total;

-- 7. Braveheart
SELECT a.first_name, a.last_name FROM actors AS a
JOIN roles AS r ON a.id = r.actor_id
JOIN movies AS m ON m.id = r.movie_id
WHERE 
  m.name = 'Braveheart' AND 
  m.year = 1995
ORDER BY a.last_name, a.first_name;

-- 8. Leap Noir
SELECT d.first_name || " " || d.last_name AS director, m.name AS movie, m.year 
FROM directors AS d
JOIN directors_genres AS dg ON d.id = dg.director_id
JOIN movies_directors AS md ON d.id = md.director_id
JOIN movies AS m ON md.movie_id = m.id
WHERE 
  dg.genre = "Film-Noir" AND
  m.year % 4 = 0;

-- 9. Bacon
SELECT a.first_name || " " || a.last_name AS actor, m.name AS movie
FROM actors AS a
JOIN roles AS r ON a.id = r.actor_id
JOIN movies AS m ON r.movie_id = m.id
JOIN movies_genres AS mg ON m.id = mg.movie_id
WHERE 
  a.first_name <> "Kevin" AND
  a.last_name <> "Bacon" AND
  mg.genre = "Drama" AND
  m.id IN (
    SELECT rol.movie_id FROM roles AS rol
    JOIN actors AS act ON rol.actor_id = act.id
    WHERE act.first_name = "Kevin" AND act.last_name = "Bacon"
    );

-- 10. Immortal Actors
SELECT a.first_name || " " || a.last_name AS actor FROM actors AS a
WHERE a.id IN (
  SELECT r.actor_id FROM roles AS r
  JOIN movies AS m ON r.movie_id = m.id
  WHERE m.year < 1900
) AND 
a.id IN (
  SELECT r.actor_id FROM roles AS r
  JOIN movies AS m ON r.movie_id = m.id
  WHERE m.year > 2000
); 

-- 11. Busy Filming
SELECT a.first_name || ' ' || a.last_name AS actor, m.name AS pelicula, 
COUNT(DISTINCT(r.role)) AS total
FROM actors AS a
JOIN roles AS r ON a.id = r.actor_id
JOIN movies AS m ON m.id = r.movie_id
WHERE m.year > 1990
GROUP BY a.id, m.id
HAVING (total > 5);

-- 12. ♀
SELECT m.year, COUNT(DISTINCT(m.id)) FROM movies m
JOIN roles AS r ON m.id = r.movie_id
JOIN actors AS a ON r.actor_id = a.id
WHERE a.gender = 'F'
GROUP BY m.year;
