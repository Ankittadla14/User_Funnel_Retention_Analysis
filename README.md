# 📊 User Funnel & Retention Analysis (Product Analytics, SQL)

This project presents a **Meta-style product analytics case study** focused on understanding **user funnels, activation, and retention** using SQL and Python on synthetic event-level data.

The notebook **auto-generates realistic product event logs**, enabling reproducible analysis without committing large datasets.

---

## 🔍 Problem Statement
How do users progress through the product experience after signup, and where do we lose them?

Specifically:
- Where are the **largest funnel drop-offs**?
- What are the **D1 and D7 retention levels**?
- How do engagement patterns vary by **country and device**?

---

## 🧱 Data Overview
- **Users:** 60,000  
- **Events:** ~266K event records  
- **Event types:** signup, onboarding_complete, activation (add_friend / follow_creator), engagement (view_feed, like, comment, share)
- **Dimensions:** country, device_type  
- **Time range:** 21 days  

> Data is synthetically generated to simulate realistic product usage patterns.

---

## Repo Structure
-user-funnel-retention-analysis/
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

--

## 📐 Metrics Definitions
- **Funnel conversion rate:** % of users who reach each step from signup
- **Activation rate:** % of signed-up users who activate (e.g., add_friend or follow_creator)
- **Engagement rate:** % of users who meaningfully interact with content
- **D1 retention:** % of users active the day after signup
- **D7 retention:** % of users active 7 days after signup

---

## 🔄 Funnel Analysis Results

| Step | Users | Conversion from Signup |
|-----|------|------------------------|
| Signed Up | 60,000 | 100% |
| Onboarded | 47,801 | **79.7%** |
| Activated | 25,809 | **43.0%** |
| Engaged | 42,467 | **70.8%** |

**Key Insight:**  
The largest drop-off occurs between onboarding and activation, suggesting an opportunity to improve early engagement nudges (e.g., follow suggestions or friend recommendations).

---

## 🔁 Retention Analysis (Cohorts)
- **Average D1 retention:** ~45–47%
- **Average D7 retention:** ~31–33%
- Retention trends are stable across signup cohorts, indicating no systemic onboarding or engagement regressions.

**Interpretation:**  
D1 retention is healthy for a consumer social product. D7 retention shows expected decay, highlighting the importance of improving activation quality rather than just onboarding completion.

---

## 🌍 Segment Analysis (Country × Device)
Key patterns observed:
- iOS users consistently show higher engagement rates than Web users.
- Web users underperform across onboarding, activation, and engagement.
- Device differences outweigh geography in explaining engagement variance.

Example:
- **US + iOS engagement rate:** ~72%
- **US + Web engagement rate:** ~68%

---

## 🧠 Product Recommendations
1. Improve activation nudges immediately after onboarding (e.g., guided follows).
2. Prioritize Web onboarding UX improvements.
3. Run a follow-up A/B experiment focused on activation mechanics.
4. Monitor cohort retention segmented by device to detect regressions.

---

## 🛠 Tools & Skills Demonstrated
- SQL (CTEs, conditional aggregation, cohort analysis)
- Funnel and retention analytics
- Product metrics definition
- Synthetic data generation
- Data visualization and storytelling
- Product insight and recommendation framing

---

## ▶ How to Run
1. Open `notebooks/funnel_retention_analysis.ipynb`
2. Run all cells
3. Dataset is generated automatically on execution

> Generated data files are excluded from GitHub via `.gitignore`.

---

## 👤 Author
**Ankit Tadla**  
MPS Data Science & Applications, University at Buffalo  
Aspiring Product Data Scientist | Product Analytics | Experimentation
