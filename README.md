# Healthcare Patient & Operations Analytics

**End-to-end healthcare analytics project using PostgreSQL,
Python/pandas, and Power BI**

------------------------------------------------------------------------

## 📌 Project Overview

Healthcare organizations generate large volumes of patient, appointment,
provider, visit, and billing data. Analyzing these datasets together can
help identify operational patterns and areas that may require further
investigation.

This project analyzes a **synthetic multi-location healthcare dataset
covering January--December 2025**.

### Business Question

> **Where are operational inefficiencies occurring, and what patterns
> can help the healthcare organization improve patient flow and resource
> utilization?**

### Analytics Workflow

**Business Question → Data Validation → SQL Analysis → Python EDA →
Power BI Dashboard → Business Insights**

------------------------------------------------------------------------

## 🎯 Business Objectives

1.  Measure appointment demand and completion.
2.  Analyze no-show and cancellation patterns.
3.  Compare appointment activity across departments.
4.  Analyze patient wait times.
5.  Analyze consultation duration.
6.  Understand provider workload.
7.  Analyze billing patterns by department and insurance type.
8.  Identify operational patterns that may warrant further
    investigation.
9.  Build an interactive Power BI dashboard.
10. Translate analytical findings into business-oriented insights.

------------------------------------------------------------------------

## 📊 Dataset

The project uses a **synthetic healthcare dataset created for portfolio
and demonstration purposes**.

  --------------------------------------------------------------------------
  Dataset                 Description                                Records
  ----------------------- --------------------- ----------------------------
  `patients.csv`          Patient demographics                         6,000
                          and registration      
                          information           

  `departments.csv`       Department, location                            10
                          and specialty         
                          information           

  `providers.csv`         Provider and                                    80
                          department            
                          information           

  `appointments.csv`      Appointment                                150,000
                          scheduling and        
                          outcome information   

  `visits.csv`            Completed visit,                           121,977
                          wait-time and         
                          consultation          
                          information           

  `billing.csv`           Billing and payment                        121,977
                          information           

  `data_dictionary.csv`   Field definitions and                           49
                          descriptions          
  --------------------------------------------------------------------------

**Analysis Period:** January 1, 2025 -- December 31, 2025

**Data Type:** Synthetic data --- no real patient information is used.

------------------------------------------------------------------------

## 🗂️ Data Model

``` text
Patients
   |
   | 1 : Many
   v
Appointments
   |
   | 1 : Many
   v
Visits
   |
   | 1 : Many
   v
Billing


Departments
   |
   | 1 : Many
   v
Providers
   |
   | 1 : Many
   v
Appointments
```

### Key Relationships

``` text
patients.patient_id
        ↓
appointments.patient_id

providers.provider_id
        ↓
appointments.provider_id

departments.department_id
        ↓
providers.department_id

departments.department_id
        ↓
appointments.department_id

appointments.appointment_id
        ↓
visits.appointment_id

visits.visit_id
        ↓
billing.visit_id
```

------------------------------------------------------------------------

# 🔎 Key Findings

## 1. Appointment Outcomes

The dataset contains **150,000 appointments** during 2025.

  Outcome         Count     Rate
  ----------- --------- --------
  Completed     121,977   81.32%
  No Show        17,399   11.60%
  Cancelled      10,624    7.08%

The appointment funnel provides a high-level view of completed and lost
appointment opportunities.

------------------------------------------------------------------------

## 2. No-show Patterns

Observed no-show rates varied across departments.

  Department           No-show Rate
  ------------------ --------------
  General Medicine           14.31%
  General Surgery            13.41%
  Pediatrics                 12.68%
  ENT                        12.14%
  Neurology                  11.88%
  Dermatology                11.03%
  Gynecology                 10.95%
  Orthopedics                10.45%
  Ophthalmology              10.35%
  Cardiology                  9.21%

These differences identify departments that may warrant further
investigation of scheduling and reminder processes.

> **Important:** This is descriptive analysis. The project does not
> claim that department, scheduling, or another factor causes no-shows.

------------------------------------------------------------------------

## 3. Patient Wait Time

Average wait time across completed visits was:

### **32.75 minutes**

  Department           Average Wait Time
  ------------------ -------------------
  General Surgery              44.38 min
  Neurology                    41.46 min
  Pediatrics                   38.53 min
  Gynecology                   35.61 min
  Orthopedics                  33.43 min
  General Medicine             30.42 min
  Cardiology                   27.59 min
  ENT                          26.85 min
  Dermatology                  23.86 min
  Ophthalmology                22.12 min

------------------------------------------------------------------------

## 4. Consultation Duration

Average consultation duration across completed visits was:

### **24.54 minutes**

  Department           Average Consultation
  ------------------ ----------------------
  General Surgery                 39.53 min
  Neurology                       31.57 min
  Orthopedics                     27.61 min
  Gynecology                      24.62 min
  Cardiology                      23.58 min
  Pediatrics                      21.68 min
  Ophthalmology                   20.65 min
  Dermatology                     19.86 min
  ENT                             18.92 min
  General Medicine                17.91 min

------------------------------------------------------------------------

## 5. Appointment Demand

  Department           Appointments
  ------------------ --------------
  Cardiology                 31,724
  Pediatrics                 24,172
  General Medicine           17,001
  General Surgery            16,837
  Orthopedics                15,063

------------------------------------------------------------------------

## 6. Billing

Total billing in the dataset was approximately:

### **₹248.48 million**

  Department           Approx. Billing
  ------------------ -----------------
  Cardiology                      ₹59M
  Pediatrics                      ₹36M
  General Surgery                 ₹30M
  Orthopedics                     ₹26M
  General Medicine                ₹24M

Billing totals are influenced by patient and visit volume and should
therefore be interpreted in operational context.

------------------------------------------------------------------------

# 📈 Power BI Dashboard

## Healthcare Patient & Operations Analytics

**Patient Demand, Appointment Outcomes & Operational Performance \|
2025**

### Dashboard KPIs

-   **Total Patients:** 6,000
-   **Total Appointments:** 150,000
-   **Completion Rate:** 81.32%
-   **No-show Rate:** 11.60%
-   **Average Wait Time:** 32.75 minutes
-   **Total Billing:** approximately ₹248.48M

### Dashboard Views

1.  Appointment Outcomes
2.  Monthly Appointment Trend
3.  No-show Rate by Department
4.  Average Wait Time by Department
5.  Billing by Department

### Interactive Filters

-   Department
-   Location
-   Appointment Type
-   Booking Channel
-   Insurance Type

------------------------------------------------------------------------

# 🧮 SQL Analysis

PostgreSQL was used for data validation and business analysis.

The SQL analysis includes:

-   Data and record validation
-   Appointment funnel analysis
-   Department-level no-show analysis
-   Appointment volume by department
-   Department-level performance analysis
-   Booking lead-time analysis
-   Provider workload analysis
-   Patient wait-time analysis
-   Consultation duration analysis
-   Billing analysis
-   Billing by insurance type
-   Monthly appointment trends
-   Day-of-week demand
-   Combined operational analysis

### Important SQL Consideration

A key SQL consideration was avoiding inflated totals caused by
**one-to-many joins**.

Pre-aggregated CTEs were used where necessary before combining
department-level metrics.

------------------------------------------------------------------------

# 🐍 Python EDA

Python and pandas were used for exploratory data analysis.

The analysis included:

-   Dataset loading and validation
-   Missing-value checks
-   Date and time preparation
-   Appointment outcome analysis
-   Department analysis
-   No-show analysis
-   Booking lead-time analysis
-   Patient wait-time analysis
-   Consultation duration
-   Provider workload
-   Monthly trends
-   Day-of-week demand
-   Billing analysis
-   Insurance analysis
-   Patient demographics
-   Supporting visualizations
-   Exportable analysis tables

------------------------------------------------------------------------

# 💡 Business Insights

### 1. Investigate high no-show departments

Departments with higher observed no-show rates can be reviewed for
scheduling and reminder processes.

### 2. Review high-wait departments

Departments with higher observed wait times can be examined for patient
flow, scheduling, check-in processes, and capacity.

### 3. Consider demand and workload together

Appointment volume, consultation duration, and wait time provide more
useful operational context when considered together.

### 4. Monitor appointment outcomes over time

Monthly monitoring of completion, no-show, and cancellation rates can
help identify changes in demand or appointment behavior.

### 5. Interpret billing alongside operational volume

Billing should be evaluated alongside visit volume and department
activity rather than used as a standalone performance measure.

------------------------------------------------------------------------

# 🛠️ Tools & Technologies

### PostgreSQL / SQL

-   Data validation
-   Referential integrity checks
-   Joins
-   Aggregations
-   Common Table Expressions (CTEs)
-   KPI calculations
-   Operational analysis

### Python / pandas

-   Data preparation
-   Exploratory Data Analysis
-   Data quality checks
-   Grouped analysis
-   Trend analysis
-   Statistical exploration
-   Visualization

### Power BI

-   Data modeling
-   KPI development
-   Interactive reporting
-   Department analysis
-   Appointment trend analysis
-   Dashboard visualization
-   Business reporting

------------------------------------------------------------------------

# 📁 Repository Structure

``` text
healthcare-patient-operations-analytics/
│
├── README.md
│
├── data/
│   ├── patients.csv
│   ├── providers.csv
│   ├── departments.csv
│   ├── appointments.csv
│   ├── visits.csv
│   ├── billing.csv
│   └── data_dictionary.csv
│
├── sql/
│   └── healthcare_analysis.sql
│
├── python/
│   └── healthcare_eda.ipynb
│
├── powerbi/
│   └── healthcare_operations_dashboard.pbix
│
├── screenshots/
│   └── dashboard_overview.png
│
└── documentation/
    └── business_insights.md
```

------------------------------------------------------------------------

# ⚠️ Analytical Limitations

-   The dataset is synthetic and does not represent a real healthcare
    organization.
-   The analysis is descriptive and does not establish causality.
-   Provider workload should not be interpreted as provider performance.
-   Billing totals are affected by department and visit volume.
-   One-to-many table relationships require careful aggregation to avoid
    duplicated totals.
-   Observed department differences should be investigated further
    before operational decisions are made.

------------------------------------------------------------------------

# 🎓 Portfolio Skills Demonstrated

-   SQL
-   PostgreSQL
-   Data Cleaning
-   Data Validation
-   Relational Data Modeling
-   Exploratory Data Analysis
-   Python
-   pandas
-   KPI Development
-   Healthcare Operations Analytics
-   Power BI
-   Data Visualization
-   Business Intelligence
-   Dashboard Development
-   Business Insight Generation

------------------------------------------------------------------------

# ✅ Project Outcome

This project demonstrates an end-to-end analytics workflow:

**Business Question → Data Validation → SQL Analysis → Python EDA →
Power BI Dashboard → Business Insights**

It demonstrates how a Data Analyst can combine **technical data skills
with business-oriented analysis** to transform operational data into
clear, decision-ready reporting.

------------------------------------------------------------------------

## 📌 Portfolio Note

**Data source:** Synthetic dataset created specifically for portfolio
and demonstration purposes.

**Privacy:** No real patient or personally identifiable healthcare
information is included.
