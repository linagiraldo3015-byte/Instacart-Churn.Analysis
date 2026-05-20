create table staging.orders (
	order_id INTEGER,
	user_id  INTEGER,
	eval_set VARCHAR(10),
	order_number INTEGER,
	order_dow INTEGER,
	order_hour_of_day INTEGER,
	days_since_prior_order FLOAT
);




CREATE TABLE staging.products (
    product_id INTEGER,
    product_name TEXT,
    aisle_id INTEGER,
    department_id INTEGER
);


create table staging.aisles (
	aisle_id INTEGER,
	aisle VARCHAR(100)
);


create table staging.departments (
	department_id INTEGER,
	department VARCHAR(100)
);


create table staging.order_products_prior (
	order_id INTEGER,
	product_id INTEGER,
	add_to_cart_order INTEGER,
	reordered INTEGER
);


create table staging.order_products_train (
	order_id INTEGER,
	product_id INTEGER,
	add_to_cart_order INTEGER,
	reordered INTEGER
);



	