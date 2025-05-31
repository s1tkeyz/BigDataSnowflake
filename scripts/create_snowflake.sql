-- Создание таблиц измерений (более нормализованных)
CREATE TABLE d_location (
    location_id BIGINT PRIMARY KEY,
    country VARCHAR(50),
    postal_code VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE d_pet (
    pet_id BIGINT PRIMARY KEY,
    type VARCHAR(50),
    name VARCHAR(50),
    breed VARCHAR(50)
);

CREATE TABLE d_customer (
    customer_id BIGINT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    email VARCHAR(50),
    location_id BIGINT REFERENCES d_location(location_id),
    pet_id BIGINT REFERENCES d_pet(pet_id)
);

CREATE TABLE d_seller (
    seller_id BIGINT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    location_id BIGINT REFERENCES d_location(location_id)
);

CREATE TABLE d_product_category (
    category_id BIGINT PRIMARY KEY,
    name VARCHAR(50),
    pet_category VARCHAR(50)
);

CREATE TABLE d_product_details (
    details_id BIGINT PRIMARY KEY,
    weight REAL,
    color VARCHAR(50),
    size VARCHAR(50),
    brand VARCHAR(50),
    material VARCHAR(50),
    description TEXT
);

CREATE TABLE d_product_rating (
    rating_id BIGINT PRIMARY KEY,
    rating REAL,
    reviews INT
);

CREATE TABLE d_product_dates (
    dates_id BIGINT PRIMARY KEY,
    release_date VARCHAR(50),
    expiry_date VARCHAR(50)
);

CREATE TABLE d_product (
    product_id BIGINT PRIMARY KEY,
    name VARCHAR(50),
    category_id BIGINT REFERENCES d_product_category(category_id),
    price NUMERIC(10, 2),
    quantity INT,
    details_id BIGINT REFERENCES d_product_details(details_id),
    rating_id BIGINT REFERENCES d_product_rating(rating_id),
    dates_id BIGINT REFERENCES d_product_dates(dates_id)
);

CREATE TABLE d_store (
    store_id BIGINT PRIMARY KEY,
    name VARCHAR(50),
    location VARCHAR(50),
    location_id BIGINT REFERENCES d_location(location_id),
    phone VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE d_supplier (
    supplier_id BIGINT PRIMARY KEY,
    name VARCHAR(50),
    contact VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(50),
    address VARCHAR(50),
    location_id BIGINT REFERENCES d_location(location_id)
);

CREATE TABLE d_date (
    date_id BIGINT PRIMARY KEY,
    sale_date VARCHAR(50),
    day INT,
    month INT,
    year INT,
    quarter INT
);

CREATE TABLE f_sale (
    sale_id BIGINT PRIMARY KEY,
    customer_id BIGINT REFERENCES d_customer(customer_id),
    seller_id BIGINT REFERENCES d_seller(seller_id),
    product_id BIGINT REFERENCES d_product(product_id),
    store_id BIGINT REFERENCES d_store(store_id),
    supplier_id BIGINT REFERENCES d_supplier(supplier_id),
    date_id BIGINT REFERENCES d_date(date_id),
    quantity INT,
    total_price NUMERIC(10, 2),
    original_id BIGINT
);