
DROP VIEW IF EXISTS cohort_analysis;
CREATE OR REPLACE VIEW public.cohort_analysis
AS WITH customer_revenue AS (
         SELECT s.customerkey,
            s.orderdate,
            sum(s.quantity::double precision * s.netprice * s.exchangerate) AS net_revenue,
            count(s.orderkey) AS num_orders,
            c.countryfull,
            c.age,
            c.givenname,
            c.surname
           FROM sales s
             LEFT JOIN customer c ON c.customerkey = s.customerkey
          GROUP BY c.customerkey, s.customerkey, s.orderdate, c.countryfull, c.age, c.givenname, c.surname
        )
 SELECT customerkey,
    orderdate,
    MIN(orderdate) OVER (PARTITION BY customerkey) AS first_purchase_year,
    net_revenue,
    num_orders,
    countryfull,
    age,
    givenname,
    surname,
    EXTRACT(year FROM min(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
   FROM customer_revenue cr;