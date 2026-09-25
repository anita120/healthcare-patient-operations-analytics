# Healthcare Patient & Operations Analytics

Synthetic healthcare analytics portfolio project using SQL, Python/pandas and Power BI.

**Analysis period:** January 1, 2025 – December 31, 2025

All patient, provider, appointment, visit and billing data is synthetic and created for portfolio/learning purposes. It does not represent real patients or real healthcare records.

## Files
- patients.csv — 6,000 rows
- departments.csv — 10 rows
- providers.csv — 80 rows
- appointments.csv — 150,000 rows
- visits.csv — 121,977 rows
- billing.csv — 121,977 rows
- data_dictionary.csv — field definitions

## Relationships
- patients.patient_id → appointments.patient_id
- providers.provider_id → appointments.provider_id
- departments.department_id → appointments.department_id
- appointments.appointment_id → visits.appointment_id
- visits.visit_id → billing.visit_id

## Business questions
1. Which departments and locations handle the highest appointment volumes?
2. Which departments have the highest no-show rates?
3. Does booking lead time appear related to no-shows?
4. Which providers have the highest workload and completed-visit volume?
5. Which departments have the longest average patient wait times?
6. Which departments have the longest average consultation duration?
7. How does billing vary by department, visit type and insurance type?
8. Which months or days have the highest appointment demand?
9. Which departments combine high volume with high wait times or high no-show rates?

Observed relationships are associations in this synthetic dataset, not causal healthcare conclusions.
