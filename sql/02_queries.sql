/* ============================================================
   Rockbuster Customer & Revenue Analysis
   SQL dialect: PostgreSQL

   This file contains runnable queries used to generate portfolio
   outputs and Tableau-ready aggregates.

   Tip: Run section-by-section and export results as CSV when needed.
   ============================================================ */


/* ------------------------------------------------------------
   SECTION A — Customer Overview (matches outputs spreadsheet)
   Output: outputs/customer_overview.csv (or Excel tab)
   ------------------------------------------------------------ */
SELECT
  COUNT(*) AS total_customers,
  SUM(CASE WHEN active = 1 THEN 1 ELSE 0 END) AS active_customers,
  SUM(CASE WHEN active = 0 THEN 1 ELSE 0 END) AS inactive_customers
FROM customer;


/* ------------------------------------------------------------
   SECTION B — Customers & Revenue by Country (matches outputs)
   Output: outputs/customers_revenue_by_country.csv
   Notes:
   - Customer count uses DISTINCT customers
   - Revenue sums all payments made by customers in that country
   ------------------------------------------------------------ */
SELECT
  co.country,
  COUNT(DISTINCT cu.customer_id) AS customer_count,
  ROUND(COALESCE(SUM(p.amount), 0), 2) AS total_revenue
FROM customer cu
JOIN address a
  ON cu.address_id = a.address_id
JOIN city ci
  ON a.city_id = ci.city_id
JOIN country co
  ON ci.country_id = co.country_id
LEFT JOIN payment p
  ON cu.customer_id = p.customer_id
GROUP BY co.country
ORDER BY customer_count DESC, total_revenue DESC;


/* ------------------------------------------------------------
   SECTION C — Top 10 Countries by Customer Count (matches outputs)
   Output: outputs/top_10_countries_by_customer_count.csv
   ------------------------------------------------------------ */
SELECT
  co.country,
  COUNT(DISTINCT cu.customer_id) AS customer_count
FROM customer cu
JOIN address a
  ON cu.address_id = a.address_id
JOIN city ci
  ON a.city_id = ci.city_id
JOIN country co
  ON ci.country_id = co.country_id
GROUP BY co.country
ORDER BY customer_count DESC
LIMIT 10;


/* ------------------------------------------------------------
   SECTION D — Top 5 Customers by Total Amount Paid (matches outputs)
   Output: outputs/top_5_customers_by_revenue.csv
   ------------------------------------------------------------ */
SELECT
  p.customer_id,
  ROUND(SUM(p.amount), 2) AS total_amount_paid
FROM payment p
GROUP BY p.customer_id
ORDER BY total_amount_paid DESC
LIMIT 5;


/* ============================================================
   SECTION E — Films: Most / Least Revenue (board question)
   ============================================================ */

/* E1 — Top 10 films by revenue
   Output: outputs/top_10_films_by_revenue.csv
*/
SELECT
  f.film_id,
  f.title,
  ROUND(SUM(p.amount), 2) AS total_revenue
FROM payment p
JOIN rental r
  ON p.rental_id = r.rental_id
JOIN inventory i
  ON r.inventory_id = i.inventory_id
JOIN film f
  ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY total_revenue DESC
LIMIT 10;


/* E2 — Bottom 10 films by revenue (among films with revenue)
   Output: outputs/bottom_10_films_by_revenue.csv
*/
SELECT
  f.film_id,
  f.title,
  ROUND(SUM(p.amount), 2) AS total_revenue
FROM payment p
JOIN rental r
  ON p.rental_id = r.rental_id
JOIN inventory i
  ON r.inventory_id = i.inventory_id
JOIN film f
  ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
HAVING SUM(p.amount) > 0
ORDER BY total_revenue ASC
LIMIT 10;


/* Optional E3 — Films with zero revenue (if you want true "least")
   Output: outputs/films_with_zero_revenue.csv
   NOTE: This shows films that never appear in a paid rental path.
*/
SELECT
  f.film_id,
  f.title,
  0.00::numeric AS total_revenue
FROM film f
LEFT JOIN inventory i
  ON f.film_id = i.film_id
LEFT JOIN rental r
  ON i.inventory_id = r.inventory_id
LEFT JOIN payment p
  ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title
HAVING COALESCE(SUM(p.amount), 0) = 0
ORDER BY f.title;


/* ============================================================
   SECTION F — Average Rental Duration (board question)
   ============================================================ */

/* F1 — Average catalog rental duration (film.rental_duration in days)
   Output: outputs/avg_catalog_rental_duration.csv
*/
SELECT
  ROUND(AVG(f.rental_duration), 2) AS avg_catalog_rental_duration_days
FROM film f;


/* F2 — Average realized rental duration (return_date - rental_date)
   Output: outputs/avg_realized_rental_duration.csv
   NOTE: Only includes rentals with a return_date.
*/
SELECT
  ROUND(AVG(EXTRACT(EPOCH FROM (r.return_date - r.rental_date)) / 86400.0), 2)
    AS avg_realized_rental_duration_days
FROM rental r
WHERE r.return_date IS NOT NULL;


/* ============================================================
   SECTION G — High Lifetime Value Customers (board question)
   ============================================================ */

/* G1 — Top 20 customers by lifetime revenue + country/city
   Output: outputs/top_customers_ltv_with_location.csv
*/
SELECT
  cu.customer_id,
  cu.first_name,
  cu.last_name,
  ci.city,
  co.country,
  ROUND(SUM(p.amount), 2) AS lifetime_value
FROM payment p
JOIN customer cu
  ON p.customer_id = cu.customer_id
JOIN address a
  ON cu.address_id = a.address_id
JOIN city ci
  ON a.city_id = ci.city_id
JOIN country co
  ON ci.country_id = co.country_id
GROUP BY
  cu.customer_id, cu.first_name, cu.last_name, ci.city, co.country
ORDER BY lifetime_value DESC
LIMIT 20;


/* G2 — Where high-LTV customers are concentrated (by country)
   Output: outputs/high_ltv_customers_by_country.csv
   Definition: High-LTV = top 10% of customers by lifetime value
*/
WITH customer_ltv AS (
  SELECT
    p.customer_id,
    SUM(p.amount) AS lifetime_value
  FROM payment p
  GROUP BY p.customer_id
),
ltv_ranked AS (
  SELECT
    customer_id,
    lifetime_value,
    NTILE(10) OVER (ORDER BY lifetime_value DESC) AS decile
  FROM customer_ltv
)
SELECT
  co.country,
  COUNT(DISTINCT cu.customer_id) AS high_ltv_customer_count,
  ROUND(SUM(cl.lifetime_value), 2) AS high_ltv_revenue
FROM ltv_ranked cl
JOIN customer cu
  ON cl.customer_id = cu.customer_id
JOIN address a
  ON cu.address_id = a.address_id
JOIN city ci
  ON a.city_id = ci.city_id
JOIN country co
  ON ci.country_id = co.country_id
WHERE cl.decile = 1
GROUP BY co.country
ORDER BY high_ltv_customer_count DESC, high_ltv_revenue DESC;


/* ============================================================
   SECTION H — Do sales vary by region? (board question)
   ============================================================ */

/* H1 — Revenue by country + revenue per customer (normalizes size)
   Output: outputs/revenue_by_country_with_per_customer.csv
*/
SELECT
  co.country,
  COUNT(DISTINCT cu.customer_id) AS customer_count,
  ROUND(COALESCE(SUM(p.amount), 0), 2) AS total_revenue,
  ROUND(
    COALESCE(SUM(p.amount), 0) / NULLIF(COUNT(DISTINCT cu.customer_id), 0),
    2
  ) AS revenue_per_customer
FROM customer cu
JOIN address a
  ON cu.address_id = a.address_id
JOIN city ci
  ON a.city_id = ci.city_id
JOIN country co
  ON ci.country_id = co.country_id
LEFT JOIN payment p
  ON cu.customer_id = p.customer_id
GROUP BY co.country
ORDER BY total_revenue DESC;
