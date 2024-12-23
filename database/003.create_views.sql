

CREATE VIEW SALES.total_active_products_in_stock AS
SELECT 
    p.name AS product_name,
    COUNT(ps.id) AS total_in_stock
FROM SALES.PRODUCTS p
JOIN SALES.PRODUCTS_STOCK ps ON p.id = ps.product_id
WHERE p.state_id = 'ACTIVO' 
    AND ps.purchase_price > 0
GROUP BY p.name;
GO


CREATE VIEW SALES.total_orders_quetzales_august_2024 AS
SELECT 
    SUM(od.sell_price * od.quantity) AS total_quetzales
FROM SALES.ORDERS o
JOIN SALES.ORDERS_DETAILS od ON o.id = od.order_id
WHERE o.created_at BETWEEN '2024-08-01' AND '2024-08-31';
GO


CREATE VIEW SALES.top_10_customers_by_total_orders AS
SELECT TOP 10 
    si.user_id AS customer_id,
    SUM(od.sell_price * od.quantity) AS total_spent
FROM SALES.ORDERS o
JOIN SALES.ORDERS_DETAILS od ON o.id = od.order_id
JOIN SALES.SHIPPING_INFORMATION si ON o.client_id = si.id
GROUP BY si.user_id
ORDER BY total_spent DESC;
GO


CREATE VIEW SALES.top_10_most_sold_products AS
SELECT TOP 10 
    p.name AS product_name,
    SUM(od.quantity) AS total_sold
FROM SALES.ORDERS o
JOIN SALES.ORDERS_DETAILS od ON o.id = od.order_id
JOIN SALES.PRODUCTS p ON od.product_id = p.id
GROUP BY p.name
ORDER BY total_sold ASC;
GO



