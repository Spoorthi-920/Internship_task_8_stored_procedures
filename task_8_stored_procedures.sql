-- ==========================================
-- Task 8: Stored Procedures and Functions
-- Objective: Modularize SQL logic for reuse
-- ==========================================

-- Created a sample database
DROP DATABASE IF EXISTS e_commerce;
CREATE DATABASE e_commerce;
USE e_commerce;

-- Step 1: Create Sample Tables
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Step 2: Insert Sample Data
INSERT INTO customers (customer_name, city)
VALUES ('Spoorthi', 'Delhi'),
       ('Chinnu', 'Mumbai'),
       ('Mahi', 'Bangalore');

INSERT INTO orders (customer_id, order_date, amount)
VALUES 
(1, '2025-10-01', 1200.50),
(1, '2025-10-15', 800.00),
(2, '2025-10-10', 2500.00),
(3, '2025-10-20', 300.00);


-- Step 3: Create a Stored Procedure
DELIMITER $$

CREATE PROCEDURE GetCustomerTotalSpent (IN cust_id INT)
BEGIN
    SELECT c.customer_name,
           SUM(o.amount) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE c.customer_id = cust_id
    GROUP BY c.customer_name;
END $$

DELIMITER ;

CALL GetCustomerTotalSpent(1);

-- Step 4: Create a Function - GetDiscount
DELIMITER $$

CREATE FUNCTION GetDiscount(amount DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE discount DECIMAL(10,2);
    
    IF amount >= 2000 THEN
        SET discount = amount * 0.10;   -- 10% discount
    ELSEIF amount >= 1000 THEN
        SET discount = amount * 0.05;   -- 5% discount
    ELSE
        SET discount = 0;
    END IF;

    RETURN discount;
END $$

DELIMITER ;

SELECT order_id, amount, GetDiscount(amount) AS discount
FROM orders;




