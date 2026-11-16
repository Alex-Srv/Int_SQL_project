WITH salaes_data AS (
SELECT 
	customerkey,
	SUM(quantity * netprice * exchangerate ) AS net_revenue
FROM
	sales
GROUP BY sales.customerkey 
)

SELECT 
	AVG(sd.net_revenue) ,
	avg(coalesce(sd.net_revenue,0 ))
FROM customer c 
LEFT JOIN salaes_data sd ON c.customerkey  = sd.customerkey 