-- Create the database
DROP DATABASE IF EXISTS olist_db;

CREATE DATABASE olist_db;

USE olist_db;

-- Create tables
CREATE TABLE
    olist_customers_dataset (
        customer_id VARCHAR(255) PRIMARY KEY,
        customer_unique_id VARCHAR(255),
        customer_zip_code_prefix VARCHAR(10),
        customer_city VARCHAR(255),
        customer_state VARCHAR(255)
    ) ENGINE = InnoDB;

CREATE TABLE
    olist_geolocation_dataset (
        geolocation_zip_code_prefix VARCHAR(10),
        geolocation_lat DECIMAL(9, 6),
        geolocation_lng DECIMAL(9, 6),
        geolocation_city VARCHAR(255),
        geolocation_state VARCHAR(255),
        INDEX idx_zip_code (geolocation_zip_code_prefix)
    ) ENGINE = InnoDB;

CREATE TABLE
    olist_products_dataset (
        product_id VARCHAR(255) PRIMARY KEY,
        product_category_name VARCHAR(255),
        product_name_length INT,
        product_description_length INT,
        product_photos_qty INT,
        product_weight_g DECIMAL(10, 2),
        product_length_cm DECIMAL(10, 2),
        product_height_cm DECIMAL(10, 2),
        product_width_cm DECIMAL(10, 2)
    ) ENGINE = InnoDB;

CREATE TABLE
    olist_sellers_dataset (
        seller_id VARCHAR(255) PRIMARY KEY,
        seller_zip_code_prefix VARCHAR(10),
        seller_city VARCHAR(255),
        seller_state VARCHAR(255)
    ) ENGINE = InnoDB;

CREATE TABLE
    olist_orders_dataset (
        order_id VARCHAR(255) PRIMARY KEY,
        customer_id VARCHAR(255),
        order_status VARCHAR(255),
        order_purchase_timestamp DATETIME,
        order_approved_at DATETIME,
        order_delivered_carrier_date DATETIME,
        order_delivered_customer_date DATETIME,
        order_estimated_delivery_date DATETIME,
        FOREIGN KEY (customer_id) REFERENCES olist_customers_dataset (customer_id)
    ) ENGINE = InnoDB;

CREATE TABLE
    olist_order_items_dataset (
        order_id VARCHAR(255),
        order_item_id INT,
        product_id VARCHAR(255),
        seller_id VARCHAR(255),
        shipping_limit_date DATETIME,
        price DECIMAL(10, 2),
        freight_value DECIMAL(10, 2),
        PRIMARY KEY (order_id, order_item_id),
        FOREIGN KEY (order_id) REFERENCES olist_orders_dataset (order_id),
        FOREIGN KEY (product_id) REFERENCES olist_products_dataset (product_id),
        FOREIGN KEY (seller_id) REFERENCES olist_sellers_dataset (seller_id)
    ) ENGINE = InnoDB;

CREATE TABLE
    olist_order_payments_dataset (
        order_id VARCHAR(255),
        payment_sequential INT,
        payment_type VARCHAR(255),
        payment_installments INT,
        payment_value DECIMAL(10, 2),
        PRIMARY KEY (order_id, payment_sequential),
        FOREIGN KEY (order_id) REFERENCES olist_orders_dataset (order_id)
    ) ENGINE = InnoDB;

CREATE TABLE
    olist_order_reviews_dataset (
        review_id VARCHAR(255) PRIMARY KEY,
        order_id VARCHAR(255),
        review_score INT,
        review_comment_title TEXT,
        review_comment_message TEXT,
        review_creation_date DATETIME,
        review_answer_timestamp DATETIME,
        FOREIGN KEY (order_id) REFERENCES olist_orders_dataset (order_id)
    ) ENGINE = InnoDB;

CREATE TABLE
    product_category_name_translation (
        product_category_name VARCHAR(255) PRIMARY KEY,
        product_category_name_english VARCHAR(255)
    ) ENGINE = InnoDB;