# User Funnel & Retention Analysis (Product Analytics, SQL)

This project is a **Meta-style Product Analytics** case study focused on:
- **Funnel analysis** (signup → onboarding → activation → engagement)
- **Cohort retention** (D1 / D7 retention)
- **Metric definition and interpretation**

✅ **GitHub-friendly:** No large datasets are committed. The notebook **generates synthetic event logs on run**.

---

## Repo Structure
```
user-funnel-retention-analysis/
├── notebooks/
│   └── funnel_retention_analysis.ipynb
├── sql/
│   ├── 01_funnel.sql
│   ├── 02_retention_cohorts.sql
│   └── 03_segment_breakdowns.sql
├── src/
│   └── generate_events.py
├── .gitignore
├── requirements.txt
└── README.md
```

---

## Quick Start
1. Open `notebooks/funnel_retention_analysis.ipynb`
2. Run all cells:
   - Generates synthetic `events` data
   - Computes funnel conversion + drop-offs
   - Computes cohort retention (D1, D7)
   - Runs segment cuts by device and country

> Optional: You can export the generated dataset locally if you want to explore it in another tool.
(Do **not** commit generated CSVs to GitHub.)

---

## Metrics (Definitions)
- **Funnel conversion rate:** % of users who reach each step from signup
- **Activation rate:** % of signed-up users who activate (e.g., add_friend or follow_creator)
- **D1 retention:** % of users active the day after signup
- **D7 retention:** % of users active 7 days after signup

---

## Skills Demonstrated
- Product metrics definition & measurement
- SQL analytics patterns (CTEs, window functions, conditional aggregation)
- Cohort analysis and retention curves
- Clear interpretation and business recommendations

---

## Author
**Ankit Tadla**
