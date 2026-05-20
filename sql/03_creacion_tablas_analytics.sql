CREATE TABLE analytics.user_metrics (
    user_id INTEGER,
    total_orders INTEGER,
    avg_days_between_orders FLOAT,
    max_days_between_orders FLOAT,
    total_products_bought INTEGER,
    reorder_rate FLOAT,
    user_segment VARCHAR(20)
);


---query principal de users para crear la de analytics:

with main_user_table as(
select 
	user_id,
	count(order_id) as total_orders,
	avg(days_since_prior_order) as avg_days_between_orders,
	max(days_since_prior_order) as max_days_between_orders
from staging.orders 
group by user_id
)
, products_per_user as(
select
    o.user_id,
    count(opp.product_id) as total_products_bought,
    avg(opp.reordered::float) as reorder_rate
from staging.order_products_prior opp
left join staging.orders o
on o.order_id = opp.order_id
group by o.user_id
)
SELECT
    m.user_id,
    m.total_orders,
    m.avg_days_between_orders,
    m.max_days_between_orders,
    p.total_products_bought,
    p.reorder_rate,
    case 
    when m.total_orders between 1 and 5 then 'ocasional'
    when m.total_orders between 6 and 15 then 'Regular'
    when m.total_orders between 16 and 50 then 'Frecuente'
    when m.total_orders >=50 then 'VIP'
    end as user_segment
FROM main_user_table m
LEFT JOIN products_per_user p
ON m.user_id = p.user_id;



--inserto los datos a analytics:

INSERT INTO analytics.user_metrics
WITH main_user_table AS(
SELECT
    user_id,
    count(order_id) AS total_orders,
    avg(days_since_prior_order) AS avg_days_between_orders,
    max(days_since_prior_order) AS max_days_between_orders
FROM staging.orders
GROUP BY user_id
),
products_per_user AS(
SELECT
    o.user_id,
    count(opp.product_id) AS total_products_bought,
    avg(opp.reordered::float) AS reorder_rate
FROM staging.order_products_prior opp
LEFT JOIN staging.orders o
ON o.order_id = opp.order_id
GROUP BY o.user_id
)
SELECT
    m.user_id,
    m.total_orders,
    m.avg_days_between_orders,
    m.max_days_between_orders,
    p.total_products_bought,
    p.reorder_rate,
    CASE
    WHEN m.total_orders BETWEEN 1 AND 5 THEN 'Ocasional'
    WHEN m.total_orders BETWEEN 6 AND 15 THEN 'Regular'
    WHEN m.total_orders BETWEEN 16 AND 50 THEN 'Frecuente'
    WHEN m.total_orders >= 50 THEN 'VIP'
    END AS user_segment
FROM main_user_table m
LEFT JOIN products_per_user p
ON m.user_id = p.user_id;
--creamos tabla de analytics.product_metrics



CREATE TABLE analytics.product_metrics (
    product_id INTEGER,
    product_name TEXT,
    aisle TEXT,
    department TEXT,
    total_bought INTEGER,
    total_reordered INTEGER,
    reorder_rate FLOAT,
    avg_add_to_cart_order FLOAT,
    product_segment VARCHAR(20)
);


--hacemos query para armar la tabla a insertar en analytics.product_metrics

INSERT INTO analytics.product_metrics
WITH product_stats AS(
SELECT
    opp.product_id as product_id,
    p.product_name as product_name,
    a.aisle as aisle,
    d.department as department,
    count(opp.product_id) AS total_bought,
    sum(opp.reordered) AS total_reordered,
    avg(opp.add_to_cart_order) AS avg_add_to_cart_order
FROM staging.order_products_prior opp
LEFT JOIN staging.products p ON opp.product_id = p.product_id
LEFT JOIN staging.aisles a ON p.aisle_id = a.aisle_id
LEFT JOIN staging.departments d ON p.department_id = d.department_id
GROUP BY opp.product_id, p.product_name, a.aisle, d.department

)

select 
	product_id,
	product_name,
	aisle,
	department,
	total_bought,
	total_reordered,
	avg_add_to_cart_order,
	(total_reordered::float/total_bought::float)*100 as reorder_rate,
	case 
		when (total_reordered::float/total_bought::float)*100 <=30 then 'Nicho'
		when (total_reordered::float/total_bought::float)*100 between 30 and 60 then 'Regular'
		when (total_reordered::float/total_bought::float)*100 >=60 then 'Star'
		end as product_segment
	from product_stats;
	
	