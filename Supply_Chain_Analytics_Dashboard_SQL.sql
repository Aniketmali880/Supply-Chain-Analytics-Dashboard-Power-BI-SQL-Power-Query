/*
Supply Chain Analytics Dashboard - SQL Analysis Pack
Dialect: SQLite 3
Purpose: Create a small sample supply-chain dataset and run analyses for a Power BI dashboard.

How to use:
1. Open this file in DB Browser for SQLite, SQLiteStudio, or adapt it to your SQL database.
2. Execute the full script.
3. Use the SELECT queries in the ANALYSIS QUERIES section as Power BI source queries.
4. The sample data is synthetic and for demonstration only.
*/

PRAGMA foreign_keys = ON;

-- =========================================================
-- 1. RESET TABLES
-- =========================================================
DROP VIEW IF EXISTS vw_supplier_lead_time;
DROP VIEW IF EXISTS vw_order_delivery_status;
DROP TABLE IF EXISTS supply_chain_costs;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS regions;

-- =========================================================
-- 2. TABLES
-- =========================================================
CREATE TABLE regions (
    region_id INTEGER PRIMARY KEY,
    region_name TEXT NOT NULL UNIQUE,
    country TEXT NOT NULL
);

CREATE TABLE suppliers (
    supplier_id INTEGER PRIMARY KEY,
    supplier_name TEXT NOT NULL,
    region_id INTEGER,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    unit_cost REAL NOT NULL CHECK (unit_cost >= 0),
    reorder_level INTEGER NOT NULL DEFAULT 50
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date TEXT NOT NULL,           -- YYYY-MM-DD
    customer_id INTEGER NOT NULL,
    region_id INTEGER NOT NULL,
    order_status TEXT NOT NULL,          -- Received, Processing, Shipped, Delivered, Cancelled
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price REAL NOT NULL CHECK (unit_price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE shipments (
    shipment_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    supplier_id INTEGER NOT NULL,
    ship_date TEXT,
    promised_delivery_date TEXT,
    actual_delivery_date TEXT,
    shipment_status TEXT NOT NULL,       -- On-Time, Delayed, In Transit
    transport_mode TEXT NOT NULL,        -- Road, Rail, Air, Sea
    transport_cost REAL NOT NULL DEFAULT 0,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE inventory (
    inventory_id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    warehouse_region_id INTEGER NOT NULL,
    snapshot_date TEXT NOT NULL,
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_region_id) REFERENCES regions(region_id)
);

CREATE TABLE supply_chain_costs (
    cost_id INTEGER PRIMARY KEY,
    cost_date TEXT NOT NULL,
    cost_category TEXT NOT NULL,         -- Transportation, Warehousing, Procurement, Inventory Holding, Others
    amount REAL NOT NULL CHECK (amount >= 0),
    region_id INTEGER NOT NULL,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

-- =========================================================
-- 3. SAMPLE DATA (synthetic demo records)
-- =========================================================
INSERT INTO regions VALUES
(1, 'North', 'India'),
(2, 'West', 'India'),
(3, 'South', 'India'),
(4, 'East', 'India');

INSERT INTO suppliers VALUES
(1, 'ABC Supplies', 1),
(2, 'Global Traders', 2),
(3, 'TechSource', 3),
(4, 'HomeGoods Inc.', 4),
(5, 'Prime Logistics', 2);

INSERT INTO products VALUES
(1, 'Smartphone', 'Electronics', 18000, 80),
(2, 'Laptop', 'Electronics', 42000, 40),
(3, 'Refrigerator', 'Home Appliances', 22000, 35),
(4, 'Washing Machine', 'Home Appliances', 17000, 30),
(5, 'Office Chair', 'Furniture', 3500, 60),
(6, 'T-Shirt', 'Apparel', 450, 100),
(7, 'Coffee Maker', 'Others', 1800, 45),
(8, 'Packaged Food', 'Food & Beverages', 120, 150);

INSERT INTO orders VALUES
(1001, '2024-01-05', 501, 2, 'Delivered'),
(1002, '2024-01-12', 502, 1, 'Delivered'),
(1003, '2024-02-02', 503, 3, 'Delivered'),
(1004, '2024-02-17', 504, 4, 'Shipped'),
(1005, '2024-03-04', 505, 2, 'Delivered'),
(1006, '2024-03-19', 506, 1, 'Delivered'),
(1007, '2024-04-08', 507, 3, 'Processing'),
(1008, '2024-04-23', 508, 4, 'Delivered'),
(1009, '2024-05-02', 509, 2, 'Delivered'),
(1010, '2024-05-21', 510, 1, 'Cancelled'),
(1011, '2024-06-06', 511, 3, 'Delivered'),
(1012, '2024-06-26', 512, 4, 'Delivered'),
(1013, '2024-07-03', 513, 2, 'Delivered'),
(1014, '2024-07-18', 514, 1, 'Shipped'),
(1015, '2024-08-09', 515, 3, 'Delivered'),
(1016, '2024-08-28', 516, 4, 'Delivered'),
(1017, '2024-09-11', 517, 2, 'Delivered'),
(1018, '2024-09-24', 518, 1, 'Delivered'),
(1019, '2024-10-05', 519, 3, 'Delivered'),
(1020, '2024-10-20', 520, 4, 'Processing'),
(1021, '2024-11-07', 521, 2, 'Delivered'),
(1022, '2024-11-22', 522, 1, 'Delivered'),
(1023, '2024-12-02', 523, 3, 'Delivered'),
(1024, '2024-12-19', 524, 4, 'Delivered');

INSERT INTO order_items VALUES
(1,1001,1,2,22000),(2,1001,5,4,5200),
(3,1002,2,1,52000),(4,1002,6,10,750),
(5,1003,3,2,28500),(6,1003,8,40,180),
(7,1004,4,1,22500),(8,1004,7,3,2600),
(9,1005,1,3,22000),(10,1005,5,6,5200),
(11,1006,2,2,52000),(12,1006,6,15,750),
(13,1007,3,1,28500),(14,1007,8,50,180),
(15,1008,4,2,22500),(16,1008,7,4,2600),
(17,1009,1,1,22000),(18,1009,5,3,5200),
(19,1010,2,1,52000),(20,1010,6,8,750),
(21,1011,3,2,28500),(22,1011,8,60,180),
(23,1012,4,1,22500),(24,1012,7,2,2600),
(25,1013,1,4,22000),(26,1013,5,5,5200),
(27,1014,2,1,52000),(28,1014,6,12,750),
(29,1015,3,1,28500),(30,1015,8,35,180),
(31,1016,4,2,22500),(32,1016,7,3,2600),
(33,1017,1,2,22000),(34,1017,5,2,5200),
(35,1018,2,1,52000),(36,1018,6,20,750),
(37,1019,3,3,28500),(38,1019,8,45,180),
(39,1020,4,1,22500),(40,1020,7,5,2600),
(41,1021,1,2,22000),(42,1021,5,4,5200),
(43,1022,2,1,52000),(44,1022,6,10,750),
(45,1023,3,2,28500),(46,1023,8,55,180),
(47,1024,4,1,22500),(48,1024,7,4,2600);

INSERT INTO shipments VALUES
(1,1001,1,'2024-01-06','2024-01-10','2024-01-09','On-Time','Road',1200),
(2,1002,2,'2024-01-13','2024-01-18','2024-01-18','On-Time','Rail',1800),
(3,1003,3,'2024-02-03','2024-02-08','2024-02-10','Delayed','Road',950),
(4,1004,4,'2024-02-18','2024-02-23',NULL,'In Transit','Road',800),
(5,1005,1,'2024-03-05','2024-03-10','2024-03-09','On-Time','Air',3200),
(6,1006,2,'2024-03-20','2024-03-25','2024-03-24','On-Time','Rail',1700),
(7,1007,3,'2024-04-09','2024-04-14',NULL,'In Transit','Road',1100),
(8,1008,4,'2024-04-24','2024-04-29','2024-05-02','Delayed','Road',900),
(9,1009,1,'2024-05-03','2024-05-08','2024-05-08','On-Time','Sea',700),
(10,1010,2,NULL,'2024-05-26',NULL,'Cancelled','Road',0),
(11,1011,3,'2024-06-07','2024-06-12','2024-06-11','On-Time','Rail',1600),
(12,1012,4,'2024-06-27','2024-07-02','2024-07-05','Delayed','Road',1000),
(13,1013,1,'2024-07-04','2024-07-09','2024-07-08','On-Time','Air',3100),
(14,1014,2,'2024-07-19','2024-07-24',NULL,'In Transit','Road',850),
(15,1015,3,'2024-08-10','2024-08-15','2024-08-14','On-Time','Rail',1550),
(16,1016,4,'2024-08-29','2024-09-03','2024-09-06','Delayed','Road',950),
(17,1017,1,'2024-09-12','2024-09-17','2024-09-16','On-Time','Sea',650),
(18,1018,2,'2024-09-25','2024-09-30','2024-09-30','On-Time','Rail',1650),
(19,1019,3,'2024-10-06','2024-10-11','2024-10-10','On-Time','Road',1050),
(20,1020,4,'2024-10-21','2024-10-26',NULL,'In Transit','Road',900),
(21,1021,1,'2024-11-08','2024-11-13','2024-11-15','Delayed','Road',1150),
(22,1022,2,'2024-11-23','2024-11-28','2024-11-27','On-Time','Rail',1750),
(23,1023,3,'2024-12-03','2024-12-08','2024-12-07','On-Time','Air',3000),
(24,1024,4,'2024-12-20','2024-12-25','2024-12-24','On-Time','Road',1000);

INSERT INTO inventory VALUES
(1,1,1,'2024-12-31',145),(2,2,1,'2024-12-31',28),
(3,3,2,'2024-12-31',42),(4,4,2,'2024-12-31',18),
(5,5,3,'2024-12-31',95),(6,6,3,'2024-12-31',125),
(7,7,4,'2024-12-31',32),(8,8,4,'2024-12-31',210),
(9,1,2,'2024-12-31',60),(10,2,3,'2024-12-31',35),
(11,3,4,'2024-12-31',25),(12,4,1,'2024-12-31',38);

INSERT INTO supply_chain_costs VALUES
(1,'2024-01-31','Transportation',18000,1),
(2,'2024-02-28','Warehousing',12000,2),
(3,'2024-03-31','Procurement',42000,3),
(4,'2024-04-30','Inventory Holding',9000,4),
(5,'2024-05-31','Transportation',22000,2),
(6,'2024-06-30','Warehousing',14000,1),
(7,'2024-07-31','Procurement',48000,2),
(8,'2024-08-31','Inventory Holding',11000,3),
(9,'2024-09-30','Others',7000,4),
(10,'2024-10-31','Transportation',25000,3),
(11,'2024-11-30','Warehousing',16000,2),
(12,'2024-12-31','Procurement',51000,1);

-- =========================================================
-- 4. HELPER VIEWS
-- =========================================================
CREATE VIEW vw_order_delivery_status AS
SELECT
    o.order_id,
    o.order_date,
    o.region_id,
    r.region_name,
    o.order_status,
    s.shipment_status,
    s.ship_date,
    s.promised_delivery_date,
    s.actual_delivery_date,
    CASE
        WHEN s.actual_delivery_date IS NOT NULL
             AND s.promised_delivery_date IS NOT NULL
             AND s.actual_delivery_date <= s.promised_delivery_date
            THEN 'On-Time'
        WHEN s.actual_delivery_date IS NOT NULL
             AND s.promised_delivery_date IS NOT NULL
             AND s.actual_delivery_date > s.promised_delivery_date
            THEN 'Delayed'
        WHEN s.actual_delivery_date IS NULL THEN 'Not Delivered'
        ELSE 'Unknown'
    END AS calculated_delivery_status,
    CASE
        WHEN s.ship_date IS NOT NULL AND s.actual_delivery_date IS NOT NULL
        THEN CAST(julianday(s.actual_delivery_date) - julianday(s.ship_date) AS INTEGER)
        ELSE NULL
    END AS lead_time_days
FROM orders o
LEFT JOIN shipments s ON o.order_id = s.order_id
LEFT JOIN regions r ON o.region_id = r.region_id;

CREATE VIEW vw_supplier_lead_time AS
SELECT
    sp.supplier_id,
    sp.supplier_name,
    COUNT(s.shipment_id) AS shipment_count,
    ROUND(AVG(julianday(s.actual_delivery_date) - julianday(s.ship_date)), 1) AS avg_lead_time_days,
    SUM(CASE
        WHEN s.actual_delivery_date <= s.promised_delivery_date
             AND s.actual_delivery_date IS NOT NULL THEN 1 ELSE 0
    END) AS on_time_shipments,
    ROUND(
        100.0 * SUM(CASE
            WHEN s.actual_delivery_date <= s.promised_delivery_date
                 AND s.actual_delivery_date IS NOT NULL THEN 1 ELSE 0
        END) / NULLIF(SUM(CASE WHEN s.actual_delivery_date IS NOT NULL THEN 1 ELSE 0 END), 0),
        1
    ) AS on_time_rate_pct
FROM suppliers sp
LEFT JOIN shipments s ON sp.supplier_id = s.supplier_id
GROUP BY sp.supplier_id, sp.supplier_name;

-- =========================================================
-- 5. ANALYSIS QUERIES - POWER BI VISUALS
-- Run each SELECT separately when importing query results.
-- =========================================================

-- Q1. KPI cards: orders, sales, on-time delivery, fulfillment, costs.
-- Sales are calculated from order items; cancelled orders are excluded.
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_sales,
    ROUND(
        100.0 * SUM(CASE WHEN v.calculated_delivery_status = 'On-Time' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN v.calculated_delivery_status IN ('On-Time','Delayed') THEN 1 ELSE 0 END), 0),
        1
    ) AS on_time_delivery_rate_pct,
    ROUND(
        100.0 * SUM(CASE WHEN o.order_status = 'Delivered' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(DISTINCT o.order_id), 0),
        1
    ) AS delivered_order_rate_pct,
    ROUND((SELECT SUM(amount) FROM supply_chain_costs), 2) AS total_supply_chain_cost
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN vw_order_delivery_status v ON o.order_id = v.order_id
WHERE o.order_status <> 'Cancelled';

-- Q2. Monthly order trend and sales.
SELECT
    strftime('%Y-%m', o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status <> 'Cancelled'
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY order_month;

-- Q3. Delivery status donut chart.
SELECT
    calculated_delivery_status AS delivery_status,
    COUNT(*) AS shipment_count
FROM vw_order_delivery_status
WHERE order_status <> 'Cancelled'
GROUP BY calculated_delivery_status
ORDER BY shipment_count DESC;

-- Q4. Orders and sales by product category.
SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS sales
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status <> 'Cancelled'
GROUP BY p.category
ORDER BY orders DESC;

-- Q5. Inventory status by category; flags products needing replenishment.
SELECT
    p.category,
    SUM(i.stock_quantity) AS stock_units,
    SUM(p.reorder_level) AS combined_reorder_level,
    SUM(CASE WHEN i.stock_quantity < p.reorder_level THEN 1 ELSE 0 END) AS products_below_reorder,
    SUM(CASE WHEN i.stock_quantity = 0 THEN 1 ELSE 0 END) AS out_of_stock_products
FROM inventory i
JOIN products p ON i.product_id = p.product_id
GROUP BY p.category
ORDER BY products_below_reorder DESC, stock_units ASC;

-- Q6. Supply-chain cost breakdown.
SELECT
    cost_category,
    ROUND(SUM(amount), 2) AS total_cost,
    ROUND(100.0 * SUM(amount) / NULLIF((SELECT SUM(amount) FROM supply_chain_costs), 0), 1) AS cost_share_pct
FROM supply_chain_costs
GROUP BY cost_category
ORDER BY total_cost DESC;

-- Q7. Top suppliers by shipment-related spend.
SELECT
    sp.supplier_name,
    COUNT(s.shipment_id) AS shipments,
    ROUND(SUM(s.transport_cost), 2) AS transportation_spend
FROM suppliers sp
JOIN shipments s ON sp.supplier_id = s.supplier_id
GROUP BY sp.supplier_id, sp.supplier_name
ORDER BY transportation_spend DESC
LIMIT 10;

-- Q8. On-time delivery rate by region.
SELECT
    region_name,
    COUNT(*) AS total_orders_with_shipment,
    SUM(CASE WHEN calculated_delivery_status = 'On-Time' THEN 1 ELSE 0 END) AS on_time_deliveries,
    ROUND(
        100.0 * SUM(CASE WHEN calculated_delivery_status = 'On-Time' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN calculated_delivery_status IN ('On-Time','Delayed') THEN 1 ELSE 0 END), 0),
        1
    ) AS on_time_delivery_rate_pct
FROM vw_order_delivery_status
WHERE order_status <> 'Cancelled'
GROUP BY region_name
ORDER BY on_time_delivery_rate_pct DESC;

-- Q9. Order fulfillment funnel.
SELECT 'Orders Received' AS stage, COUNT(*) AS order_count, 1 AS stage_sort
FROM orders
WHERE order_status <> 'Cancelled'
UNION ALL
SELECT 'Orders Processed', COUNT(*), 2
FROM orders
WHERE order_status IN ('Processing','Shipped','Delivered')
UNION ALL
SELECT 'Shipped', COUNT(*), 3
FROM orders
WHERE order_status IN ('Shipped','Delivered')
UNION ALL
SELECT 'Delivered', COUNT(*), 4
FROM orders
WHERE order_status = 'Delivered'
ORDER BY stage_sort;

-- Q10. Supplier lead time and on-time performance.
SELECT
    supplier_name,
    shipment_count,
    avg_lead_time_days,
    on_time_shipments,
    on_time_rate_pct
FROM vw_supplier_lead_time
ORDER BY avg_lead_time_days ASC;

-- Q11. Detailed late deliveries for root-cause analysis.
SELECT
    order_id,
    region_name,
    ship_date,
    promised_delivery_date,
    actual_delivery_date,
    lead_time_days,
    calculated_delivery_status
FROM vw_order_delivery_status
WHERE calculated_delivery_status = 'Delayed'
ORDER BY lead_time_days DESC;

-- Q12. Orders and sales by region and month (useful for drill-through).
SELECT
    r.region_name,
    strftime('%Y-%m', o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS order_count,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS sales
FROM orders o
JOIN regions r ON o.region_id = r.region_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status <> 'Cancelled'
GROUP BY r.region_name, strftime('%Y-%m', o.order_date)
ORDER BY order_month, r.region_name;

-- Q13. Inventory by product and warehouse region.
SELECT
    r.region_name AS warehouse_region,
    p.product_name,
    p.category,
    i.stock_quantity,
    p.reorder_level,
    CASE
        WHEN i.stock_quantity = 0 THEN 'Out of Stock'
        WHEN i.stock_quantity < p.reorder_level THEN 'Reorder'
        ELSE 'In Stock'
    END AS inventory_flag
FROM inventory i
JOIN products p ON i.product_id = p.product_id
JOIN regions r ON i.warehouse_region_id = r.region_id
ORDER BY inventory_flag, p.category, p.product_name;

-- Q14. Transportation mode analysis.
SELECT
    transport_mode,
    COUNT(*) AS shipment_count,
    ROUND(AVG(julianday(actual_delivery_date) - julianday(ship_date)), 1) AS avg_lead_time_days,
    ROUND(SUM(transport_cost), 2) AS total_transport_cost,
    ROUND(
        100.0 * SUM(CASE WHEN actual_delivery_date <= promised_delivery_date
                          AND actual_delivery_date IS NOT NULL THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN actual_delivery_date IS NOT NULL THEN 1 ELSE 0 END), 0),
        1
    ) AS on_time_rate_pct
FROM shipments
GROUP BY transport_mode
ORDER BY total_transport_cost DESC;

-- Q15. Customer-level order value for segmentation.
SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS order_count,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS lifetime_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status <> 'Cancelled'
GROUP BY o.customer_id
ORDER BY lifetime_sales DESC;

-- =========================================================
-- END
-- =========================================================
