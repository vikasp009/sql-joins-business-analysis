CREATE DATABASE ecommerce_sql;
USE ecommerce_sql;

-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    country VARCHAR(50)
);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Categories table
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Order items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Customers
INSERT INTO customers VALUES
(1, 'Amit', 'India'),
(2, 'Sara', 'USA'),
(3, 'John', 'UK'),
(4, 'Neha', 'India');

-- Categories
INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Clothing');

-- Products
INSERT INTO products VALUES
(1, 'Laptop', 1, 60000),
(2, 'Mobile', 1, 30000),
(3, 'T-Shirt', 2, 1500);

-- Orders
INSERT INTO orders VALUES
(101, 1, '2024-01-10'),
(102, 2, '2024-01-15'),
(103, 1, '2024-02-01');

-- Order Items
INSERT INTO order_items VALUES
(1, 101, 1, 1),
(2, 101, 3, 2),
(3, 102, 2, 1),
(4, 103, 2, 2);

SHOW TABLES;

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM products;
SELECT * FROM categories;

SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    c.country
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;

SELECT COUNT(*) FROM orders;
SELECT COUNT(*)
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;
    
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

/* =========================================================
   TASK 3: LEFT JOIN
   Find customers who never placed any orders
   Business use: Identify non-converted customers for marketing
   ========================================================= */

SELECT
    c.customer_id,
    c.customer_name,
    c.country
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


/* =========================================================
   TASK 4: Revenue per Product
   Calculate total revenue and identify high-performing SKUs
   Revenue = quantity × price
   ========================================================= */

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;


/* =========================================================
   TASK 5: Category-wise Revenue Distribution
   Used for product and category strategy decisions
   ========================================================= */

SELECT
    c.category_name,
    SUM(oi.quantity * p.price) AS category_revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
INNER JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC;


/* =========================================================
   TASK 6: Sales in Region X Between Date Y and Z
   Example: Sales in India during January 2024
   ========================================================= */

SELECT
    c.country,
    SUM(oi.quantity * p.price) AS total_sales
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
WHERE c.country = 'India'
  AND o.order_date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY c.country;

SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    c.country,
    p.product_name,
    oi.quantity,
    (oi.quantity * p.price) AS revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id;

