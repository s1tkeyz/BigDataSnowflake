INSERT INTO d_location
SELECT 
    ROW_NUMBER() OVER () AS location_id,
    customer_country AS country,
    customer_postal_code AS postal_code,
    NULL AS city,
    NULL AS state
FROM public.mock_data
WHERE customer_country IS NOT NULL
GROUP BY customer_country, customer_postal_code
UNION
SELECT 
    ROW_NUMBER() OVER () + (SELECT COUNT(*) FROM (SELECT customer_country, customer_postal_code FROM public.mock_data GROUP BY customer_country, customer_postal_code) t) AS location_id,
    seller_country AS country,
    seller_postal_code AS postal_code,
    NULL AS city,
    NULL AS state
FROM public.mock_data
WHERE seller_country IS NOT NULL
GROUP BY seller_country, seller_postal_code
UNION
SELECT 
    ROW_NUMBER() OVER () + (SELECT COUNT(*) FROM (SELECT customer_country, customer_postal_code FROM public.mock_data GROUP BY customer_country, customer_postal_code) t) + 
    (SELECT COUNT(*) FROM (SELECT seller_country, seller_postal_code FROM public.mock_data GROUP BY seller_country, seller_postal_code) t) AS location_id,
    store_country AS country,
    NULL AS postal_code,
    store_city AS city,
    store_state AS state
FROM public.mock_data
WHERE store_country IS NOT NULL
GROUP BY store_country, store_city, store_state
UNION
SELECT 
    ROW_NUMBER() OVER () + (SELECT COUNT(*) FROM (SELECT customer_country, customer_postal_code FROM public.mock_data GROUP BY customer_country, customer_postal_code) t) + 
    (SELECT COUNT(*) FROM (SELECT seller_country, seller_postal_code FROM public.mock_data GROUP BY seller_country, seller_postal_code) t) +
    (SELECT COUNT(*) FROM (SELECT store_country, store_city, store_state FROM public.mock_data GROUP BY store_country, store_city, store_state) t) AS location_id,
    supplier_country AS country,
    NULL AS postal_code,
    supplier_city AS city,
    NULL AS state
FROM public.mock_data
WHERE supplier_country IS NOT NULL
GROUP BY supplier_country, supplier_city;

INSERT INTO d_pet
SELECT 
    ROW_NUMBER() OVER () AS pet_id,
    customer_pet_type AS type,
    customer_pet_name AS name,
    customer_pet_breed AS breed
FROM public.mock_data
WHERE customer_pet_type IS NOT NULL
GROUP BY customer_pet_type, customer_pet_name, customer_pet_breed;

INSERT INTO d_customer
SELECT 
    m.id AS customer_id,
    m.customer_first_name AS first_name,
    m.customer_last_name AS last_name,
    m.customer_age AS age,
    m.customer_email AS email,
    l.location_id,
    p.pet_id
FROM public.mock_data m
LEFT JOIN d_location l ON m.customer_country = l.country AND m.customer_postal_code = l.postal_code
LEFT JOIN d_pet p ON m.customer_pet_type = p.type AND m.customer_pet_name = p.name AND m.customer_pet_breed = p.breed
GROUP BY m.id, m.customer_first_name, m.customer_last_name, m.customer_age, m.customer_email, l.location_id, p.pet_id;

INSERT INTO d_seller
SELECT 
    m.sale_seller_id AS seller_id,
    m.seller_first_name AS first_name,
    m.seller_last_name AS last_name,
    m.seller_email AS email,
    l.location_id
FROM public.mock_data m
LEFT JOIN d_location l ON m.seller_country = l.country AND m.seller_postal_code = l.postal_code
WHERE m.sale_seller_id IS NOT NULL
GROUP BY m.sale_seller_id, m.seller_first_name, m.seller_last_name, m.seller_email, l.location_id;

INSERT INTO d_product_category
SELECT 
    ROW_NUMBER() OVER () AS category_id,
    product_category AS name,
    pet_category
FROM public.mock_data
WHERE product_category IS NOT NULL
GROUP BY product_category, pet_category;

INSERT INTO d_product_details
SELECT 
    ROW_NUMBER() OVER () AS details_id,
    product_weight AS weight,
    product_color AS color,
    product_size AS size,
    product_brand AS brand,
    product_material AS material,
    product_description AS description
FROM public.mock_data
WHERE product_weight IS NOT NULL OR product_color IS NOT NULL OR product_size IS NOT NULL OR 
      product_brand IS NOT NULL OR product_material IS NOT NULL OR product_description IS NOT NULL
GROUP BY product_weight, product_color, product_size, product_brand, product_material, product_description;

INSERT INTO d_product_rating
SELECT 
    ROW_NUMBER() OVER () AS rating_id,
    product_rating AS rating,
    product_reviews AS reviews
FROM public.mock_data
WHERE product_rating IS NOT NULL OR product_reviews IS NOT NULL
GROUP BY product_rating, product_reviews;

INSERT INTO d_product_dates
SELECT 
    ROW_NUMBER() OVER () AS dates_id,
    product_release_date AS release_date,
    product_expiry_date AS expiry_date
FROM public.mock_data
WHERE product_release_date IS NOT NULL OR product_expiry_date IS NOT NULL
GROUP BY product_release_date, product_expiry_date;

INSERT INTO d_product
SELECT 
    m.sale_product_id AS product_id,
    m.product_name AS name,
    pc.category_id,
    m.product_price AS price,
    m.product_quantity AS quantity,
    pd.details_id,
    pr.rating_id,
    pdt.dates_id
FROM public.mock_data m
LEFT JOIN d_product_category pc ON m.product_category = pc.name AND (m.pet_category = pc.pet_category OR (m.pet_category IS NULL AND pc.pet_category IS NULL))
LEFT JOIN d_product_details pd ON m.product_weight = pd.weight AND m.product_color = pd.color AND m.product_size = pd.size AND 
                                m.product_brand = pd.brand AND m.product_material = pd.material AND m.product_description = pd.description
LEFT JOIN d_product_rating pr ON m.product_rating = pr.rating AND m.product_reviews = pr.reviews
LEFT JOIN d_product_dates pdt ON m.product_release_date = pdt.release_date AND m.product_expiry_date = pdt.expiry_date
WHERE m.sale_product_id IS NOT NULL
GROUP BY m.sale_product_id, m.product_name, pc.category_id, m.product_price, m.product_quantity, 
         pd.details_id, pr.rating_id, pdt.dates_id;

INSERT INTO d_store
SELECT 
    ROW_NUMBER() OVER () AS store_id,
    m.store_name AS name,
    m.store_location AS location,
    l.location_id,
    m.store_phone AS phone,
    m.store_email AS email
FROM public.mock_data m
LEFT JOIN d_location l ON m.store_country = l.country AND m.store_city = l.city AND m.store_state = l.state
WHERE m.store_name IS NOT NULL
GROUP BY m.store_name, m.store_location, l.location_id, m.store_phone, m.store_email;

INSERT INTO d_supplier
SELECT 
    ROW_NUMBER() OVER () AS supplier_id,
    m.supplier_name AS name,
    m.supplier_contact AS contact,
    m.supplier_email AS email,
    m.supplier_phone AS phone,
    m.supplier_address AS address,
    l.location_id
FROM public.mock_data m
LEFT JOIN d_location l ON m.supplier_country = l.country AND m.supplier_city = l.city
WHERE m.supplier_name IS NOT NULL
GROUP BY m.supplier_name, m.supplier_contact, m.supplier_email, m.supplier_phone, 
         m.supplier_address, l.location_id;

INSERT INTO d_date
SELECT 
    ROW_NUMBER() OVER () AS date_id,
    m.sale_date,
    EXTRACT(DAY FROM TO_DATE(m.sale_date, 'YYYY-MM-DD')) AS day,
    EXTRACT(MONTH FROM TO_DATE(m.sale_date, 'YYYY-MM-DD')) AS month,
    EXTRACT(YEAR FROM TO_DATE(m.sale_date, 'YYYY-MM-DD')) AS year,
    EXTRACT(QUARTER FROM TO_DATE(m.sale_date, 'YYYY-MM-DD')) AS quarter
FROM public.mock_data m
WHERE m.sale_date IS NOT NULL
GROUP BY m.sale_date;

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
JOIN d_store s ON m.store_name = s.name AND m.store_location = s.location
JOIN d_supplier sup ON m.supplier_name = sup.name AND m.supplier_contact = sup.contact
JOIN d_date d ON m.sale_date = d.sale_date;
