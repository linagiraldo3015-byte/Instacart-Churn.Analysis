--Exploracion de datos--


--Registros totales de cada tabla--

select 
	'orders' as tabla,
	count(*) as registros
from staging.orders 
union all
select 
	'products',
	count(*)
from staging.products 
union all
select
	'aisles',
	count(*)
from staging.aisles 
union all
select 
	'departments',
	count(*)
from staging.departments 
union all
select 
	'order_products_prior',
	count(*)
from staging.order_products_prior 
union all
select 
	'order_products_train',
	count(*)
from staging.order_products_train ;




--Exploracion de la tabla ORDERS--

select *
from staging.orders 
limit 5;

select 
	count(*)
from staging.orders
limit 5
;

select 
count (distinct user_id)
from staging.orders;

select 
user_id,
days_since_prior_order
from staging.orders 
--where days_since_prior_order is null
order by user_id;

select
	count(order_id)::float / count(distinct user_id) as avg_order
from staging.orders;

select 
	user_id,
	count(order_id) as total_orders
from staging.orders 
group by user_id 
order by count(order_id) DESC
limit 1;

select
	count(order_id) as total_orders
from staging.orders 
union all
select 
	count(distinct order_id) as distinct_orders
from staging.orders ;

select
	order_dow,	
	count(order_id) as orders_dow
from staging.orders 
group by order_dow 
order by count(order_id) desc
limit 1;

select 
	distinct(order_dow)
from staging.orders;

select
	order_hour_of_day,	
	count(order_id) as orders_per_hour
from staging.orders 
group by order_hour_of_day
order by count(order_id) desc
limit 1;

--Hallazgos: -Los valores nulos en la columna 'days_since_prior_order' corresponden a la primera orden realizada por los usuarios
			--hay registro de 3,421,083 ordenes, y 206,209 distintos usuarios para esas ordenes
			-- promedio de ordenes por user:  16
			-- los usuarios que mas ordenes tienen, cuentan con  una frecuencia hasta de 100 ordenes.
			-- no hay ordenes duplicadas
			-- el dia domingo (dia 0) es en el que mas se realizan ordenes
			-- la hora del dia en la que mas ordenes se registran es a las 10am, con 288,418 ordenes.



--Exploracion de la tabla aisles--

select *
from staging.aisles 
limit 5;

select 
	count(distinct aisle_id)
from staging.aisles;

select 
	count(aisle_id)
from staging.aisles 
where aisle_id is null;

select 
	count(aisle_id)
from staging.aisles 
where aisle_id <1;

select 
	count(aisle_id)
from staging.aisles 
where aisle_id <1;

select 
	count(aisle_id)
from staging.aisles 
where aisle = '';

select 
	count(aisle_id)
from staging.aisles 
where aisle is null;


--Hallazgos: -existen 134 pasillos
			--no hay valores nulos ni vacios en ninguna de las 2 columnas de la tabla


--Exploracion de la tabla departments--

select *
from staging.departments 
limit 5;

select
	count(distinct department_id)
from staging.departments;

select 
	count(department_id)
from staging.departments 
where department_id is null;

select 
	count(department_id)
from staging.departments  
where department_id <1 or department_id = 0;

select 
	count(department)
from staging.departments 
where department = '';

--Hallazgos: -21 departments, ningun valor vacio nulos o en ceros.


--Exploracion de la tabla products

select *
from staging.products 
limit 5;

select 
	count(*)
from staging.products ; --49,688-- products

select 
	count(distinct product_id)
from staging.products ; --no hay product_ids repetidos

select
	count(product_id)
from staging.products 
where product_id is null or product_id <1;

select
	count(product_name) 
from staging.products
where product_name is null or product_name ='';

select 
	count(aisle_id)
from staging.products 
where aisle_id is null or aisle_id <0 or aisle_id >134;



select 
	count(department_id)
from staging.products 
where department_id is null or department_id <0 or department_id > 21 ;

--Hallazgos: - hay 49,688 products diferentes sin estar repetidos
			-- no hay valores nulos, irregulares, vacios o negativos 
			-- todos los productos cuentan con pasillos y departamentos asignados válidos



-----Exploracion de la tabla order_products_prior

select *
from staging.order_products_prior
limit 5;

select 
	count(order_products_prior)
from staging.order_products_prior; --la tabla cuenta con 32,434,489 registros de productos que han sido comprados

select 
	count(product_id)
from staging.order_products_prior
where product_id is null or product_id <=0 ; -- no hay filas nulas, negativas o en 0 para product_id


select 
	count(add_to_cart_order)
from staging.order_products_prior
where add_to_cart_order is null or add_to_cart_order <=0 ;-- no hay filas nulas, negativas o en 0 para add_to_cart_order

select 
	count(reordered)
from staging.order_products_prior
where reordered is null  ; --no hay valores nulos en reodered



SELECT
    reordered,
    count(*) as total,
    count(*)::float / (SELECT count(*) FROM staging.order_products_prior) * 100 as porcentaje
FROM staging.order_products_prior
GROUP BY reordered; -- el 41,03% de los productos ordenados fueron por primera vez 
					--el 58,96% de los productos fueron re-ordenados.


select 
	count(order_id)
from staging.order_products_prior
where order_id is null or order_id <=0 ; --no hay valores nulos, ceros o negativos en order_id

	

--Hallazgos: --la tabla cuenta con 32,434,489 registros de productos que han sido comprados
			 -- no hay filas nulas, negativas o en 0 para product_id	
			--no hay filas nulas, negativas o en 0 para add_to_cart_order
			-- el 41,03% de los productos ordenados fueron por primera vez 
			--el 58,96% de los productos fueron re-ordenados.



-----Exploracion de la tabla order_products_train

select *
from staging.order_products_train 
limit 5;

select 
	count(order_products_train)
from staging.order_products_train; --la tabla cuenta con 1,384,617 registros

select 
	count(add_to_cart_order)
from staging.order_products_train
where add_to_cart_order is null or add_to_cart_order <=0 ;--no hay registros nulos ni negativos o cero para add_to_Cart_order
	
select 
	count(product_id)
from staging.order_products_train
where product_id is null or product_id <=0 ;--no hay registros nulos ni negativos o cero para product_id


SELECT
    reordered,
    count(*) as total,
    count(*)::float / (SELECT count(*) FROM staging.order_products_train) * 100 as porcentaje
FROM staging.order_products_train
GROUP BY reordered; --el 40,14% de los productos ordenados corresponden a compras por primera vez para cada usuario
					-- el 59,85% de los productos ordenados corresponden a reordenes para cada usuario


--HALLAZGOS:

--— RETENCIÓN Y HÁBITOS DE COMPRA:
-- Promedio de órdenes por usuario: 16.59 órdenes
-- Promedio de días entre órdenes: 15.45 días
-- Un usuario típico de Instacart compra aproximadamente cada 2 semanas
-- El dataset cappea days_since_prior_order en 30 días — usuarios con
-- gaps mayores no son distinguibles entre sí
-- El usuario más activo tiene 100 órdenes


----COMPORTAMIENTO DE RECOMPRA:
-- El 59% de los productos ordenados son reórdenes vs 41% primera vez
-- Departamentos con mayor tasa de recompra:
--   1. Dairy eggs: 50.6%
--   2. Pets: 49.2%
--   3. Bakery y Beverages: ~47%
-- Los departamentos con mayor recompra son de consumo básico y habitual
-- Instacart es usado principalmente como reemplazo del supermercado semanal


----SEGMENTACIÓN DE USUARIOS:
-- Distribución de segmentos:
--   VIP: 5.29% (10,910 usuarios)
--   Frecuente: 28.60% (58,979 usuarios)
--   Regular: 44.97% (92,744 usuarios)
--   Ocasional: 21.13% (43,576 usuarios)
-- 99,809 usuarios (48.4%) concentran el 80% de las órdenes
-- Diferencias clave VIP vs Ocasional:
--   VIP compra cada 5.13 días vs Ocasional cada 19.96 días
--   VIP realiza 70 órdenes en promedio vs Ocasional 4.4
--   VIP compra 677 productos en promedio vs Ocasional 33
--   VIP reordena el 74% de sus productos vs Ocasional el 22%
-- Tasa de recompra por segmento (mediana):
--   VIP: 74.8%
--   Frecuente: 60.4%
--   Regular: 38.7%
--   Ocasional: 20.9%
-- A mayor lealtad, mayor tasa de recompra — la recompra es un
-- predictor temprano de lealtad del usuario


--PATRONES TEMPORALES:
-- Día con más órdenes globalmente: domingo (600,905 órdenes)
-- Hora con más órdenes globalmente: 10am (288,418 órdenes)
-- VIP: concentran sus compras los lunes entre 9am y 3pm
--   Comportamiento planificado y rutinario
-- Ocasional: compran hacia el final de la semana en horas tarde-noche
--   Comportamiento más impulsivo o reactivo


--CONCLUSIONES:
--1. Un usuario típico de Instacart compra aproximadamente cada 2 semanas
--    lo que posiciona a Instacart como herramienta de uso semanal que
--    reemplaza las compras de supermercado

-- 2. A mayor lealtad, mayor tasa de recompra:
--    VIP: 74.8% | Frecuente: 60.4% | Regular: 38.7% | Ocasional: 20.9%
--    La recompra permite entender y predecir la lealtad del usuario

-- 3. Los usuarios VIP no solo compran más — compran más seguido,
--    más productos y con mayor consistencia. Son el segmento más valioso
--    y el que tiene el hábito de compra más consolidado en Instacart

-- 4. Recomendaciones de campañas y notificaciones:
--    VIP: enviar el domingo o lunes temprano para capturar su ventana de compra
--    Ocasional: enviar jueves-viernes en la tarde para activarlos antes del fin de semana
--    Esto tiene implicaciones directas para el equipo de producto en cuándo
--    mostrar banners, promociones o recordatorios en la app

-- 5. Solo el 14% de los productos son "Estrella" (reorder_rate > 60%)
--    pero son los que generan el hábito de compra y retienen usuarios
--    Instacart debe priorizarlos en recomendaciones y disponibilidad