-- Create customers table with Rwanda-specific regions
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    region VARCHAR2(50) CHECK (region IN ('Kigali', 'Southern', 'Western', 'Northern', 'Eastern'))
);

-- Create products table with Ritco bus routes
CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    category VARCHAR2(50) CHECK (category IN ('Standard', 'Premium', 'Executive'))
);

-- Create transactions table for ticket sales
CREATE TABLE transactions (
    transaction_id NUMBER PRIMARY KEY,
    customer_id NUMBER REFERENCES customers(customer_id),
    product_id NUMBER REFERENCES products(product_id),
    sale_date DATE NOT NULL,
    amount NUMBER NOT NULL
);




-- Insert Rwanda customer data with real regions
INSERT INTO customers VALUES (1001, 'Alice Uwase', 'Kigali');
INSERT INTO customers VALUES (1002, 'Jean Bosco', 'Southern');
INSERT INTO customers VALUES (1003, 'Marie Aimee', 'Western');
INSERT INTO customers VALUES (1004, 'Patrick Habimana', 'Northern');
INSERT INTO customers VALUES (1005, 'Grace Mukamana', 'Eastern');
INSERT INTO customers VALUES (1006, 'David Ndayisaba', 'Kigali');
INSERT INTO customers VALUES (1007, 'Chantal Uwimana', 'Southern');
INSERT INTO customers VALUES (1008, 'Eric Maniraguha', 'Western');
INSERT INTO customers VALUES (1009, 'Annette Mujawimana', 'Northern');
INSERT INTO customers VALUES (1010, 'Samuel Twahirwa', 'Eastern');

-- Insert Ritco bus route products
INSERT INTO products VALUES (2001, 'Kigali to Huye', 'Standard');
INSERT INTO products VALUES (2002, 'Kigali to Musanze', 'Premium');
INSERT INTO products VALUES (2003, 'Kigali to Rubavu', 'Executive');
INSERT INTO products VALUES (2004, 'Kigali to Nyagatare', 'Standard');
INSERT INTO products VALUES (2005, 'Kigali to Kibuye', 'Premium');
INSERT INTO products VALUES (2006, 'Huye to Kigali', 'Standard');
INSERT INTO products VALUES (2007, 'Musanze to Kigali', 'Premium');
INSERT INTO products VALUES (2008, 'Rubavu to Kigali', 'Executive');

-- Insert transaction data with realistic dates and amounts
INSERT INTO transactions VALUES (3001, 1001, 2001, DATE '2024-01-15', 25000);
INSERT INTO transactions VALUES (3002, 1002, 2002, DATE '2024-01-20', 35000);
INSERT INTO transactions VALUES (3003, 1003, 2003, DATE '2024-02-10', 45000);
INSERT INTO transactions VALUES (3004, 1004, 2001, DATE '2024-02-15', 25000);
INSERT INTO transactions VALUES (3005, 1005, 2002, DATE '2024-03-05', 35000);
INSERT INTO transactions VALUES (3006, 1006, 2003, DATE '2024-03-20', 45000);
INSERT INTO transactions VALUES (3007, 1007, 2004, DATE '2024-04-10', 20000);
INSERT INTO transactions VALUES (3008, 1008, 2005, DATE '2024-04-25', 30000);
INSERT INTO transactions VALUES (3009, 1009, 2006, DATE '2024-05-15', 25000);
INSERT INTO transactions VALUES (3010, 1010, 2007, DATE '2024-05-20', 35000);
INSERT INTO transactions VALUES (3011, 1001, 2008, DATE '2024-06-10', 45000);
INSERT INTO transactions VALUES (3012, 1002, 2001, DATE '2024-06-15', 25000);
INSERT INTO transactions VALUES (3013, 1003, 2002, DATE '2024-07-05', 35000);
INSERT INTO transactions VALUES (3014, 1004, 2003, DATE '2024-07-20', 45000);
INSERT INTO transactions VALUES (3015, 1005, 2004, DATE '2024-08-10', 20000);