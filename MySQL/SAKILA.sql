-- 1. ACTORES PRIMER NOMBRE SCARLETT --
SELECT * FROM actor WHERE first_name = 'scarlett';

-- 2. ACTORES DE APELLIDO JOHANSSON -- 
SELECT * FROM actor WHERE last_name = 'johansson';


-- 3. ACTORES QUE CONTENGAN UNA O EN SU NOMBRE -- 
SELECT first_name FROM actor WHERE first_name LIKE '%o%';

-- 4. ACTORES QUE CONTENGAN UNA O EN SU NOMBRE Y UNA A EN SU APELLIDO --
SELECT first_name, last_name FROM actor WHERE first_name LIKE '%o%' AND last_name LIKE '%a%';

-- 5. ACTORES QUE CONTENGAN DOS O EN SU NOMBRE Y UNA A EN SU APELLIDO --
SELECT first_name, last_name FROM actor WHERE first_name LIKE '%o%o%' AND last_name LIKE '%a%';


-- 6. ACTORES DONDE SU TERCERA LETRA SEA UNA B -- 
SELECT * FROM actor WHERE first_name LIKE '__b%';


-- 7. CIUDADES QUE EMPIEZAN POR A -- 
SELECT * FROM city WHERE city LIKE 'a%';

-- 8. CIUDADES QUE ACABAN POR S --
SELECT * FROM city WHERE city LIKE '%s';

-- 9. CIUDADES DEL COUNTRY 61 -- 
SELECT * FROM city WHERE country_id = 61;

SELECT c.city, co.country
FROM city c
JOIN country co  ON c.country_id = co.country_id
WHERE co.country_id = 61;

-- 10. CIUDADES DEL COUNTRY SPAIN -- 
SELECT c.city, co.country
FROM city c
JOIN country co  ON c.country_id = co.country_id
WHERE co.country = 'spain';

-- SUBCONSULTA -- 
SELECT * 
FROM city 
WHERE country_id = (SELECT country_id FROM country WHERE country = 'spain');

-- 11. CIUDADES CON NOMBRES COMPUESTOS -- 
SELECT * FROM city WHERE city LIKE '% %';

-- 12. PELICULAS CON UNA DURACION ENTRE 80 Y 100 -- 
SELECT * FROM film WHERE length BETWEEN 80 AND 100;


-- 13. PELICULAS CON UN RENTAL_RATE ENTRE 1 Y 3 -- 
SELECT * FROM film WHERE rental_rate BETWEEN 1 AND 3;

-- 14. PELICULAS CON UN TITULO DE MAS DE 12 LETRAS --
SELECT * FROM film WHERE length(title) >= 12;
SELECT title, length(title)  FROM film WHERE length(title) >= 12;

-- 15. PELICULAS CON UN RATING DE PG O G --
SELECT * FROM film WHERE rating = 'pg' OR rating = 'g';

-- 16. PELICULAS SIN UN RATING DE NC-17 -- 
SELECT * FROM film WHERE rating != 'nc-17';

-- 17. PELICULAS CON UN RATING PG Y DURACION MAS DE 120 --
SELECT * FROM film WHERE rating = 'pg' AND length >= 120;


-- 18. CUANTOS ACTORES HAY --
SELECT COUNT(*) AS numero_actores FROM actor;

-- 19. CUANTAS CIUDADES TIENE EL COUNTRY SPAIN -- 
SELECT COUNT(*) AS country_spain
FROM city 
WHERE country_id = (SELECT country_id FROM country WHERE country = 'spain');

-- 20. CUANTOS COUNTRIES HAY QUE EMPIECEN POR M -- 
SELECT COUNT(*) AS country_m
FROM country
WHERE country LIKE 'a%';


-- 21. MEDIA DE DURACION DE PELICULAS CON PG --
SELECT title, AVG(length) AS media_peliculas
FROM film 
WHERE rating = 'pg'
GROUP BY film_id;

-- 22. SUMA DE RENTAL_RATE DE TODAS LAS PELICULAS -- 
SELECT title, SUM(rental_rate) AS rental_rate
FROM film 
GROUP BY film_id;

SELECT SUM(rental_rate) AS rental_rate
FROM film;

-- 23. PELICULA CON MAYOR DURACION -- 
SELECT * FROM film 
WHERE length = (SELECT MAX(length) FROM film) LIMIT 1;

-- 24. PELICULA CON MENOR DURACION  --
SELECT * FROM film 
WHERE length = (SELECT MIN(length) FROM film) LIMIT 1;

-- 25. CIUDADES DEL COUNTRY SPAIN MULTITABLA -- 
SELECT c.city, co.country
FROM city c
JOIN country co  ON c.country_id = co.country_id
WHERE co.country = 'spain';

-- 26. NOMBRE DE LA PELICULA Y EL NOMBRE DE LOS ACTORES -- 
SELECT f.title, a.first_name, a.last_name 
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id;


-- 27. NOMBRE DE LA PELICULA Y EL DE SUS CATEGORIAS -- 
SELECT f.title , c.name AS categoria 
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
ORDER BY f.title;

-- 28. COUNTRY, CIUDAD Y DIRECCION DE CADA MIEMBRO DEL STAFF -- 
SELECT c.country, ci.city, ad.address, s.staff_id, s.first_name
FROM country c
JOIN city ci ON c.country_id = ci.country_id
JOIN address ad ON ci.city_id = ad.city_id
JOIN staff s ON ad.address_id = s.address_id;

-- 29. COUNTRY, CIUDAD Y DIRECCION DE CADA CUSTOMER --
SELECT c.country, ci.city, ad.address, cu.customer_id, cu.first_name
FROM country c
JOIN city ci ON c.country_id = ci.country_id
JOIN address ad ON ci.city_id = ad.city_id
JOIN customer cu ON ad.address_id = cu.address_id;


-- 30. NUMERO DE PELICULAS DE CADA RATING --
SELECT rating, COUNT(*) AS numero_peliculas
FROM film 
GROUP BY rating;


-- 31. CUANTAS PELICULAS HA REALIZADO EL ACTOR ED CHASE --
SELECT a.first_name, a.last_name, COUNT(*) AS num_peliculas
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE a.first_name = 'ed' AND a.last_name = 'chase';


-- 32. MEDIA DE DURACION DE LAS PELICULAS , CADA CATEGORIA -- 
SELECT c.name AS category, AVG(length) AS Media_peliculas 
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;