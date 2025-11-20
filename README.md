# PWebQuiz2

A simple room booking web application using JSP.  
**Environment:** Tomcat 10.1/Tomcat 11 · JDK 24 · VSCode

---

### 1. Database Configuration

Open `db.jsp` and **change `dbUser` and `dbPass`** values to your own database credentials.

---

### 2. Database Setup

Copy and run the following SQL to set up your database and tables:

```sql
-- Create the database
CREATE DATABASE IF NOT EXISTS itstudy_jsp;
USE itstudy_jsp;

-- Create users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    password VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create room types table
CREATE TABLE room_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price_per_hour INT NOT NULL
);

-- Insert initial room types
INSERT INTO room_types (name, price_per_hour) VALUES
('Individual Desk', 15000),
('Group Desk', 35000),
('VIP Room', 50000);

-- Create rooms table
CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_type_id INT NOT NULL,
    room_number VARCHAR(50) NOT NULL,
    FOREIGN KEY (room_type_id) REFERENCES room_types(id)
);

-- Insert room numbers
INSERT INTO rooms (room_type_id, room_number) VALUES
(1, 'A1'), (1, 'A2'), (1, 'A3'), (1, 'A4'), (1, 'A5'), (1, 'A6'),
(1, 'A7'), (1, 'A8'), (1, 'A9'), (1, 'A10'), (1, 'A11'), (1, 'A12'),
(1, 'A13'), (1, 'A14'), (1, 'A15'), (1, 'A16'), (1, 'A17'), (1, 'A18'),
(1, 'A19'), (1, 'A20'), (1, 'A21'), (1, 'A22'), (1, 'A23'), (1, 'A24'),
(1, 'A25'), (1, 'A26'), (1, 'A27'), (1, 'A28'), (1, 'A29'), (1, 'A30'),
(2, 'B1'), (2, 'B2'), (2, 'B3'), (2, 'B4'), (2, 'B5'), (2, 'B6'),
(2, 'B7'), (2, 'B8'), (2, 'B9'), (2, 'B10'), (2, 'B11'), (2, 'B12'),
(3, 'M1'), (3, 'M2'), (3, 'M3'), (3, 'M4'), (3, 'M5');

-- Create bookings table
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    total_price INT NOT NULL,
    status ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
    order_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (room_id) REFERENCES rooms(id)
);
```

---

### 3. Deploy the Application

- Place this repository's folder into `apache/webapps`.

---

### 4. Run the Application

- Open a terminal and navigate to `apache/bin`.
- Run:
  ```
  catalina.bat run
  ```

---
