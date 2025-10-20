-- Inventory Management System - SQLite Database Schema
-- Database: inventory.db

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS stock_updates;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS vendors;
DROP TABLE IF EXISTS categories;

-- Create product_categories table
CREATE TABLE product_categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT NOT NULL UNIQUE,
    category_description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create vendors table (for vendor registration and management)
CREATE TABLE vendors (
    vendor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    business_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    address TEXT,
    password TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create products table
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    sku TEXT UNIQUE NOT NULL,
    product_name TEXT NOT NULL,
    category_id INTEGER,
    quantity INTEGER NOT NULL DEFAULT 0,
    price REAL NOT NULL CHECK (price >= 0),
    description TEXT,
    supplier TEXT,
    min_stock_level INTEGER DEFAULT 0,
    max_stock_level INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id)
);

CREATE TABLE stock_updates (
    update_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    vendor_id INTEGER NOT NULL,
    update_type TEXT NOT NULL CHECK (update_type IN ('add', 'remove', 'set')),
    quantity_change INTEGER NOT NULL,
    old_quantity INTEGER NOT NULL,
    new_quantity INTEGER NOT NULL,
    reason TEXT NOT NULL CHECK (reason IN ('restock', 'sale', 'damage', 'return', 'adjustment', 'other')),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
);

-- Insert sample categories
INSERT INTO product_categories (category_name, category_description) VALUES
('Electronics', 'Electronic devices and gadgets'),
('Clothing', 'Apparel and fashion items'),
('Books', 'Books and publications'),
('Food & Beverages', 'Food and drink products'),
('Tools & Hardware', 'Tools and hardware supplies'),
('Furniture', 'Furniture and home items'),
('Beauty & Health', 'Beauty and health products'),
('Sports & Outdoors', 'Sports equipment and outdoor gear'),
('Other', 'Miscellaneous items');

-- Insert sample vendor
INSERT INTO vendors (first_name, last_name, business_name, email, phone, address, password) VALUES
('John', 'Doe', 'TechStore Solutions', 'john.doe@techstore.com', '+1-555-0123', '123 Business Ave, Commerce City, CC 12345', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeJwMkXQ7W7X1hU6u');

-- Insert sample products with corresponding categories
INSERT INTO products (sku, product_name, category_id, quantity, price, description, supplier, min_stock_level, max_stock_level) VALUES
('ELEC-001', 'Samsung Galaxy S23', 1, 25, 899.99, 'Latest Samsung smartphone with advanced camera features', 'Samsung Electronics', 5, 50),
('ELEC-002', 'iPhone 14 Pro', 1, 15, 999.00, 'Apple iPhone 14 Pro with ProRAW and ProRes capabilities', 'Apple Inc.', 3, 40),
('ACC-001', 'AirPods Pro', 1, 3, 249.00, 'Apple AirPods Pro with active noise cancellation', 'Apple Inc.', 5, 30),
('CLOTH-001', 'Nike Air Max', 2, 0, 120.00, 'Nike Air Max running shoes, size 10', 'Nike Inc.', 10, 100),
('BOOK-001', 'JavaScript: The Definitive Guide', 3, 45, 45.99, 'Comprehensive guide to JavaScript programming', 'OReilly Media', 10, 200),
('TOOL-001', 'Cordless Drill Set', 5, 8, 89.99, 'Professional cordless drill with multiple bits', 'DeWalt Tools', 5, 50),
('FURN-001', 'Office Chair', 6, 12, 199.99, 'Ergonomic office chair with lumbar support', 'Office Furniture Co', 3, 25),
('BEAU-001', 'Moisturizing Cream', 7, 30, 24.99, 'Daily moisturizing cream for all skin types', 'Beauty Supplies Ltd', 15, 100),
('SPORT-001', 'Yoga Mat', 8, 20, 39.99, 'Premium quality non-slip yoga mat', 'Fitness World', 10, 75),
('FOOD-001', 'Organic Coffee Beans', 4, 50, 18.99, 'Premium organic coffee beans, 1lb bag', 'Organic Farms', 20, 200);

-- Insert sample stock updates to show activity history
INSERT INTO stock_updates (product_id, vendor_id, update_type, quantity_change, old_quantity, new_quantity, reason, notes) VALUES
(1, 1, 'add', 10, 15, 25, 'restock', 'Received new shipment from Samsung'),
(3, 1, 'remove', 2, 5, 3, 'sale', 'Sold 2 units to walk-in customer'),
(2, 1, 'remove', 1, 16, 15, 'sale', 'Online order #12345'),
(4, 1, 'remove', 5, 5, 0, 'sale', 'Final units sold during clearance'),
(1, 1, 'remove', 3, 28, 25, 'damage', '3 units damaged in shipping, returned to supplier'),
(5, 1, 'add', 20, 25, 45, 'restock', 'Monthly book inventory replenishment'),
(6, 1, 'remove', 2, 10, 8, 'sale', 'Contractor bulk order #67890'),
(7, 1, 'add', 5, 7, 12, 'restock', 'Office furniture restock order');


