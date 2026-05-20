--los usuarios que reordenan mas son los mas leales?

select 
	user_segment,
	ROUND(percentile_cont(0.25) within group (order by reorder_rate)::numeric,2)*100 as p25,
	ROUND(percentile_cont(0.50) within group (order by reorder_rate)::numeric,2)*100 as mediana,
	ROUND(percentile_cont(0.75) within group (order by reorder_Rate)::numeric,2)*100 as p75,
	ROUND(percentile_cont(0.90) within group (order by reorder_Rate)::numeric,2)*100 as p90

from analytics.user_metrics
group by user_segment;

