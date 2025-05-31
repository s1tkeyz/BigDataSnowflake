CREATE TABLE d_customer (
    customer_id BIGINT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    email VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(50),
    pet_type VARCHAR(50),
    pet_name VARCHAR(50),
    pet_breed VARCHAR(50)
);

CREATE TABLE d_seller (
    seller_id BIGINT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(50)
);

CREATE TABLE d_product (
    product_id BIGINT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(50),
    price NUMERIC(10, 2),
    quantity INT,
    weight REAL,
    color VARCHAR(50),
    size VARCHAR(50),
    brand VARCHAR(50),
    material VARCHAR(50),
    description TEXT,
    rating REAL,
    reviews INT,
    release_date VARCHAR(50),
    expiry_date VARCHAR(50),
    pet_category VARCHAR(50)
);

CREATE TABLE d_store (
    store_id BIGINT PRIMARY KEY,
    name VARCHAR(50),
    location VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
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
    city VARCHAR(50),
    country VARCHAR(50)
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