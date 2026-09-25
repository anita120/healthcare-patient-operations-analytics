-- Healthcare Patient & Operations Analytics
-- PostgreSQL SQL Analysis
-- Synthetic healthcare dataset | January-December 2025
--
-- Tables:
-- patients
-- departments
-- providers
-- appointments
-- visits
-- billing
--
-- Purpose:
-- Analyze patient demand, appointment outcomes, operational efficiency,
-- provider workload, wait times, consultation duration, and billing patterns.
--
-- Important:
-- This analysis is descriptive. Observed relationships do not establish causality.
-- Provider workload is not a measure of provider performance.
-- When combining one-to-many tables, pre-aggregate before joining to avoid
-- duplicated totals.

-- =========================================================
-- STEP 1: DATA VALIDATION AND RECORD COUNTS
-- =========================================================

SELECT 'patients' AS table_name, COUNT(*) AS row_count FROM patients
UNION ALL
SELECT 'departments', COUNT(*) FROM departments
UNION ALL
SELECT 'providers', COUNT(*) FROM providers
UNION ALL
SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL
SELECT 'visits', COUNT(*) FROM visits
UNION ALL
SELECT 'billing', COUNT(*) FROM billing
ORDER BY table_name;


-- Primary-key uniqueness checks

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT patient_id) AS distinct_patient_ids
FROM patients;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT department_id) AS distinct_department_ids
FROM departments;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT provider_id) AS distinct_provider_ids
FROM providers;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT appointment_id) AS distinct_appointment_ids
FROM appointments;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT visit_id) AS distinct_visit_ids
FROM visits;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT bill_id) AS distinct_bill_ids
FROM billing;


-- Orphan-record checks

SELECT COUNT(*) AS orphan_appointments_patients
FROM appointments a
LEFT JOIN patients p
    ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

SELECT COUNT(*) AS orphan_appointments_providers
FROM appointments a
LEFT JOIN providers p
    ON a.provider_id = p.provider_id
WHERE p.provider_id IS NULL;

SELECT COUNT(*) AS orphan_appointments_departments
FROM appointments a
LEFT JOIN departments d
    ON a.department_id = d.department_id
WHERE d.department_id IS NULL;

SELECT COUNT(*) AS orphan_visits_appointments
FROM visits v
LEFT JOIN appointments a
    ON v.appointment_id = a.appointment_id
WHERE a.appointment_id IS NULL;

SELECT COUNT(*) AS orphan_billing_visits
FROM billing b
LEFT JOIN visits v
    ON b.visit_id = v.visit_id
WHERE v.visit_id IS NULL;


-- Basic appointment data-quality check

SELECT
    MIN(appointment_date) AS first_appointment_date,
    MAX(appointment_date) AS last_appointment_date,
    COUNT(*) AS total_appointments
FROM appointments;


-- =========================================================
-- STEP 2: APPOINTMENT FUNNEL
-- =========================================================

SELECT
    appointment_status,
    COUNT(*) AS appointment_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM appointments
GROUP BY appointment_status
ORDER BY appointment_count DESC;


-- Appointment KPI summary

SELECT
    COUNT(*) AS total_appointments,
    COUNT(*) FILTER (
        WHERE appointment_status = 'Completed'
    ) AS completed_appointments,
    COUNT(*) FILTER (
        WHERE appointment_status = 'No Show'
    ) AS no_show_appointments,
    COUNT(*) FILTER (
        WHERE appointment_status = 'Cancelled'
    ) AS cancelled_appointments,
    ROUND(
        COUNT(*) FILTER (
            WHERE appointment_status = 'Completed'
        ) * 100.0 / COUNT(*),
        2
    ) AS completion_rate,
    ROUND(
        COUNT(*) FILTER (
            WHERE appointment_status = 'No Show'
        ) * 100.0 / COUNT(*),
        2
    ) AS no_show_rate,
    ROUND(
        COUNT(*) FILTER (
            WHERE appointment_status = 'Cancelled'
        ) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM appointments;


-- =========================================================
-- STEP 3: NO-SHOW RATE BY DEPARTMENT
-- =========================================================

SELECT
    d.department_name,
    d.location,
    COUNT(*) AS total_appointments,
    COUNT(*) FILTER (
        WHERE a.appointment_status = 'Completed'
    ) AS completed_appointments,
    COUNT(*) FILTER (
        WHERE a.appointment_status = 'No Show'
    ) AS no_show_appointments,
    COUNT(*) FILTER (
        WHERE a.appointment_status = 'Cancelled'
    ) AS cancelled_appointments,
    ROUND(
        COUNT(*) FILTER (
            WHERE a.appointment_status = 'No Show'
        ) * 100.0 / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments a
JOIN departments d
    ON a.department_id = d.department_id
GROUP BY
    d.department_name,
    d.location
ORDER BY no_show_rate DESC;


-- =========================================================
-- STEP 4: APPOINTMENT VOLUME BY DEPARTMENT
-- =========================================================

SELECT
    d.department_name,
    d.location,
    COUNT(*) AS appointment_count,
    COUNT(*) FILTER (
        WHERE a.appointment_status = 'Completed'
    ) AS completed_count,
    COUNT(*) FILTER (
        WHERE a.appointment_status = 'No Show'
    ) AS no_show_count,
    COUNT(*) FILTER (
        WHERE a.appointment_status = 'Cancelled'
    ) AS cancelled_count
FROM appointments a
JOIN departments d
    ON a.department_id = d.department_id
GROUP BY
    d.department_name,
    d.location
ORDER BY appointment_count DESC;


-- =========================================================
-- STEP 5: DEPARTMENT-LEVEL PERFORMANCE SUMMARY
-- =========================================================

SELECT
    d.department_name,
    d.location,
    COUNT(a.appointment_id) AS total_appointments,
    COUNT(a.appointment_id) FILTER (
        WHERE a.appointment_status = 'Completed'
    ) AS completed_appointments,
    COUNT(a.appointment_id) FILTER (
        WHERE a.appointment_status = 'No Show'
    ) AS no_show_appointments,
    COUNT(a.appointment_id) FILTER (
        WHERE a.appointment_status = 'Cancelled'
    ) AS cancelled_appointments,
    ROUND(
        COUNT(a.appointment_id) FILTER (
            WHERE a.appointment_status = 'Completed'
        ) * 100.0 / COUNT(a.appointment_id),
        2
    ) AS completion_rate,
    ROUND(
        COUNT(a.appointment_id) FILTER (
            WHERE a.appointment_status = 'No Show'
        ) * 100.0 / COUNT(a.appointment_id),
        2
    ) AS no_show_rate
FROM departments d
LEFT JOIN appointments a
    ON d.department_id = a.department_id
GROUP BY
    d.department_name,
    d.location
ORDER BY total_appointments DESC;


-- =========================================================
-- STEP 6: BOOKING LEAD TIME VS OBSERVED NO-SHOW RATE
-- =========================================================

WITH booking_groups AS (
    SELECT
        appointment_id,
        appointment_status,
        scheduled_days_ahead,
        CASE
            WHEN scheduled_days_ahead = 0 THEN 'Same Day'
            WHEN scheduled_days_ahead <= 7 THEN '1-7 Days'
            WHEN scheduled_days_ahead <= 14 THEN '8-14 Days'
            WHEN scheduled_days_ahead <= 30 THEN '15-30 Days'
            ELSE '31+ Days'
        END AS booking_lead_group,
        CASE
            WHEN scheduled_days_ahead = 0 THEN 1
            WHEN scheduled_days_ahead <= 7 THEN 2
            WHEN scheduled_days_ahead <= 14 THEN 3
            WHEN scheduled_days_ahead <= 30 THEN 4
            ELSE 5
        END AS booking_lead_sort
    FROM appointments
)
SELECT
    booking_lead_group,
    COUNT(*) AS total_appointments,
    COUNT(*) FILTER (
        WHERE appointment_status = 'No Show'
    ) AS no_show_count,
    ROUND(
        COUNT(*) FILTER (
            WHERE appointment_status = 'No Show'
        ) * 100.0 / COUNT(*),
        2
    ) AS no_show_rate
FROM booking_groups
GROUP BY
    booking_lead_group,
    booking_lead_sort
ORDER BY booking_lead_sort;


-- =========================================================
-- STEP 7: PROVIDER WORKLOAD
-- =========================================================

SELECT
    p.provider_id,
    p.provider_name,
    d.department_name,
    p.experience_years,
    p.provider_type,
    COUNT(a.appointment_id) AS appointment_count,
    COUNT(a.appointment_id) FILTER (
        WHERE a.appointment_status = 'Completed'
    ) AS completed_appointments
FROM providers p
JOIN departments d
    ON p.department_id = d.department_id
LEFT JOIN appointments a
    ON p.provider_id = a.provider_id
GROUP BY
    p.provider_id,
    p.provider_name,
    d.department_name,
    p.experience_years,
    p.provider_type
ORDER BY appointment_count DESC;


-- =========================================================
-- STEP 8: PATIENT WAIT TIME
-- =========================================================

SELECT
    COUNT(*) AS completed_visits,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    v.consultation_start_time
                    - v.check_in_time
                )
            ) / 60.0
        ),
        2
    ) AS average_wait_minutes,
    ROUND(
        (
            PERCENTILE_CONT(0.5) WITHIN GROUP (
                ORDER BY EXTRACT(
                    EPOCH FROM (
                        v.consultation_start_time
                        - v.check_in_time
                    )
                ) / 60.0
            )
        )::numeric,
        2
    ) AS median_wait_minutes
FROM visits v;


-- =========================================================
-- STEP 9: WAIT TIME BY DEPARTMENT
-- =========================================================

SELECT
    d.department_name,
    d.location,
    COUNT(v.visit_id) AS completed_visits,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    v.consultation_start_time
                    - v.check_in_time
                )
            ) / 60.0
        ),
        2
    ) AS average_wait_minutes,
    ROUND(
        (
            PERCENTILE_CONT(0.5) WITHIN GROUP (
                ORDER BY EXTRACT(
                    EPOCH FROM (
                        v.consultation_start_time
                        - v.check_in_time
                    )
                ) / 60.0
            )
        )::numeric,
        2
    ) AS median_wait_minutes
FROM visits v
JOIN departments d
    ON v.department_id = d.department_id
GROUP BY
    d.department_name,
    d.location
ORDER BY average_wait_minutes DESC;


-- =========================================================
-- STEP 10: CONSULTATION DURATION
-- =========================================================

SELECT
    COUNT(*) AS completed_visits,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    v.consultation_end_time
                    - v.consultation_start_time
                )
            ) / 60.0
        ),
        2
    ) AS average_consultation_minutes,
    ROUND(
        (
            PERCENTILE_CONT(0.5) WITHIN GROUP (
                ORDER BY EXTRACT(
                    EPOCH FROM (
                        v.consultation_end_time
                        - v.consultation_start_time
                    )
                ) / 60.0
            )
        )::numeric,
        2
    ) AS median_consultation_minutes
FROM visits v;


-- Consultation duration by department

SELECT
    d.department_name,
    d.location,
    COUNT(v.visit_id) AS completed_visits,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    v.consultation_end_time
                    - v.consultation_start_time
                )
            ) / 60.0
        ),
        2
    ) AS average_consultation_minutes
FROM visits v
JOIN departments d
    ON v.department_id = d.department_id
GROUP BY
    d.department_name,
    d.location
ORDER BY average_consultation_minutes DESC;


-- =========================================================
-- STEP 11: BILLING BY DEPARTMENT
-- =========================================================

SELECT
    d.department_name,
    d.location,
    COUNT(b.bill_id) AS bill_count,
    ROUND(SUM(b.total_amount), 2) AS total_billing,
    ROUND(AVG(b.total_amount), 2) AS average_bill,
    ROUND(SUM(b.consultation_fee), 2) AS consultation_fees,
    ROUND(SUM(b.procedure_amount), 2) AS procedure_amount,
    ROUND(SUM(b.medication_amount), 2) AS medication_amount
FROM billing b
JOIN departments d
    ON b.department_id = d.department_id
GROUP BY
    d.department_name,
    d.location
ORDER BY total_billing DESC;


-- Overall billing summary

SELECT
    COUNT(*) AS bill_count,
    ROUND(SUM(total_amount), 2) AS total_billing,
    ROUND(AVG(total_amount), 2) AS average_bill,
    ROUND(SUM(consultation_fee), 2) AS consultation_fees,
    ROUND(SUM(procedure_amount), 2) AS procedure_amount,
    ROUND(SUM(medication_amount), 2) AS medication_amount
FROM billing;


-- =========================================================
-- STEP 12: BILLING BY INSURANCE TYPE
-- =========================================================

SELECT
    p.insurance_type,
    COUNT(b.bill_id) AS bill_count,
    ROUND(SUM(b.total_amount), 2) AS total_billing,
    ROUND(AVG(b.total_amount), 2) AS average_bill
FROM billing b
JOIN patients p
    ON b.patient_id = p.patient_id
GROUP BY p.insurance_type
ORDER BY total_billing DESC;


-- =========================================================
-- STEP 13: MONTHLY APPOINTMENT TREND
-- =========================================================

SELECT
    DATE_TRUNC('month', appointment_date)::date AS month,
    COUNT(*) AS total_appointments,
    COUNT(*) FILTER (
        WHERE appointment_status = 'Completed'
    ) AS completed_appointments,
    COUNT(*) FILTER (
        WHERE appointment_status = 'No Show'
    ) AS no_show_appointments,
    COUNT(*) FILTER (
        WHERE appointment_status = 'Cancelled'
    ) AS cancelled_appointments,
    ROUND(
        COUNT(*) FILTER (
            WHERE appointment_status = 'No Show'
        ) * 100.0 / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments
GROUP BY DATE_TRUNC('month', appointment_date)
ORDER BY month;


-- =========================================================
-- STEP 14: DAY-OF-WEEK APPOINTMENT DEMAND
-- =========================================================

SELECT
    EXTRACT(ISODOW FROM appointment_date)::integer AS day_number,
    TO_CHAR(appointment_date, 'Day') AS day_name,
    COUNT(*) AS appointment_count
FROM appointments
GROUP BY
    EXTRACT(ISODOW FROM appointment_date),
    TO_CHAR(appointment_date, 'Day')
ORDER BY day_number;


-- =========================================================
-- STEP 15: COMBINED OPERATIONAL ANALYSIS
-- =========================================================
--
-- Important:
-- Do not directly join appointments -> visits -> billing and then
-- aggregate all metrics in one query. One-to-many relationships can
-- multiply rows and inflate totals.
--
-- The query below pre-aggregates each subject area at department level
-- before combining the results.

WITH appointment_metrics AS (
    SELECT
        department_id,
        COUNT(*) AS total_appointments,
        COUNT(*) FILTER (
            WHERE appointment_status = 'Completed'
        ) AS completed_appointments,
        COUNT(*) FILTER (
            WHERE appointment_status = 'No Show'
        ) AS no_show_appointments,
        COUNT(*) FILTER (
            WHERE appointment_status = 'Cancelled'
        ) AS cancelled_appointments,
        ROUND(
            COUNT(*) FILTER (
                WHERE appointment_status = 'No Show'
            ) * 100.0 / COUNT(*),
            2
        ) AS no_show_rate
    FROM appointments
    GROUP BY department_id
),

visit_metrics AS (
    SELECT
        department_id,
        COUNT(*) AS completed_visits,
        ROUND(
            AVG(
                EXTRACT(
                    EPOCH FROM (
                        consultation_start_time
                        - check_in_time
                    )
                ) / 60.0
            ),
            2
        ) AS average_wait_minutes,
        ROUND(
            AVG(
                EXTRACT(
                    EPOCH FROM (
                        consultation_end_time
                        - consultation_start_time
                    )
                ) / 60.0
            ),
            2
        ) AS average_consultation_minutes
    FROM visits
    GROUP BY department_id
),

provider_metrics AS (
    SELECT
        department_id,
        COUNT(DISTINCT provider_id) AS provider_count,
        COUNT(appointment_id) AS provider_appointment_count
    FROM appointments
    GROUP BY department_id
),

billing_metrics AS (
    SELECT
        department_id,
        COUNT(*) AS bill_count,
        ROUND(SUM(total_amount), 2) AS total_billing,
        ROUND(AVG(total_amount), 2) AS average_bill
    FROM billing
    GROUP BY department_id
)

SELECT
    d.department_name,
    d.location,

    COALESCE(a.total_appointments, 0) AS total_appointments,
    COALESCE(a.completed_appointments, 0) AS completed_appointments,
    COALESCE(a.no_show_appointments, 0) AS no_show_appointments,
    COALESCE(a.cancelled_appointments, 0) AS cancelled_appointments,
    COALESCE(a.no_show_rate, 0) AS no_show_rate,

    COALESCE(v.completed_visits, 0) AS completed_visits,
    v.average_wait_minutes,
    v.average_consultation_minutes,

    COALESCE(pm.provider_count, 0) AS provider_count,

    COALESCE(b.bill_count, 0) AS bill_count,
    COALESCE(b.total_billing, 0) AS total_billing,
    COALESCE(b.average_bill, 0) AS average_bill

FROM departments d

LEFT JOIN appointment_metrics a
    ON d.department_id = a.department_id

LEFT JOIN visit_metrics v
    ON d.department_id = v.department_id

LEFT JOIN provider_metrics pm
    ON d.department_id = pm.department_id

LEFT JOIN billing_metrics b
    ON d.department_id = b.department_id

ORDER BY total_appointments DESC;


-- =========================================================
-- OPTIONAL: OVERALL EXECUTIVE KPI QUERY
-- =========================================================

SELECT
    (SELECT COUNT(*) FROM patients) AS total_patients,
    (SELECT COUNT(*) FROM appointments) AS total_appointments,
    (SELECT COUNT(*)
     FROM appointments
     WHERE appointment_status = 'Completed') AS completed_appointments,
    (SELECT COUNT(*)
     FROM appointments
     WHERE appointment_status = 'No Show') AS no_show_appointments,
    (SELECT COUNT(*)
     FROM appointments
     WHERE appointment_status = 'Cancelled') AS cancelled_appointments,
    ROUND(
        (
            SELECT COUNT(*)
            FROM appointments
            WHERE appointment_status = 'Completed'
        ) * 100.0 /
        (SELECT COUNT(*) FROM appointments),
        2
    ) AS completion_rate,
    ROUND(
        (
            SELECT COUNT(*)
            FROM appointments
            WHERE appointment_status = 'No Show'
        ) * 100.0 /
        (SELECT COUNT(*) FROM appointments),
        2
    ) AS no_show_rate,
    (
        SELECT COUNT(*)
        FROM visits
    ) AS completed_visits,
    (
        SELECT ROUND(
            AVG(
                EXTRACT(
                    EPOCH FROM (
                        consultation_start_time
                        - check_in_time
                    )
                ) / 60.0
            ),
            2
        )
        FROM visits
    ) AS average_wait_minutes,
    (
        SELECT ROUND(SUM(total_amount), 2)
        FROM billing
    ) AS total_billing;
