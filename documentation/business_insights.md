# Healthcare Patient & Operations Analytics

## Project Overview

This project analyzes a synthetic 2025 healthcare dataset to understand
patient demand, appointment outcomes, operational efficiency, provider
workload, and billing patterns.

The analysis uses SQL, Python/pandas, and Power BI to move from raw
operational data to decision-ready reporting.

**Business question:** Where are operational inefficiencies occurring,
and what patterns can help the healthcare organization improve patient
flow and resource utilization?

## Dataset Scope

The dataset represents a synthetic multi-location healthcare
organization covering January--December 2025.

  Dataset              Records
  ------------------ ---------
  Patients               6,000
  Departments               10
  Providers                 80
  Appointments         150,000
  Completed Visits     121,977
  Billing Records      121,977

Appointment outcomes:

-   Completed: 121,977 (81.32%)
-   No Show: 17,399 (11.60%)
-   Cancelled: 10,624 (7.08%)

## Key Findings

### 1. Appointment completion

The organization recorded 150,000 appointments during 2025. Of these,
81.32% were completed, while 11.60% were no-shows and 7.08% were
cancelled.

### 2. No-show patterns

No-show rates varied by department.

-   General Medicine: 14.31%
-   General Surgery: 13.41%
-   Pediatrics: 12.68%
-   ENT: 12.14%
-   Neurology: 11.88%
-   Cardiology: 9.21%

These differences identify departments that may warrant further
investigation of reminder and scheduling processes. The analysis is
descriptive and does not establish causality.

### 3. Patient wait time

Average patient wait time across completed visits was **32.75 minutes**.

Department-level averages:

-   General Surgery: 44.38 minutes
-   Neurology: 41.46 minutes
-   Pediatrics: 38.53 minutes
-   Gynecology: 35.61 minutes
-   Orthopedics: 33.43 minutes
-   General Medicine: 30.42 minutes
-   Cardiology: 27.59 minutes
-   ENT: 26.85 minutes
-   Dermatology: 23.86 minutes
-   Ophthalmology: 22.12 minutes

### 4. Consultation duration

Average consultation duration was **24.54 minutes** overall.

Longest average consultation durations:

-   General Surgery: 39.53 minutes
-   Neurology: 31.57 minutes
-   Orthopedics: 27.61 minutes
-   Gynecology: 24.62 minutes
-   Cardiology: 23.58 minutes

Consultation duration should be considered alongside patient volume and
wait time rather than treated as a standalone provider-performance
measure.

### 5. Demand by department

Highest appointment volumes:

-   Cardiology: 31,724
-   Pediatrics: 24,172
-   General Medicine: 17,001
-   General Surgery: 16,837
-   Orthopedics: 15,063

### 6. Billing

Total billing in the dataset was approximately **₹248.48 million**.

Highest department billing:

-   Cardiology: approximately ₹59M
-   Pediatrics: approximately ₹36M
-   General Surgery: approximately ₹30M
-   Orthopedics: approximately ₹26M
-   General Medicine: approximately ₹24M

Billing totals are influenced by patient and visit volume and should not
be treated as a standalone performance measure.

## Dashboard KPIs

-   Total Patients: 6,000
-   Total Appointments: 150,000
-   Completion Rate: 81.32%
-   No-show Rate: 11.60%
-   Average Wait Time: 32.75 minutes
-   Total Billing: approximately ₹248.48M

## Dashboard Views

1.  Appointment Outcomes
2.  Monthly Appointment Trend
3.  No-show Rate by Department
4.  Average Wait Time by Department
5.  Billing by Department

Interactive slicers:

-   Department
-   Location
-   Appointment Type
-   Booking Channel
-   Insurance Type

## Business Recommendations

1.  **Investigate high no-show departments** --- review scheduling and
    reminder processes where observed no-show rates are higher.
2.  **Review high-wait departments** --- examine patient flow,
    scheduling, check-in processes, and capacity.
3.  **Use demand and workload together** --- compare appointment volume,
    consultation duration, and wait time when assessing resources.
4.  **Monitor appointment outcomes monthly** --- track completion,
    no-show, and cancellation rates over time.
5.  **Use billing as a financial-volume indicator** --- interpret
    billing alongside visit volume and department activity.

## Analytical Limitations

-   The dataset is synthetic and does not represent a real healthcare
    organization.
-   The analysis is descriptive and does not establish causality.
-   Provider workload should not be interpreted as provider performance.
-   Billing totals are affected by department volume and should be
    interpreted in context.
-   One-to-many table joins require pre-aggregation to avoid duplicated
    totals.

## Tools Used

-   **PostgreSQL** --- data validation and SQL analysis
-   **Python / pandas** --- exploratory data analysis
-   **Power BI** --- interactive dashboard and business reporting

## Project Outcome

The project demonstrates an end-to-end analytics workflow:

**Business question → Data validation → SQL analysis → Python EDA →
Power BI dashboard → Business insights**

It demonstrates practical skills in healthcare operations analytics,
SQL, Python/pandas, data modeling, KPI development, and business
intelligence reporting.
