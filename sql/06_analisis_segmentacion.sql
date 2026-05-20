--distribucion porcentual de mis segmentos:
SELECT 
    user_segment,
    count(*) as total_usuarios,
    count(*)::float / (SELECT count(*) FROM analytics.user_metrics) * 100 as porcentaje
FROM analytics.user_metrics
GROUP BY user_segment
ORDER BY total_usuarios DESC;





	
--distribucion de segmentos de productos:
	
SELECT 
    product_segment,
    count(*) as total_productos,
    count(*)::float / (SELECT count(*) FROM analytics.product_metrics) * 100 as porcentaje
FROM analytics.product_metrics
GROUP BY product_segment
ORDER BY total_productos DESC;


--que diferencia a un usuario de alto valor de uno ocasional?

select 
	user_segment,
	avg(total_orders) as avg_orders,
	avg(avg_days_between_orders) as total_avg_days_between_orders,
	avg(max_days_between_orders) as total_avg_max_days_between_orders,
	avg(total_products_bought) as total_avg_products_bought,
	avg(reorder_rate) as avg_reorder_rate
from analytics.user_metrics
where user_segment = 'VIP' or user_segment = 'Ocasional'
group by user_segment;