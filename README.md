Layoffs SQL Exploratory Data Analysis (EDA)

This project explores global tech layoffs using SQL. The goal is to uncover trends by company, industry, country, and time — and to evaluate how funding levels and startup stage relate to layoffs.

---

Data Source & Preparation

The dataset was sourced from [Layoffs.fyi](https://layoffs.fyi/) and cleaned in a separate repository:  
[Layoffs Data Cleaning Repository](https://github.com/jkselig/layoffs-data-cleaning)

After cleaning, the data was imported into a SQL table named `layoffs_staging2` for analysis.

---

Key Questions Explored

- Which companies laid off the most employees?
- What industries and countries were hit hardest?
- How did layoffs trend over time?
- Were layoffs tied to funding size or startup stage?
- Which companies had the highest average layoff percentage?
- Which companies laid off the most per $1M raised?

---

Analysis Highlights

✅ Monthly and rolling totals for layoffs  
✅ Top 5 companies by layoffs per year  
✅ Funding brackets linked to layoff behavior  
✅ Normalized metrics: layoffs per $1M raised  
✅ Average % laid off by company, industry, and country  
✅ Industry and country-level comparisons

---

Tools Used

- **SQL**
  - CTEs, window functions, aggregates, CASE
---

Project Structure

```
layoffs-sql-eda/
│
├── README.md                # Project overview and insights
├── layoffs_eda.sql          # Fully commented SQL analysis
└── Summary of Findings - Layoffs EDA
---

Contact

Built by [Jeremy Selig](https://github.com/jkselig)  
For questions or feedback, feel free to reach out!

