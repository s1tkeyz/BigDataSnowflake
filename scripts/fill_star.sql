-- Заполняем таблицу потребителей
INSERT INTO d_customer (
    first_name,
    last_name,
    age,
    email,
    country,
    postal_code,
    pet_type,
    pet_name,
    pet_breed
)
SELECT DISTINCT
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
FROM mock_data;

-- Заполняем таблицу продавцов
INSERT INTO d_seller (
    first_name,
    last_name,
    email,
    country,
    postal_code
)
SELECT DISTINCT
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM mock_data;

-- Заполняем таблиуц магазинов
INSERT INTO d_store (
    name,
    location,
    city,
    state,
    country,
    phone,
    email
)
SELECT DISTINCT
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
FROM mock_data;

-- Зполняем таблицу поставщиков
INSERT INTO d_supplier (
    name,
    contact_person,
    email,
    phone,
    address,
    city,
    country
)
SELECT DISTINCT
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM mock_data;

-- Заполняем таблицу дат
INSERT INTO d_date (
    day,
    month,
    year,
    quarter,
    week,
    day_of_week
)
select 
	extract('day' from sale_date::date) as day,
	extract('month' from sale_date::date) as month,
	extract('year' from sale_date::date) as year,
	extract('quarter' from sale_date::date) as quarter,
	extract('week' from sale_date::date) as week,
	extract ('dow' from sale_date::date) as day_of_week
FROM mock_data;