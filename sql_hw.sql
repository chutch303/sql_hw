#1a. Display the first and last names of all actors from the table actor.

SELECT a.first_name, a.last_name
	FROM actor a;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT CONCAT(a.first_name, ' ', a.last_name) AS 'Actor Name'
	FROM actor a;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
#What is one query would you use to obtain this information?

SELECT a.actor_id, a.first_name, a.last_name
	FROM actor a
	WHERE a.first_name = 'Joe';
    
#2b. Find all actors whose last name contain the letters GEN:

SELECT a.first_name, a.last_name
	FROM actor a
	WHERE a.last_name LIKE '%GEN%';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT a.first_name, a.last_name
	FROM actor a
	WHERE a.last_name LIKE '%LI%'
    ORDER BY 2,1;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

#IN ?????????????

SELECT c.country_id, c.country
	FROM country c
    WHERE c.country = 'Afghanistan' OR c.country = 'Bangladesh' OR c.country = 'China';

#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.

ALTER TABLE actor 
ADD middle_name VARCHAR(10);

SELECT a.first_name, a.middle_name, a.last_name
	FROM actor a;

#3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.

ALTER TABLE actor 
MODIFY COLUMN middle_name BLOB;

#3c. Now delete the middle_name column.

ALTER TABLE actor 
DROP COLUMN middle_name;

#4a. List the last names of actors, as well as how many actors have that last name.

SELECT a.last_name, COUNT(*) AS name_count
	FROM actor a
	GROUP BY 1
	ORDER BY 2 DESC;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT t.last_name, t.name_count
FROM (
	SELECT a.last_name, COUNT(*) AS name_count
	FROM actor a
	GROUP BY 1
	ORDER BY 2 DESC
    )
as t    
    WHERE t.name_count >= 2;

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher.
#Write a query to fix the record.

UPDATE actor a
    SET a.first_name ='HARPO'
    WHERE a.first_name = 'GROUCHO'
		AND a.last_name = 'WILLIAMS';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all!
#In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
#Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error.
#BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)

UPDATE actor a
    SET a.first_name ='GROUCHO'
    WHERE a.first_name = 'HARPO'
		AND a.last_name = 'WILLIAMS';

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
#Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html

SHOW CREATE TABLE address

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT sta.first_name, sta.last_name, sta.address_id, ad.address
	FROM staff sta
    JOIN address ad ON ad.address_id = sta.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT sta.first_name, sta.last_name, sta.staff_id, SUM(p.amount)
	FROM staff sta
    JOIN payment p ON p.staff_id = sta.staff_id
    GROUP BY 1,2,3;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT f.title, f.film_id, COUNT(fa.actor_id)
	FROM film f
    JOIN film_actor fa ON fa.film_id = f.film_id
	GROUP BY 1,2
    ORDER BY 3 DESC;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT f.title, f.film_id, COUNT(i.inventory_id)
	FROM film f
	JOIN inventory i ON i.film_id = f.film_id
	WHERE f.title = 'Hunchback Impossible'
    GROUP BY 1,2;
# 6 copies

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
 #   ![Total amount paid](Images/total_payment.png)
 
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount)
	FROM customer c
    JOIN payment p on p.customer_id = c.customer_id
    GROUP BY 1,2,3
    ORDER BY 3;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
#As an unintended consequence, films starting with the letters K and Q have also soared in popularity
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

#all films are in English
CREATE VIEW english_films AS
SELECT f.title, f.language_id, l.name
	FROM film f
    JOIN language l ON l.language_id = f.language_id
    WHERE l.name = 'English';

SELECT * FROM english_films
    WHERE title LIKE 'K%' OR title LIKE 'Q%';


#7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT f.film_id, f.title, fa.actor_id, a.first_name, a.last_name
	FROM film f
	JOIN film_actor fa ON fa.film_id = f.film_id
    JOIN actor a ON a.actor_id = fa.actor_id
    WHERE f.title = 'Alone Trip';

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers
#Use joins to retrieve this information.

SELECT c.email, c.address_id, ad.city_id, ci.country_id, co.country
	FROM customer c
    JOIN address ad ON ad.address_id = c.address_id
	JOIN city ci ON ci.city_id = ad.city_id
    JOIN country co ON co.country_id = ci.country_id
    WHERE co.country LIKE '%Canada%';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT f.film_id, fc.category_id, cat.name
	FROM film f
    JOIN film_category fc ON fc.film_id = f.film_id
    JOIN category cat ON cat.category_id = fc.category_id
    WHERE cat.name = 'Family';

#7e. Display the most frequently rented movies in descending order.

SELECT f.film_id, f.title, i.inventory_id, COUNT(*) AS rental_count
	FROM film f
    JOIN inventory i ON i.film_id = f.film_id
    JOIN rental r ON r.inventory_id = i.inventory_id
    GROUP BY 1,2,3
    ORDER BY 4 DESC;
    
#7f. Write a query to display how much business, in dollars, each store brought in.

SELECT sto.store_id, sta.staff_id, r.rental_id, p.amount, SUM(p.amount) AS store_revenue
FROM store sto
JOIN staff sta ON sta.store_id = sto.store_id
JOIN rental r ON r.staff_id = sta.staff_id
JOIN payment p on p.rental_id = r.rental_id
GROUP BY 1
ORDER BY 5 DESC;

#7g. Write a query to display for each store its store ID, city, and country.

SELECT sto.store_id, ci.city, co.country
	FROM store sto
    JOIN address ad ON ad.address_id = sto.address_id
    JOIN city ci ON ci.city_id = ad.city_id
    JOIN country co ON co.country_id = ci.country_id;

#7h. List the top five genres in gross revenue in descending order.
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT cat.name, SUM(p.amount) AS gross_revenue
	FROM payment p
    JOIN rental r ON r.rental_id = p.rental_id
    JOIN inventory i ON i.inventory_id = r.inventory_id
    JOIN film_category fc ON fc.film_id = i.film_id
    JOIN category cat ON cat.category_id = fc.category_id
    GROUP BY 1
    ORDER BY 2 LIMIT 5;
    

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
#Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW top_rev_cats AS
SELECT cat.name, SUM(p.amount) AS gross_revenue
	FROM payment p
    JOIN rental r ON r.rental_id = p.rental_id
    JOIN inventory i ON i.inventory_id = r.inventory_id
    JOIN film_category fc ON fc.film_id = i.film_id
    JOIN category cat ON cat.category_id = fc.category_id
    GROUP BY 1
    ORDER BY 2 LIMIT 5;

#8b. How would you display the view that you created in 8a?

SELECT * FROM top_rev_cats;


#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW top_rev_cats;