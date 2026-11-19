WITH customer_last_purchase AS (SELECT
	customerkey ,
	cohort_year ,
	full_name ,
	orderdate ,
	row_number() OVER(PARTITION BY customerkey ORDER BY orderdate DESC )AS rn,
	first_purchase_year 
FROM 
	cohort_analysis
), churned_customers AS (
SELECT
	customerkey ,
	full_name,
	cohort_year ,
	orderdate ,
	CASE
			WHEN orderdate  < (SELECT MAX(orderdate)FROM sales)::date-INTERVAL '6 months'
			THEN 'Churned'
			ELSE 'Active'
	END AS customer_status
	
FROM customer_last_purchase 
WHERE rn =1
	AND first_purchase_year  <(SELECT MAX(orderdate)FROM sales)::date - INTERVAL '6 months'
)SELECT
	customer_status,
	COUNT(customerkey) AS num_customers,
	SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year ) AS total_customers,
	cohort_year ,
	CAST(((COUNT(customerkey )/SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year )) * 100)AS integer) AS status_percent
FROM
	churned_customers
GROUP BY
	customer_status,
	cohort_year 