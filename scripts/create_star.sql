-- Покупатель (измерение)
CREATE TABLE d_customer (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

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

-- Продавец (измерение)
CREATE TABLE d_seller (
    seller_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(20)
);

-- Товар (измерение)
CREATE TABLE d_product (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

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
    release_date DATE,
    expiry_date DATE
);

-- Магазин (измерение)
CREATE TABLE d_store (
    store_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    name VARCHAR(50),
    location VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(50)
);

-- Поставщик (измерение)
CREATE TABLE d_supplier (
    supplier_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    name VARCHAR(50),
    contact VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(50),
    address VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50)
);

-- Дата (измерение)
CREATE TABLE d_date (
    date_id BIGINT PRIMARY KEY,

    day INT,
    month INT,
    year INT,
    quarter INT,
    week INT,
    day_of_week INT,
);

-- Продажи (факты)
CREATE TABLE f_sales (
    sale_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    -- Ссылки на измерения
    customer_id BIGINT NOT NULL REFERENCES d_customer(customer_id),
    seller_id BIGINT NOT NULL REFERENCES d_seller(seller_id),
    product_id BIGINT NOT NULL REFERENCES d_product(product_id),
    store_id BIGINT NOT NULL REFERENCES d_store(store_id),
    supplier_id BIGINT NOT NULL REFERENCES d_supplier(supplier_id),
    date_id BIGINT NOT NULL REFERENCES d_date(date_id),

    -- Факты
    quantity INT NOT NULL,
    total_price NUMERIC(10, 2) NOT NULL,
);