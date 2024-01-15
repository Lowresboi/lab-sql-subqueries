use sakila;

-- How many copies of the film...
SELECT 
    COUNT(*) AS num_copies
FROM 
    inventory i
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    f.title = 'Hunchback Impossible';
    
-- List all films whose lenght is longer than the average of all the films
SELECT 
    title, length
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film);

-- Use subqueries to display all actors who appear in the film Alone trip
SELECT 
    actor_id, first_name, last_name
FROM 
    actor
WHERE 
    actor_id IN (SELECT actor_id FROM film_actor WHERE film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip'));

-- Identify all movies categorized as family films 
SELECT 
    f.film_id, c.category_id as family_film_id, title
FROM 
    category as c
JOIN
	film as f
JOIN
	film_category as fc ON f.film_id = fc.film_id
WHERE 
    name IN (SELECT name FROM category WHERE name = 'Family');

-- Get name and email from customers
SELECT 
    first_name, last_name, email
FROM 
    customer
WHERE 
    address_id IN (SELECT address_id FROM address WHERE city_id IN (SELECT city_id FROM city WHERE country_id IN (SELECT country_id FROM country WHERE country = 'Canada')));
    
-- Get name and email from customers from canada
SELECT 
    c.first_name, c.last_name, c.email
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id
JOIN 
    country co ON ci.country_id = co.country_id
WHERE 
    co.country = 'Canada';
    
-- Films starred by the most prolific actor 
SELECT 
    f.title
FROM 
    film_actor AS fa
JOIN 
    actor AS a ON fa.actor_id = a.actor_id
JOIN 
    film AS f ON fa.film_id = f.film_id
WHERE 
    fa.actor_id = (
        SELECT 
            actor_id
        FROM 
            film_actor
        GROUP BY 
            actor_id
        ORDER BY 
            COUNT(film_id) DESC
        LIMIT 1
    );

    
-- Films rented by the most profitable customer

SELECT 
    f.title
FROM 
    rental r
JOIN 
    payment p ON r.rental_id = p.rental_id
JOIN 
    customer c ON r.customer_id = c.customer_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    c.customer_id = (SELECT customer_id FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 1);

-- Get id and the amount spent of those clients who spent more than the average 
SELECT 
    c.customer_id AS client_id, SUM(p.amount) AS total_amount_spent
FROM 
    customer AS c
JOIN 
    payment AS p ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id
HAVING 
    total_amount_spent > (SELECT AVG(amount) FROM payment);

