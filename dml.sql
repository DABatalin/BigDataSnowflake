-- страны
INSERT INTO d_countries (name)
SELECT DISTINCT customer_country FROM mock_data WHERE customer_country IS NOT NULL
UNION
SELECT DISTINCT seller_country FROM mock_data WHERE seller_country IS NOT NULL
UNION
SELECT DISTINCT store_country FROM mock_data WHERE store_country IS NOT NULL
UNION
SELECT DISTINCT supplier_country FROM mock_data WHERE supplier_country IS NOT NULL;

-- почтовые индексы
INSERT INTO d_postal_codes (code)
SELECT DISTINCT customer_postal_code FROM mock_data WHERE customer_postal_code IS NOT NULL
UNION
SELECT DISTINCT seller_postal_code FROM mock_data WHERE seller_postal_code IS NOT NULL;

-- продавцы
INSERT INTO d_sellers (
    first_name, 
    last_name, 
    email, 
    country_id, 
    postal_code_id
)
SELECT 
    md.seller_first_name,
    md.seller_last_name,
    md.seller_email,
    cnt.id,
    pc.id
FROM 
    mock_data md
LEFT JOIN 
    d_countries cnt ON md.seller_country = cnt.name
LEFT JOIN
    d_postal_codes pc ON md.seller_postal_code = pc.code
GROUP BY 
    md.seller_first_name, md.seller_last_name, md.seller_email, cnt.id, pc.id;

-- типы питомцев
INSERT INTO d_pet_types (name)
SELECT DISTINCT customer_pet_type FROM mock_data WHERE customer_pet_type IS NOT NULL;

-- породы питомцев
INSERT INTO d_pet_breeds (name)
SELECT DISTINCT customer_pet_breed FROM mock_data WHERE customer_pet_breed IS NOT NULL;

-- категории питомцев
INSERT INTO d_pet_categories (name)
SELECT DISTINCT pet_category FROM mock_data WHERE pet_category IS NOT NULL;

-- питомцы
INSERT INTO d_pets (type_id, name, breed_id, category_id)
SELECT 
    pt.id, 
    md.customer_pet_name, 
    pb.id, 
    pc.id
FROM 
    mock_data md
LEFT JOIN 
    d_pet_types pt ON md.customer_pet_type = pt.name
LEFT JOIN 
    d_pet_breeds pb ON md.customer_pet_breed = pb.name
LEFT JOIN 
    d_pet_categories pc ON md.pet_category = pc.name
GROUP BY 
    pt.id, md.customer_pet_name, pb.id, pc.id;

-- клиенты
INSERT INTO d_customers (
    first_name, 
    last_name, 
    age, 
    email, 
    country_id, 
    postal_code_id, 
    pet_id
)
SELECT 
    md.customer_first_name,
    md.customer_last_name,
    md.customer_age,
    md.customer_email,
    cnt.id,
    pc.id,
    pet.id
FROM 
    mock_data md
LEFT JOIN 
    d_countries cnt ON md.customer_country = cnt.name
LEFT JOIN
    d_postal_codes pc ON md.customer_postal_code = pc.code
LEFT JOIN 
    d_pets pet ON
        md.customer_pet_name = pet.name
        AND EXISTS (
            SELECT 1 FROM d_pet_types pt 
            WHERE pt.id = pet.type_id AND pt.name = md.customer_pet_type
        )
        AND EXISTS (
            SELECT 1 FROM d_pet_breeds pb 
            WHERE pb.id = pet.breed_id AND pb.name = md.customer_pet_breed
        )
        AND EXISTS (
            SELECT 1 FROM d_pet_categories pc 
            WHERE pc.id = pet.category_id AND pc.name = md.pet_category
        )
GROUP BY 
    md.customer_first_name, md.customer_last_name, md.customer_age, 
    md.customer_email, cnt.id, pc.id, pet.id;

-- даты
INSERT INTO d_dates (date)
SELECT DISTINCT TO_DATE(sale_date, 'MM/DD/YYYY') FROM mock_data WHERE sale_date IS NOT NULL
UNION
SELECT DISTINCT TO_DATE(product_release_date, 'MM/DD/YYYY') FROM mock_data WHERE product_release_date IS NOT NULL
UNION
SELECT DISTINCT TO_DATE(product_expiry_date, 'MM/DD/YYYY') FROM mock_data WHERE product_expiry_date IS NOT NULL;

-- бренды продуктов
INSERT INTO d_product_brands (name)
SELECT DISTINCT product_brand FROM mock_data WHERE product_brand IS NOT NULL;

-- материалы продуктов
INSERT INTO d_product_materials (name)
SELECT DISTINCT product_material FROM mock_data WHERE product_material IS NOT NULL;

-- цвета продуктов
INSERT INTO d_product_colors (name)
SELECT DISTINCT product_color FROM mock_data WHERE product_color IS NOT NULL;

-- категории продуктов
INSERT INTO d_product_categories (name)
SELECT DISTINCT product_category FROM mock_data WHERE product_category IS NOT NULL;

-- размеры продуктов
INSERT INTO d_product_sizes (name)
SELECT DISTINCT product_size FROM mock_data WHERE product_size IS NOT NULL;

-- продукты
INSERT INTO d_products (
    name, 
    price, 
    weight, 
    brand_id, 
    material_id, 
    color_id, 
    category_id, 
    size_id, 
    description, 
    rating, 
    reviews, 
    release_date_id, 
    expiry_date_id
)
SELECT 
    md.product_name,
    md.product_price,
    md.product_weight,
    br.id,
    mat.id,
    col.id,
    cat.id,
    sz.id,
    md.product_description,
    md.product_rating,
    md.product_reviews,
    rd.id,
    ed.id
FROM 
    mock_data md
LEFT JOIN 
    d_product_brands br ON md.product_brand = br.name
LEFT JOIN 
    d_product_materials mat ON md.product_material = mat.name
LEFT JOIN 
    d_product_colors col ON md.product_color = col.name
LEFT JOIN 
    d_product_categories cat ON md.product_category = cat.name
LEFT JOIN 
    d_product_sizes sz ON md.product_size = sz.name
LEFT JOIN 
    d_dates rd ON TO_DATE(md.product_release_date, 'MM/DD/YYYY') = rd.date
LEFT JOIN 
    d_dates ed ON TO_DATE(md.product_expiry_date, 'MM/DD/YYYY') = ed.date
GROUP BY 
    md.product_name, md.product_price, md.product_weight, br.id, mat.id, col.id, 
    cat.id, sz.id, md.product_description, md.product_rating, md.product_reviews, 
    rd.id, ed.id;

-- города
INSERT INTO d_cities (name)
SELECT DISTINCT store_city FROM mock_data WHERE store_city IS NOT NULL
UNION
SELECT DISTINCT supplier_city FROM mock_data WHERE supplier_city IS NOT NULL;

-- магазины
INSERT INTO d_stores (
    name, 
    location, 
    city_id, 
    state, 
    country_id, 
    phone, 
    email
)
SELECT 
    md.store_name,
    md.store_location,
    cit.id,
    md.store_state,
    cnt.id,
    md.store_phone,
    md.store_email
FROM 
    mock_data md
LEFT JOIN 
    d_countries cnt ON md.store_country = cnt.name
LEFT JOIN 
    d_cities cit ON md.store_city = cit.name
GROUP BY 
    md.store_name, md.store_location, cit.id, md.store_state, 
    cnt.id, md.store_phone, md.store_email;

-- поставщики
INSERT INTO d_suppliers (
    name, 
    contact, 
    email, 
    phone, 
    address, 
    city_id, 
    country_id
)
SELECT 
    md.supplier_name,
    md.supplier_contact,
    md.supplier_email,
    md.supplier_phone,
    md.supplier_address,
    cit.id,
    cnt.id
FROM 
    mock_data md
LEFT JOIN 
    d_countries cnt ON md.supplier_country = cnt.name
LEFT JOIN 
    d_cities cit ON md.supplier_city = cit.name
GROUP BY 
    md.supplier_name, md.supplier_contact, md.supplier_email, 
    md.supplier_phone, md.supplier_address, cit.id, cnt.id;

-- продажи
INSERT INTO f_sales (
    date_id,
    customer_id,
    seller_id,
    product_id,
    store_id,
    supplier_id,
    product_quantity,
    quantity,
    total_price
)
SELECT 
    dt.id,
    cust.id,
    slr.id,
    prod.id,
    st.id,
    sup.id,
    md.product_quantity,
    md.sale_quantity,
    md.sale_total_price
FROM 
    mock_data md
LEFT JOIN 
    d_customers cust ON md.customer_email = cust.email
LEFT JOIN 
    d_sellers slr ON md.seller_email = slr.email
LEFT JOIN
    d_product_categories pcat ON md.product_category = pcat.name
LEFT JOIN
    d_product_colors pcol ON md.product_color = pcol.name
LEFT JOIN
    d_product_sizes psz ON md.product_size = psz.name
LEFT JOIN
    d_product_brands pbr ON md.product_brand = pbr.name
LEFT JOIN
    d_product_materials pmat ON md.product_material = pmat.name
LEFT JOIN
    d_dates dr ON TO_DATE(md.product_release_date, 'MM/DD/YYYY') = dr.date
LEFT JOIN
    d_dates de ON TO_DATE(md.product_expiry_date, 'MM/DD/YYYY') = de.date
LEFT JOIN 
    d_products prod ON
        md.product_name = prod.name
        AND pcat.id = prod.category_id
        AND md.product_price = prod.price
        AND md.product_weight = prod.weight
        AND pcol.id = prod.color_id
        AND psz.id = prod.size_id
        AND pbr.id = prod.brand_id
        AND pmat.id = prod.material_id
        AND md.product_description = prod.description
        AND md.product_rating = prod.rating
        AND md.product_reviews = prod.reviews
        AND dr.id = prod.release_date_id
        AND de.id = prod.expiry_date_id
LEFT JOIN 
    d_dates dt ON TO_DATE(md.sale_date, 'MM/DD/YYYY') = dt.date
LEFT JOIN
    d_stores st ON md.store_email = st.email
LEFT JOIN
    d_suppliers sup ON md.supplier_email = sup.email;