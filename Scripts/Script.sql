SELECT 
	cohort_year,
	SUM(net_revenue)
FROM
	cohort_analysis
GROUP BY
	cohort_year
ORDER BY cohort_year ooooooooooo