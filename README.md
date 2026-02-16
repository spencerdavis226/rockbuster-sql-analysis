# Rockbuster Customer & Revenue Analysis (SQL + Tableau)

Rockbuster Stealth is a global DVD rental company preparing for a streaming launch. This project answers key business questions about revenue drivers, customer geography, and high-value segments using PostgreSQL and visualizes results in Tableau.

## Business questions answered
- Which movies contributed the most/least to revenue?
- What is the average rental duration?
- Which countries are customers based in?
- Where are high lifetime value customers located?
- Do sales figures vary by geographic region?

## Key results (from outputs)
- Total customers: 599; Active: 584; Inactive: 15
- Customers are globally distributed with concentration in a handful of countries
- Revenue concentration exists among a subset of customers (high LTV segment)

## Deliverables
- **SQL (runnable):** `sql/02_queries.sql`
- **Schema notes:** `sql/01_schema_notes.md`
- **Outputs (aggregated):** `outputs/rockbuster-sql-outputs.xlsx`
- **ERD image:** `images/rockbuster-erd.png`
- **Presentation (PDF):** `docs/rockbuster-presentation.pdf`
- **Data dictionary (PDF):** `docs/rockbuster-data-dictionary.pdf`

## Tableau links (interactive)
- Customer Geography (Bubble Map): <PASTE_LINK>
- Top Customer Countries: <PASTE_LINK>
- High Value Customers: <PASTE_LINK>

## How to use
1. Open `sql/01_schema_notes.md` for join paths + definitions.
2. Run queries in `sql/02_queries.sql` in PostgreSQL.
3. Compare results to the aggregated outputs in `/outputs`.
4. View the Tableau links for interactive exploration.

## Tools
PostgreSQL, SQL (joins/CTEs/window functions), Excel (outputs), Tableau

## Note
This project was completed as part of the [CareerFoundry](chatgpt://generic-entity?number=2) Databases & SQL curriculum.
