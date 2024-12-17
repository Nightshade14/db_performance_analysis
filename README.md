# Database Performance Analysis

## Dataset
- It is a Brazillian ecommerce Public Dataset
- It is publicly available on Kaggle : [Kaggle Brazillian ecommerce Public Dataset Link](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## Initial Performance Analysis

### Analysis approach
- We use the `EXPLAIN ANALYZE` feature of SQL to measure the actual execution time and costs of each part of the query with respect to the Query Evaluation Plan.


### Output of Explain Analyze of Baseline Query:
* Sort: o.order_purchase_timestamp DESC  (actual time=48.7..48.7 rows=16 loops=1) <br/>
    * Stream results  (cost=39124 rows=9751) (actual time=2.68..48.7 rows=16 loops=1) <br/>
        * Nested loop inner join  (cost=39124 rows=9751) (actual time=2.66..48.7 rows=16 loops=1) <br/>
            * Nested loop inner join  (cost=28752 rows=9751) (actual time=2.65..48.5 rows=16 loops=1) <br/>
                * Nested loop inner join  (cost=20530 rows=9751) (actual time=2.63..48.4 rows=17 loops=1) <br/>
                    * Filter: (c.customer_unique_id = '8d50f5eadf50201ccdcedfb9e2ac8455')  (cost=10049 rows=9751) (actual time=2.57..48.1 rows=17 loops=1) <br/>
                        * Table scan on c  (cost=10049 rows=97514) (actual time=0.12..31.7 rows=99441 loops=1) <br/>
                    * Index lookup on o using customer_id (customer_id=c.customer_id)  (cost=0.975 rows=1) (actual time=0.0151..0.0156 rows=1 loops=17) <br/>
                * Filter: (oi.product_id is not null)  (cost=0.743 rows=1) (actual time=0.00967..0.0105 rows=0.941 loops=17) <br/>
                    * Index lookup on oi using PRIMARY (order_id=o.order_id)  (cost=0.743 rows=1) (actual time=0.00903..0.00956 rows=0.941 loops=17) <br/>
            * Single-row index lookup on p using PRIMARY (product_id=oi.product_id)  (cost=0.964 rows=1) (actual time=0.0061..0.00625 rows=1 loops=16) <br/>

- With Primary Keys there are already some indices by default, created automatically by MySQL.
- We can observe that we need to scan the whole customer table and it took 31.58 ms. And narrowing down the ids with the given id took `45.53 ms`.
- The whole query took 48.7 ms.

## Proposed Fixes

## Performance Analysis after implementing proposed fixes

* Sort: o.order_purchase_timestamp DESC  (actual time=17.1..17.1 rows=16 loops=1)
    * Stream results  (cost=56.3 rows=17) (actual time=1.61..17.1 rows=16 loops=1)
        * Nested loop inner join  (cost=56.3 rows=17) (actual time=1.6..17 rows=16 loops=1)
            * Nested loop inner join  (cost=37.7 rows=17) (actual time=0.736..11.1 rows=16 loops=1)
                * Nested loop inner join  (cost=23.4 rows=17) (actual time=0.717..7.18 rows=17 loops=1)
                    * Covering index lookup on c using idx_customer_unique_id (customer_unique_id='8d50f5eadf50201ccdcedfb9e2ac8455')  (cost=4.97 rows=17) (actual time=0.0358..0.0543 rows=17 loops=1)
                    * Index lookup on o using idx_order_customer_timestamp (customer_id=c.customer_id)  (cost=0.992 rows=1) (actual time=0.417..0.418 rows=1 loops=17)
                * Filter: (oi.product_id is not null)  (cost=0.742 rows=1) (actual time=0.23..0.232 rows=0.941 loops=17)
                    * Index lookup on oi using PRIMARY (order_id=o.order_id)  (cost=0.742 rows=1) (actual time=0.229..0.231 rows=0.941 loops=17)
            * Single-row index lookup on p using PRIMARY (product_id=oi.product_id)  (cost=1 rows=1) (actual time=0.367..0.367 rows=1 loops=16)

- We created 5 indices to minimize the run-time of our baseline query
    - idx_customer_unique_id ON olist_customers_dataset (customer_unique_id);
    - idx_order_customer_timestamp ON olist_orders_dataset (customer_id, order_purchase_timestamp);
    - idx_order_items_composite ON olist_order_items_dataset (order_id, product_id);
    - idx_product_id ON olist_products_dataset (product_id);
- With these indices, we minimize the data record look-up times. And thus also minimize the data transfer times.
- It also removed the extra filtering step.
- We can observe that:
    - We do not need to scan the whole table.
    - We can directly narrow down to the specific ids due to the indices created.
- We can see that to find the specific id, we took `0.0185 ms`.
- The whole query took 17.1 ms. This whole query execution time is a liitle more than the half of the time it took to scan the customers table in the approach without indices.


## Submission Link
[Principles of Database Systems mini-project demo](https://drive.google.com/drive/folders/1ktuDNGAbvA9FAj15pzXn7wy0DmsZZXcg?usp=sharing)

[Project GitHub Link](https://github.com/Nightshade14/db_performance_analysis)