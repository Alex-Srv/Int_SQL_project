WITH customer_ltv AS(
	SELECT
		customerkey,
		full_name ,
		SUM(net_revenue) AS total_ltv
	FROM cohort_analysis
	GROUP BY 
		customerkey,
		full_name 
	) ,
customer_segments AS(
	SELECT 
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th_percentile,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th_percentile
	FROM customer_ltv 
),
segment_value AS (
	SELECT 
		c.*,
		CASE
			WHEN c.total_ltv < cs.ltv_25th_percentile THEN '1 - Low-Value'
			-- условный порог (например, 25-й перцентиль)
			WHEN c.total_ltv <= cs.ltv_75th_percentile THEN '2 - Mid-Value'
			-- условный порог (например, 75-й перцентиль)
			ELSE '3 - High-Value'
		END AS customer_segment,
		ltv_25th_percentile,
		ltv_75th_percentile
	FROM
		customer_ltv c
	CROSS JOIN customer_segments cs
)
	
SELECT 	
	customer_segment,
	sum(total_ltv) AS total_ltv ,
	COUNT(customerkey) AS count,
	SUM(total_ltv) / COUNT(customerkey ) AS value_per_customer
FROM
	segment_value
GROUP BY 
	customer_segment