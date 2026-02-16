# Schema Notes (Rockbuster)

## Database & context
- Database: Rockbuster (DVD rental)
- SQL dialect: PostgreSQL
- Purpose of analysis: answer business questions related to customer geography, revenue concentration, and rental behavior.

## Core tables used (how they relate)
This analysis primarily uses:
- payment → rental (payment.rental_id = rental.rental_id)
- rental → inventory (rental.inventory_id = inventory.inventory_id)
- inventory → film (inventory.film_id = film.film_id)
- rental → customer (rental.customer_id = customer.customer_id)
- customer → address → city → country (customer.address_id → address.city_id → city.country_id)
- film ↔ category via film_category
- film ↔ actor via film_actor

## “Grain” (what one row means)
- payment: one payment transaction
- rental: one rental event
- inventory: one physical copy of a film at a store
- customer: one customer

## Assumptions & definitions used in queries
- Revenue = SUM(payment.amount)
- “Top customers” = customers ranked by total revenue
- Country = derived from customer.address_id chain through country
- Time window: (state if filtered; otherwise “full dataset”)

## Common join paths (quick reference)
- Customer → Country:
  customer.address_id → address.city_id → city.country_id → country.country
- Rentals → Films:
  rental.inventory_id → inventory.film_id → film.film_id

## Data quality notes / caveats
- Some analyses may double count if joining payment → rental → inventory without grouping at the correct grain.
- Customers may have zero payments depending on filtering/joins (note if applicable).
- Email exists in customer table; do not export/share customer-level raw data publicly.
