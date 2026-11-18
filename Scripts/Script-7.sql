
EXPLAIN ANALYZE
SELECT
    customerkey,
    orderdate,
    orderkey,
    SUM(quantity * netprice * exchangerate) AS net_revenue
FROM sales
GROUP BY
    customerkey,
    orderdate,
    orderkey