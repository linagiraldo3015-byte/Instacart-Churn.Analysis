select
	avg(total_orders) as avg_orders,
	avg(avg_days_between_orders) as avg_dias_entre_ordenes
from analytics.user_metrics; 

SELECT
    MIN(max_days_between_orders) as minimo,
    AVG(max_days_between_orders) as promedio,
    MAX(max_days_between_orders) as maximo
FROM analytics.user_metrics;
	

select 
	department,
	avg(total_reordered::float/total_bought::float)*100 as avg_reorder_rate
from analytics.product_metrics
group by department;

-cuantos usuarios concentran el 80% de las ordenes
WITH acumulado AS (
    SELECT
        user_id,
        total_orders,
        sum(total_orders) OVER (ORDER BY total_orders DESC, user_id)::float / 
        (SELECT sum(total_orders) FROM analytics.user_metrics) * 100 AS pct_acumulado
    FROM analytics.user_metrics
)
SELECT count(*) as usuarios_80pct
FROM acumulado
WHERE pct_acumulado <= 80;

--para definir usuarios en riesgo de churn diremos que cumple las siguientes condiciones:
-- . tiene avg_days_between_orders alto
-- . tiene total_orders bajo
-- . tiene reorder_rate bajo

--creo la columna de churn en analytics

ALTER TABLE analytics.user_metrics
ADD COLUMN churn INTEGER;

UPDATE analytics.user_metrics
SET churn = CASE
    WHEN user_segment = 'Ocasional' THEN 1
    ELSE 0
END;

SELECT 
    user_segment,
    churn,
    count(*) as total
FROM analytics.user_metrics
GROUP BY user_segment, churn
ORDER BY user_segment;
