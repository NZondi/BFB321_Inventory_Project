from flask import Flask, render_template
import sqlite3

app = Flask(__name__)
@app.route('/')
def home():
    conn = sqlite3.connect('inventory.db')
    conn.row_factory = sqlite3.Row
    products = conn.execute('SELECT sku, product_name,quantity, price FROM products').fetchall()
    products_count = conn.execute('SELECT COUNT(*)  FROM products').fetchone()[0]
    items_count= conn.execute('SELECT SUM(quantity)  FROM products').fetchone()[0]
    total_value = conn.execute('SELECT SUM(price * quantity)  FROM products').fetchone()[0]
    conn.close()
    return render_template('index.html', products_count=products_count, items_count=items_count, total_value=total_value,products=products)
@app.route('/login')
def login():
    return render_template('login.html')
@app.route('/register')
def register():
    return render_template('register.html')
@app.route('/add_product')
def add_product():
    return render_template('add-product.html')
@app.route('/view_inventory')
def view_inventory():
    conn = sqlite3.connect('inventory.db')
    conn.row_factory = sqlite3.Row
    products = conn.execute('SELECT sku, product_name,quantity, price FROM products').fetchall()
    conn.close()
    return render_template('view-inventory.html',products=products)
if __name__ == '__main__':
    app.run(debug=True)