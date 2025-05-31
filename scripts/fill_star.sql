INSERT INTO d_customer
SELECT DISTINCT ON (id)
    id AS customer_id,
    customer_first_name AS first_name,
    customer_last_name AS last_name,
    customer_age AS age,
    customer_email AS email,
    customer_country AS country,
    customer_postal_code AS postal_code,
    customer_pet_type AS pet_type,
    customer_pet_name AS pet_name,
    customer_pet_breed AS pet_breed
FROM public.mock_data;

INSERT INTO d_seller
SELECT DISTINCT ON (sale_seller_id)
    sale_seller_id AS seller_id,
    seller_first_name AS first_name,
    seller_last_name AS last_name,
    seller_email AS email,
    seller_country AS country,
    seller_postal_code AS postal_code
FROM public.mock_data
WHERE sale_seller_id IS NOT NULL
ORDER BY sale_seller_id;

INSERT INTO d_product
SELECT DISTINCT ON (sale_product_id)
    sale_product_id AS product_id,
    product_name AS name,
    product_category AS category,
    product_price AS price,
    product_quantity AS quantity,
    product_weight AS weight,
    product_color AS color,
    product_size AS size,
    product_brand AS brand,
    product_material AS material,
    product_description AS description,
    product_rating AS rating,
    product_reviews AS reviews,
    product_release_date AS release_date,
    product_expiry_date AS expiry_date,
    pet_category
FROM public.mock_data
WHERE sale_product_id IS NOT NULL
ORDER BY sale_product_id;

INSERT INTO d_store
SELECT 
    ROW_NUMBER() OVER () AS store_id,
    store_name AS name,
    store_location AS location,
    store_city AS city,
    store_state AS state,
    store_country AS country,
    store_phone AS phone,
    store_email AS email
FROM (
    SELECT DISTINCT ON (store_name, store_location)
        store_name, store_location, store_city, store_state, 
        store_country, store_phone, store_email
    FROM public.mock_data
    WHERE store_name IS NOT NULL
) AS unique_stores;

INSERT INTO d_supplier
SELECT 
    ROW_NUMBER() OVER () AS supplier_id,
    supplier_name AS name,
    supplier_contact AS contact,
    supplier_email AS email,
    supplier_phone AS phone,
    supplier_address AS address,
    supplier_city AS city,
    supplier_country AS country
FROM (
    SELECT DISTINCT ON (supplier_name, supplier_contact)
        supplier_name, supplier_contact, supplier_email, supplier_phone,
        supplier_address, supplier_city, supplier_country
    FROM public.mock_data
    WHERE supplier_name IS NOT NULL
) AS unique_suppliers;

INSERT INTO d_date
SELECT 
    ROW_NUMBER() OVER () AS date_id,
    sale_date,
    CASE 
        WHEN sale_date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN EXTRACT(DAY FROM TO_DATE(sale_date, 'MM/DD/YYYY'))
        WHEN sale_date ~ '^\d{4}-\d{2}-\d{2}$' THEN EXTRACT(DAY FROM TO_DATE(sale_date, 'YYYY-MM-DD'))
        ELSE NULL
    END AS day,
    CASE 
        WHEN sale_date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN EXTRACT(MONTH FROM TO_DATE(sale_date, 'MM/DD/YYYY'))
        WHEN sale_date ~ '^\d{4}-\d{2}-\d{2}$' THEN EXTRACT(MONTH FROM TO_DATE(sale_date, 'YYYY-MM-DD'))
        ELSE NULL
    END AS month,
    CASE 
        WHEN sale_date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN EXTRACT(YEAR FROM TO_DATE(sale_date, 'MM/DD/YYYY'))
        WHEN sale_date ~ '^\d{4}-\d{2}-\d{2}$' THEN EXTRACT(YEAR FROM TO_DATE(sale_date, 'YYYY-MM-DD'))
        ELSE NULL
    END AS year,
    CASE 
        WHEN sale_date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN EXTRACT(QUARTER FROM TO_DATE(sale_date, 'MM/DD/YYYY'))
        WHEN sale_date ~ '^\d{4}-\d{2}-\d{2}$' THEN EXTRACT(QUARTER FROM TO_DATE(sale_date, 'YYYY-MM-DD'))
        ELSE NULL
    END AS quarter
FROM (
    SELECT DISTINCT sale_date
    FROM public.mock_data
    WHERE sale_date IS NOT NULL
) AS unique_dates;

INSERT INTO f_sale
SELECT 
    m.id AS sale_id,
    m.id AS customer_id,
    m.sale_seller_id AS seller_id,
    m.sale_product_id AS product_id,
    s.store_id,
    sup.supplier_id,
    d.date_id,
    m.sale_quantity AS quantity,
    m.sale_total_price AS total_price,
    m.id AS original_id
FROM public.mock_data m
LEFT JOIN d_store s ON m.store_name = s.name AND m.store_location = s.location
LEFT JOIN d_supplier sup ON m.supplier_name = sup.name AND m.supplier_contact = sup.contact
LEFT JOIN d_date d ON m.sale_date = d.sale_date
WHERE 
    m.id IN (SELECT customer_id FROM d_customer) AND
    m.sale_seller_id IN (SELECT seller_id FROM d_seller) AND
    m.sale_product_id IN (SELECT product_id FROM d_product) AND
    s.store_id IS NOT NULL AND
    sup.supplier_id IS NOT NULL AND
    d.date_id IS NOT NULL;