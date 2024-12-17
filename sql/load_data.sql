-- Set global variables to handle file import
SET GLOBAL local_infile = 1;

-- Disable foreign key checks temporarily for faster loading
SET FOREIGN_KEY_CHECKS = 0;

-- Load data into tables without foreign key dependencies first
LOAD DATA LOCAL INFILE '/home/satyam/github_repos/db_performance_analysis/data/brazillian-ecommerce-dataset/olist_customers_dataset.csv'
INTO TABLE olist_customers_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/satyam/github_repos/db_performance_analysis/data/brazillian-ecommerce-dataset/olist_geolocation_dataset.csv'
INTO TABLE olist_geolocation_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/satyam/github_repos/db_performance_analysis/data/brazillian-ecommerce-dataset/olist_products_dataset.csv'
INTO TABLE olist_products_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/satyam/github_repos/db_performance_analysis/data/brazillian-ecommerce-dataset/olist_sellers_dataset.csv'
INTO TABLE olist_sellers_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/satyam/github_repos/db_performance_analysis/data/brazillian-ecommerce-dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load data into tables with foreign key dependencies
LOAD DATA LOCAL INFILE '/home/satyam/github_repos/db_performance_analysis/data/brazillian-ecommerce-dataset/olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, 
@order_purchase_timestamp, @order_approved_at, @order_delivered_carrier_date, 
@order_delivered_customer_date, @order_estimated_delivery_date)
SET
order_purchase_timestamp = NULLIF(@order_purchase_timestamp,''),
order_approved_at = NULLIF(@order_approved_at,''),
order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date,''),
order_delivered_customer_date = NULLIF(@order_delivered_customer_date,''),
order_estimated_delivery_date = NULLIF(@order_estimated_delivery_date,'');

LOAD DATA LOCAL INFILE '/home/satyam/github_repos/db_performance_analysis/data/brazillian-ecommerce-dataset/olist_order_items_dataset.csv'
INTO TABLE olist_order_items_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_item_id, product_id, seller_id, 
@shipping_limit_date, price, freight_value)
SET
shipping_limit_date = NULLIF(@shipping_limit_date,'');

LOAD DATA LOCAL INFILE '/home/satyam/github_repos/db_performance_analysis/data/brazillian-ecommerce-dataset/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/satyam/github_repos/db_performance_analysis/data/brazillian-ecommerce-dataset/olist_order_reviews_dataset.csv'
INTO TABLE olist_order_reviews_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id, order_id, review_score, review_comment_title, 
review_comment_message, @review_creation_date, @review_answer_timestamp)
SET
review_creation_date = NULLIF(@review_creation_date,''),
review_answer_timestamp = NULLIF(@review_answer_timestamp,'');

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Verify data loading
SELECT 'olist_customers_dataset' as table_name, COUNT(*) as record_count FROM olist_customers_dataset
UNION ALL
SELECT 'olist_geolocation_dataset', COUNT(*) FROM olist_geolocation_dataset
UNION ALL
SELECT 'olist_products_dataset', COUNT(*) FROM olist_products_dataset
UNION ALL
SELECT 'olist_sellers_dataset', COUNT(*) FROM olist_sellers_dataset
UNION ALL
SELECT 'olist_orders_dataset', COUNT(*) FROM olist_orders_dataset
UNION ALL
SELECT 'olist_order_items_dataset', COUNT(*) FROM olist_order_items_dataset
UNION ALL
SELECT 'olist_order_payments_dataset', COUNT(*) FROM olist_order_payments_dataset
UNION ALL
SELECT 'olist_order_reviews_dataset', COUNT(*) FROM olist_order_reviews_dataset
UNION ALL
SELECT 'product_category_name_translation', COUNT(*) FROM product_category_name_translation;
