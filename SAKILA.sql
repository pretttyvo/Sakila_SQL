-- 1) ACTORS FULL NAME
USE sakila;

SELECT first_name, last_name FROM actor;

SELECT Concat(first_name,last_name) AS full_name
FROM actor;

-- 2) FIND ACTOR BASED ON NAME
SELECT * FROM actor;

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3) MODIFYING THE TABLE
ALTER TABLE actor
ADD Description BLOB;

ALTER TABLE actor
DROP COLUMN Description;

SELECT * FROM actor;

-- 4) MODIFYING/MANIPULATING DATA
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name;

SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name
HAVING count(last_name) > 1;

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name =  'WILLIAMS';

UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' and last_name =  'WILLIAMS';

SELECT first_name, last_name
FROM actor
WHERE last_name = 'WILLIAMS';

-- 5) LOCATE ADDRESS TABLE ??double check??
SHOW CREATE TABLE address;

-- 6) JOIN DATA 
SELECT * FROM staff;
SELECT * FROM inventory;
SELECT * FROM film;

SELECT first_name, last_name, address
FROM staff 
INNER JOIN address
ON staff.address_id = address.address_id;

SELECT first_name, last_name, SUM(amount)
FROM staff 
INNER JOIN payment
ON staff.staff_id = payment.staff_id
GROUP BY payment.staff_id ;

SELECT title, COUNT(actor_id)
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

SELECT title, count(title)
FROM inventory
INNER JOIN film
ON inventory.film_id = film.film_id
GROUP BY inventory.film_id
HAVING title = 'Hunchback Impossible';

SELECT first_name, last_name, SUM(amount)
FROM payment
INNER JOIN customer
ON customer.customer_id = payment.customer_id
GROUP BY payment.customer_id
ORDER BY last_name;

-- 7) Subqueries

SELECT * FROM film
WHERE title LIKE 'A%' or title LIKE 'K%' 
AND language_id = '1';

SELECT COUNT(*)
FROM actor
where actor_id IN 
(SELECT actor_id
FROM film_actor
WHERE film_id IN
	(SELECT film_id 
    FROM film
    WHERE title = 'Alone Trip'
    )
);

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN
(SELECT address_id
FROM address
WHERE city_id IN
	(SELECT city_id
	FROM city
	WHERE country_id IN
		(SELECT country_id
		FROM country
		WHERE country = 'Canada'
        )
	)
);

SELECT title 
FROM film 
WHERE film_id IN
(SELECT film_id 
FROM film_category
WHERE category_id IN 
	(SELECT category_id
    FROM category
    WHERE name = 'Family'
    )
);

SELECT title, times_rented
FROM film
INNER JOIN 
(SELECT inventory.film_id, count(inventory.film_id) times_rented
FROM inventory
INNER JOIN rental
ON rental.inventory_id = inventory.inventory_id
GROUP BY inventory.film_id
ORDER BY COUNT(inventory.film_id) DESC) A 
ON A.film_id = film.film_id
ORDER BY times_rented DESC;

SELECT B.store_id, SUM(payment.amount)
FROM payment
INNER JOIN 
(SELECT rental.rental_id, inventory.inventory_id, inventory.store_id
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id) B
ON B.rental_id = payment.rental_id
GROUP BY store_id;

SELECT D.store_id, C.city, C.country
FROM 
(SELECT city.city, city.city_id, country.country
FROM city
INNER JOIN country
ON city.country_id = country.country_id) C
INNER JOIN
(SELECT store.store_id, address.city_id
FROM store
INNER JOIN address
ON store.address_id = address.address_id) D
ON C.city_id = D.city_id;

SELECT name
FROM category
WHERE category_id IN
(SELECT category_id
FROM film_category
INNER JOIN
(SELECT amount, inventory_id
FROM payment
INNER JOIN 
(SELECT rental.rental_id, inventory.inventory_id, inventory.store_id
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id) B
ON B.rental_id = payment.rental_id) E 
ON category_id
GROUP BY category_id
ORDER BY SUM(amount) DESC)
LIMIT 5;



-- 8) VIEWS

CREATE VIEW V_top_5_grossing
AS SELECT F.name
FROM 
(SELECT name
FROM category
WHERE category_id IN
(SELECT category_id
FROM film_category
INNER JOIN
(SELECT amount, inventory_id
FROM payment
INNER JOIN 
(SELECT rental.rental_id, inventory.inventory_id, inventory.store_id
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id) B
ON B.rental_id = payment.rental_id) E 
ON category_id
GROUP BY category_id
ORDER BY SUM(amount) DESC)
LIMIT 5) F;

SELECT * FROM V_top_5_grossing;

DROP VIEW V_top_5_grossing;


