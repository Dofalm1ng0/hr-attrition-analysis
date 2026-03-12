# HR Attrition Analysis
### Business Intelligence Project | SQL · MySQL · Python · Power BI

[![Power BI Dashboard](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)](YOUR_POWERBI_URL_HERE)
[![Python](https://img.shields.io/badge/Python-3.x-blue)](https://python.org)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange)](https://mysql.com)

---

## Live Dashboard
**[View Interactive Power BI Dashboard →](https://app.powerbi.com/view?r=eyJrIjoiZDczNGIwZmEtNTgyYS00Mzg0LWI2Y2MtMDQ1ZjU2NWVjMzY3IiwidCI6Ijg3ZDBjNmIyLTE0YWQtNDA3Mi05YzE5LTc0OGFiZGIxODIwNSIsImMiOjEwfQ%3D%3D)**

---

## Project Overview

End-to-end Business Intelligence project analysing employee attrition across 1,470 employees using the IBM HR Analytics dataset. The project follows a complete BA workflow - relational database design, SQL analysis, and a 4-page Power BI dashboard connected directly to MySQL.

**Business Question:** Where is attrition risk concentrated across this organisation and which interventions should HR prioritise first?

---

## Key Findings

| Finding | Number |
|---|---|
| Overall attrition rate | 16.1% (237 of 1,470 employees) |
| Sales department attrition | 20.6% - highest of 3 departments |
| Overtime employees attrition rate | 30.5% vs 10.4% non-overtime (3x rate) |
| Early tenure attrition (0–2 years) | 28.3% - 4x the rate of 10+ year employees |
| Average income gap: leavers vs stayers | $4,787 vs $6,833 - 30% difference |
| Highest risk job role | Sales Representatives (~40% attrition rate) |
| Highest risk segment | Sales department, Job Level 1 |

**Top 3 actionable recommendations:**
1. **Reduce overtime exposure** - overtime employees leave at 3x the rate. Cap mandatory overtime in Sales and R&D to cut the 30.5% attrition rate.
2. **Fix early-tenure experience** - 28.3% of employees in their first 2 years leave. Structured onboarding and 90-day check-ins are the highest-ROI intervention.
3. **Address Sales compensation at entry level** - Sales Level 1 employees show the highest attrition of any department-level combination. A targeted compensation review for this segment would reduce the largest single concentration of attrition risk.

---

## Project Architecture

```
IBM HR Analytics Dataset (CSV)
         ↓
Python: Data Cleaning + Schema Preparation
         ↓
MySQL: Relational Database (4 tables, 3 foreign keys, 1 VIEW)
         ↓
SQL: 10 Analytical Queries (CTEs, Window Functions, Multi-table JOINs)
         ↓
Power BI: 4-Page Dashboard (connected directly to MySQL)
         ↓
Business Recommendations
```

---

## Database Schema

```
departments (3 rows)
     │
     │ department_id (FK)
     ▼
employees (1,470 rows)  ←── PRIMARY TABLE
     │
     │ employee_id (FK)
     ├──────────────────────▶ job_details (1,470 rows)
     └──────────────────────▶ satisfaction (1,470 rows)

VIEW: employee_full = all 4 tables joined → Power BI data source
```

**Tables:**
- `employees` - demographics, education, attrition flag
- `job_details` - role, level, compensation, tenure, travel
- `satisfaction` - all 5 satisfaction dimensions + performance rating
- `departments` - department lookup table

---

## SQL Highlights

10 queries covering the full attrition story:

| Query | Business Question | SQL Technique |
|---|---|---|
| Q1 | Attrition rate by department | JOIN, GROUP BY, CASE WHEN |
| Q2 | Attrition by tenure band | CASE WHEN bucketing |
| Q3 | Salary: leavers vs stayers | Multi-metric AVG aggregation |
| Q4 | High-risk department × level segments | CTE + 3-table JOIN |
| Q5 | Job role ranking within departments | RANK() OVER PARTITION BY |
| Q6 | Satisfaction scores: leavers vs stayers | Multi-column AVG, 4-table JOIN |
| Q7 | Overtime impact on attrition | Conditional aggregation |
| Q8 | Career stagnation analysis | CASE WHEN + promotion gap |
| Q9 | Salary quartile analysis by role | NTILE() window function |
| Q10 | Executive summary - all departments | 4-table JOIN, 6 simultaneous metrics |

---

## Power BI Dashboard — 4 Pages

**Page 1 - Executive Overview**
KPI cards (total employees, attrition rate, avg salary) + department attrition bar chart + headcount donut + summary table

**Page 2 - Attrition Deep Dive**
Tenure band analysis + overtime impact + salary comparison leavers vs stayers + attrition by years at company

**Page 3 - Satisfaction Analysis**
Scatter plot (income vs satisfaction by attrition) + satisfaction scores leavers vs stayers + work-life balance and environment satisfaction analysis

**Page 4 - At-Risk Segments**
Job role ranking + Department × Job Level heat map matrix + promotion gap + business travel impact + tenure band

---

## Tools and Technologies

| Tool | Usage |
|---|---|
| Python (Pandas, NumPy) | Data cleaning, schema splitting, MySQL loading |
| MySQL 8.0 | Relational database design, schema creation, SQL queries |
| SQLAlchemy | Python-to-MySQL connection |
| Power BI Desktop | Dashboard development, DAX measures, calculated columns |
| Power BI Service | Dashboard publishing and public sharing |

---

## Repository Structure

```
hr-attrition-analysis/
├── HR_Attrition_Analysis.ipynb    ← Python notebook (cleaning + MySQL loading)
├── sql/
│   └── queries.sql                ← All 10 analytical SQL queries
├── data/
│   └── schema_diagram.png         ← Database schema diagram
└── README.md
```

---

## Dataset

IBM HR Analytics Employee Attrition & Performance dataset
Source: [Kaggle](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)
Records: 1,470 employees × 35 features
Target variable: Attrition (Yes/No → 1/0)

---

## Connect

**Rajat Kumar** - MBA, IIM Udaipur
[LinkedIn](https://www.linkedin.com/in/rajatkumar97611/) · [GitHub](https://github.com/Dofalm1ng0)
