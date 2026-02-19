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

# Rockbuster Customer & Revenue Analysis

## Overview
Rockbuster Stealth is a global DVD rental company preparing for a transition to streaming. This project analyzes transactional rental data using PostgreSQL to identify revenue drivers, geographic demand patterns, and high-value customer segments. Results are summarized in SQL outputs and visualized in Tableau to support strategic decision-making.

This repository contains the full analytical workflow: schema review, query development, aggregated outputs, and presentation-ready visuals.

---

## Business Objectives
The analysis addresses the following questions:

- Which films generate the highest and lowest revenue?
- What is the average rental duration (catalog vs. realized)?
- Where are customers geographically concentrated?
- Which customers represent the highest lifetime value (LTV)?
- How does revenue vary by country and region?

---

## Data Model
The Rockbuster dataset includes customer, rental, payment, inventory, film, and geographic tables. Revenue attribution and customer geography are derived through structured joins across these entities.

![Entity Relationship Diagram](images/rockbuster-erd.png)

---

## Methodology

**Revenue Definition**
Revenue is defined as `SUM(payment.amount)`. Film-level revenue is attributed through joins:
`payment → rental → inventory → film`.

**Customer Geography**
Customer location is derived via:
`customer → address → city → country`.

**High Lifetime Value Segment**
Customers are ranked by total lifetime revenue using window functions (NTILE) and segmented into deciles. The top decile represents the high-LTV segment.

All SQL queries are fully runnable and documented in `sql/analysis.sql`.

---

## Key Insights

### Global Customer Distribution
Revenue and customer counts are concentrated in a limited number of countries, with measurable variation in revenue per customer across regions.

![Customer Geography Map](images/customer-geography-map.png)

### Revenue Concentration Among Customers
Revenue is unevenly distributed, with a small subset of customers contributing a disproportionate share of total payments.

![Top Customers by Lifetime Value](images/top5_customers.png)

### Film-Level Revenue Variation
Certain titles significantly outperform others in total rental revenue, indicating opportunities for targeted content strategy and promotional emphasis.

---

## Repository Structure

```
rockbuster-sql-analysis/
│
├── docs/
│   ├── rockbuster-data-dictionary.pdf
│   └── rockbuster-presentation.pdf
│
├── images/
│   ├── rockbuster-erd.png
│   ├── customer-geography-map.png
│   └── top5_customers.png
│
├── outputs/
│   └── rockbuster-sql-outputs.xlsx
│
├── sql/
│   ├── schema-notes.md
│   └── analysis.sql
│
└── README.md
```

---

## Deliverables

- **SQL Analysis:** `sql/analysis.sql`
  Clean, sectioned queries with documented assumptions and QA checks.

- **Schema Notes:** `sql/schema-notes.md`
  Join paths, table relationships, and business definitions.

- **Aggregated Outputs:** `outputs/rockbuster-sql-outputs.xlsx`
  Tableau-ready summarized results.

- **Presentation Deck:** `docs/rockbuster-presentation.pdf`
  Executive summary of findings and recommendations.

---

## Tools & Techniques

- PostgreSQL
- Complex joins across normalized schemas
- Aggregations and grouping
- Common Table Expressions (CTEs)
- Window functions (NTILE, ranking)
- Data validation / QA checks
- Tableau (visualization)

---

## How to Reproduce the Analysis

1. Load the Rockbuster schema into PostgreSQL.
2. Review table relationships in `sql/schema-notes.md`.
3. Execute queries in `sql/analysis.sql` section by section.
4. Export result sets as CSV if needed for visualization.

---

## Summary
This project demonstrates end-to-end analytical workflow: structured data modeling, revenue attribution logic, customer segmentation, and geographic analysis using SQL. The repository is organized to reflect professional analytical practice, with clear documentation, reproducible queries, and presentation-ready outputs.
