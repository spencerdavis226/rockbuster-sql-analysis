

# Rockbuster Data Dictionary (Summary)

This document provides a **quick-reference overview** of the Rockbuster database schema used in this analysis.

For full documentation, see:
📄 `docs/rockbuster-data-dictionary.pdf`

---

## Database Overview

The Rockbuster database is a **normalized relational schema** consisting of:

- **Fact tables**: transactional records (payments, rentals, inventory)
- **Dimension tables**: descriptive attributes (customers, films, locations)
- **Bridge tables**: many-to-many relationships (film_actor, film_category)

---

## Key Fact Tables

### payment
- **Grain:** one row per payment transaction
- **Primary Key:** `payment_id`

**Important Fields:**
- `customer_id` → links to customer
- `rental_id` → links to rental
- `amount` → payment value
- `payment_date` → timestamp of transaction

---

### rental
- **Grain:** one row per rental transaction
- **Primary Key:** `rental_id`

**Important Fields:**
- `inventory_id` → rented item
- `customer_id` → customer
- `rental_date` → rental timestamp
- `return_date` → return timestamp

---

### inventory
- **Grain:** one row per physical film copy
- **Primary Key:** `inventory_id`

**Important Fields:**
- `film_id` → film title
- `store_id` → store location

---

## Key Dimension Tables

### customer
- **Grain:** one row per customer
- **Primary Key:** `customer_id`

**Important Fields:**
- `store_id`
- `address_id`
- `active`

---

### film
- **Grain:** one row per film
- **Primary Key:** `film_id`

**Important Fields:**
- `title`
- `rental_rate`
- `length`
- `rating`

---

### category
- **Grain:** one row per category
- **Primary Key:** `category_id`

---

### actor
- **Grain:** one row per actor
- **Primary Key:** `actor_id`

---

### language
- **Grain:** one row per language
- **Primary Key:** `language_id`

---

### store
- **Grain:** one row per store
- **Primary Key:** `store_id`

---

### address
- **Grain:** one row per address
- **Primary Key:** `address_id`

**Important Fields:**
- `city_id`
- `district`

---

### city
- **Grain:** one row per city
- **Primary Key:** `city_id`

---

### country
- **Grain:** one row per country
- **Primary Key:** `country_id`

---

## Bridge Tables

### film_actor
- Resolves many-to-many relationship between films and actors
- Composite Key: (`film_id`, `actor_id`)

---

### film_category
- Resolves many-to-many relationship between films and categories
- Composite Key: (`film_id`, `category_id`)

---

## Key Join Paths Used in Analysis

### Revenue Attribution
```sql
payment → rental → inventory → film
```

### Customer Geography
```sql
customer → address → city → country
```

---

## Notes

- All tables are normalized to reduce redundancy
- Analytical queries require **multiple joins** to reconstruct business meaning
- Revenue must be defined explicitly using `SUM(payment.amount)`

---

## How to Use This File

This file is designed for **quick understanding**, not full technical documentation.

For deeper schema details, refer to the full PDF data dictionary.
