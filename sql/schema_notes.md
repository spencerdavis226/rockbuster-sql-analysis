# Schema Notes (Rockbuster / PostgreSQL)

## Context
Rockbuster is a DVD rental dataset with customer, rental, payment, and film metadata. Analysis focuses on:
- Customer geography and market concentration
- Revenue drivers (films, customers, countries)
- Rental duration (catalog vs realized)

SQL dialect: PostgreSQL.

---

## Core tables used (and why)

### Revenue & transactions
- payment: one row per payment transaction (amount, payment_date, customer_id, rental_id)
- rental: one row per rental event (rental_date, return_date, customer_id, inventory_id)

### Film catalog
- inventory: one row per physical copy of a film at a store (inventory_id, film_id, store_id)
- film: film metadata including rental_duration (days) and rental_rate

### Customer geography
- customer: customer profile (customer_id, active flag)
- address → city → country: location chain

### Optional enrichment
- film_category + category: genre/category for films
- film_actor + actor: cast

---

## “Grain” (what one row represents)
- payment: 1 payment transaction
- rental: 1 rental event
- inventory: 1 physical copy of a film in a store
- film: 1 unique film title
- customer: 1 customer

Why this matters:
- If you join payment → rental → inventory → film, you should aggregate at the correct grain (film, customer, country) to avoid duplication.

---

## Canonical join paths

### Customer → Country
customer.address_id
  → address.address_id
  → address.city_id
  → city.city_id
  → city.country_id
  → country.country_id

### Payments → Films
payment.rental_id
  → rental.rental_id
  → rental.inventory_id
  → inventory.inventory_id
  → inventory.film_id
  → film.film_id

### Films → Category (genre)
film.film_id → film_category.film_id → film_category.category_id → category.category_id

---

## Definitions used in this project
- Revenue: SUM(payment.amount)
- Customer count by country: COUNT(DISTINCT customer.customer_id)
- “High lifetime value (LTV)” customer: customers ranked by total revenue (SUM(payment.amount))
- Catalog rental duration: film.rental_duration (days)
- Realized rental duration: rental.return_date - rental.rental_date (days)

---

## Data quality / safety notes
- The customer table may include email. Do not publish any raw customer-level exports publicly.
- Use aggregated outputs (by country / film / customer_id) instead of row-level customer records.
