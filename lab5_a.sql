CREATE TABLE customers_ec (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE products_ec (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE orders_ec (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES customers_ec(customer_id) ON DELETE RESTRICT,
    order_date DATE NOT NULL,
    total_amount NUMERIC NOT NULL CHECK (total_amount >= 0),
    status TEXT NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE order_details (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders_ec(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_ec(product_id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price >= 0)
);

INSERT INTO customers_ec VALUES 
(1, 'John Doe', 'john.doe@gmail.com', '+77011234567', '2026-01-15'),
(2, 'Aruzhan Omarova', 'aruzhan@mail.kz', '+77029876543', '2026-02-10'),
(3, 'Michael Smith', 'msmith@yahoo.com', '+77055554433', '2026-03-05'),
(4, 'Dana Kassymova', 'dana.k@gmail.com', '+77071112233', '2026-04-12'),
(5, 'Timur Bek', 'timur.bek@outlook.com', '+77089998877', '2026-05-20');

INSERT INTO products_ec VALUES 
(101, 'MacBook Pro', '16-inch, M3 Max, 32GB RAM', 2499.99, 15),
(102, 'Logitech MX Master 3S', 'Wireless Performance Mouse', 99.99, 50),
(103, 'Dell UltraSharp Monitor', '27-inch 4K UHD USB-C Hub Monitor', 550.00, 20),
(104, 'Keychron K2 Mechanical Keyboard', 'Wireless Hot-swappable', 89.99, 35),
(105, 'Sony WH-1000XM5', 'Wireless Noise Canceling Headphones', 399.99, 25);

INSERT INTO orders_ec VALUES 
(1001, 1, '2026-06-01', 2599.98, 'delivered'),
(1002, 2, '2026-06-02', 550.00, 'shipped'),
(1003, 3, '2026-06-03', 399.99, 'processing'),
(1004, 4, '2026-06-04', 189.98, 'pending'),
(1005, 5, '2026-06-05', 2499.99, 'cancelled');

INSERT INTO order_details VALUES 
(1, 1001, 101, 1, 2499.99),
(2, 1001, 102, 1, 99.99),
(3, 1002, 103, 1, 550.00),
(4, 1003, 105, 1, 399.99),
(5, 1004, 102, 2, 89.99);
