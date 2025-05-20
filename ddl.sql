CREATE TABLE d_countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52)
);


CREATE TABLE d_postal_codes (
    id SERIAL PRIMARY KEY,
    code VARCHAR(52) UNIQUE
);

CREATE TABLE d_sellers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(52),
    last_name VARCHAR(52),
    email VARCHAR(52),
    country_id INT REFERENCES d_countries(id),
    postal_code_id INT REFERENCES d_postal_codes(id)
);


CREATE TABLE d_pet_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52)
);

CREATE TABLE d_pet_breeds (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52)
);

CREATE TABLE d_pet_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52)
);

CREATE TABLE d_pets (
    id SERIAL PRIMARY KEY,
    type_id INT REFERENCES d_pet_types(id),
    name VARCHAR(52),
    breed_id INT REFERENCES d_pet_breeds(id),
    category_id INT REFERENCES d_pet_categories(id)
);


CREATE TABLE d_customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(52),
    last_name VARCHAR(52),
    age INT,
    email VARCHAR(52),
    country_id INT REFERENCES d_countries(id),
    postal_code_id INT REFERENCES d_postal_codes(id),
    pet_id INT REFERENCES d_pets(id)
);


CREATE TABLE d_dates (
    id SERIAL PRIMARY KEY,
    date DATE
);

CREATE TABLE d_product_brands (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52)
);

CREATE TABLE d_product_materials (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52)
);

CREATE TABLE d_product_colors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52)
);

CREATE TABLE d_product_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52)
);

CREATE TABLE d_product_sizes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52)
);

CREATE TABLE d_products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52),
    price FLOAT,
    weight FLOAT,
    brand_id INT REFERENCES d_product_brands(id),
    material_id INT REFERENCES d_product_materials(id),
    color_id INT REFERENCES d_product_colors(id),
    category_id INT REFERENCES d_product_categories(id),
    size_id INT REFERENCES d_product_sizes(id),
    description VARCHAR(1356),
    rating FLOAT,
    reviews INT,
    release_date_id INT REFERENCES d_dates(id),
    expiry_date_id INT REFERENCES d_dates(id)
);


CREATE TABLE d_cities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52)
);

CREATE TABLE d_stores (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52),
    location VARCHAR(52),
    city_id INT REFERENCES d_cities(id),
    state VARCHAR(52),
    country_id INT REFERENCES d_countries(id),
    phone VARCHAR(52),
    email VARCHAR(52)
);

CREATE TABLE d_suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(52),
    contact VARCHAR(52),
    email VARCHAR(52),
    phone VARCHAR(52),
    city_id INT REFERENCES d_cities(id),
    country_id INT REFERENCES d_countries(id),
    address VARCHAR(52)
);


CREATE TABLE f_sales (
    id SERIAL PRIMARY KEY,
    date_id INT REFERENCES d_dates(id),
    customer_id INT REFERENCES d_customers(id),
    seller_id INT REFERENCES d_sellers(id),
    product_id INT REFERENCES d_products(id),
    store_id INT REFERENCES d_stores(id),
    supplier_id INT REFERENCES d_suppliers(id),
    product_quantity INT,
    quantity INT,
    total_price FLOAT
);