# Rockbuster Customer & Revenue Analysis (SQL + Tableau)

Rockbuster Stealth is a global DVD rental company preparing for a streaming launch. This project answers key business questions about revenue drivers, customer geography, and high-value segments using PostgreSQL, and visualizes results in Tableau.

## Start here (primary deliverable)
**Presentation (PDF):** `docs/rockbuster-presentation.pdf`  
This is the main deliverable: a concise slide deck with the business questions, approach, key findings, and recommendations.

## Key findings
- Customer base is global, with demand concentrated in a small set of countries.
- Revenue is skewed: a minority of customers account for a disproportionate share (high-LTV segment).
- Rental behavior shows consistent patterns in average rental duration (see deck for details).

## Business questions answered
- Which movies contributed the most/least to revenue?
- What is the average rental duration?
- Which countries are customers based in?
- Where are high lifetime value customers located?
- Do sales figures vary by geographic region?

## Tableau links (interactive)
- [Customer Geography (Bubble Map)](https://public.tableau.com/views/RockbusterBubbleMap_17658994601690/Sheet1?:showVizHome=no)
- [Top Customer Countries](https://public.tableau.com/views/RockbusterTop10Cities_17659038031120/Sheet1?:showVizHome=no)
- [High Value Customers](https://public.tableau.com/views/Top5CustomersRockbusterNew/Sheet1?:showVizHome=no)
  
## Deliverables
- **Presentation (PDF) — primary deliverable:** `docs/rockbuster-presentation.pdf`
- **Data dictionary (PDF):** `docs/rockbuster-data-dictionary.pdf`
- **SQL (runnable):** `sql/02_queries.sql`
- **Schema notes (joins + definitions):** `sql/01_schema_notes.md`
- **Outputs (aggregated results):** `outputs/rockbuster-sql-outputs.xlsx`
- **ERD image:** `images/rockbuster-erd.png`

## How to use
1. Open `sql/01_schema_notes.md` for join paths + definitions.
2. Run queries in `sql/02_queries.sql` in PostgreSQL.
3. Compare your results to the aggregated outputs in `outputs/rockbuster-sql-outputs.xlsx`.
4. Use the Tableau links for interactive exploration.

## Tools
PostgreSQL, SQL (joins/CTEs/window functions), Excel (outputs), Tableau

## Note
This project was completed as part of the CareerFoundry Databases & SQL curriculum.
