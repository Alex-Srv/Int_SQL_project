EXPLAIN ANALYZE
SELECT 
	customerkey,
	SUM(quantity * netprice * exchangerate) AS net_revenue
FROM
	sales
GROUP BY 
	customerkey
LIMIT 10
	
