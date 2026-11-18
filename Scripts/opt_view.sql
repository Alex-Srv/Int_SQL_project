-- public.cohort_analysis source
DROP VIEW cohort_analysis;
CREATE OR REPLACE
VIEW cohort_analysis AS
 WITH customer_revenue AS (
	SELECT
		s.customerkey,
		s.orderdate,
		sum(s.quantity::double PRECISION * s.netprice * s.exchangerate) AS net_revenue,
		count(s.orderkey) AS num_orders,
		MAX(c.countryfull) AS countryfull,
		MAX(c.age) AS age,
		MAX(c.givenname) AS givenname,
		MAX(c.surname) AS surname
	FROM
		sales s
	INNER JOIN customer c ON
		c.customerkey = s.customerkey
	GROUP BY
		c.customerkey,
		s.customerkey,
		s.orderdate,
		c.age,
		c.givenname,
		c.surname
)
 SELECT
	customerkey,
	orderdate,
	min(orderdate) OVER (
		PARTITION BY customerkey
	) AS first_purchase_year,
	net_revenue,
	num_orders,
	countryfull,
	age,
	concat(TRIM(BOTH FROM givenname), ' ', TRIM(BOTH FROM surname)) AS full_name,
	EXTRACT(YEAR FROM min(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
FROM
	customer_revenue;