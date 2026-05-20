--los usuarios vip compran en dias y horas distintas a los usuarios ocasionales?

select *
from staging.orders
limit 5;

with 
vip_vs_ocasionales as (
select 
	o.user_id as orders_user_id,
	um.user_segment as user_segment,
	o.order_dow as day_of_week,
	o.order_hour_of_day as hour_of_the_day	
from staging.orders o 
left join analytics.user_metrics um 
on o.user_id = um.user_id
)
select
	user_segment,
	day_of_week,
	hour_of_the_day,
	count(*) as frecuencia
from vip_vs_ocasionales 
where user_segment in ('VIP', 'Ocasional')
group by user_segment, day_of_week,hour_of_the_day
order by user_segment, count(*) DESC;

