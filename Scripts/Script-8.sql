EXPLAIN ANALYZE
SELECT
    c.customerkey,
    c.givenname,
    c.surname,
    p.productname,
    s.orderdate,
    s.orderkey,
    EXTRACT(YEAR FROM s.orderdate)AS YEAR		
FROM sales s
INNER JOIN customer c ON s.customerkey = c.customerkey
INNER JOIN product p ON p.productkey = s.productkey