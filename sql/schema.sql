CREATE DATABASE IF NOT EXISTS event_management;
USE event_management;

CREATE TABLE users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    phone         VARCHAR(15)  NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role          ENUM('admin','organiser','participant') NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE organiser_details (
    organiser_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id           INT NOT NULL,
    organisation_name VARCHAR(200),
    address           TEXT,
    id_proof          VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE participant_details (
    participant_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT NOT NULL,
    age            INT,
    address        TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE events (
    event_id        INT AUTO_INCREMENT PRIMARY KEY,
    organiser_id    INT NOT NULL,
    title           VARCHAR(200) NOT NULL,
    description     TEXT,
    venue           VARCHAR(300),
    event_date      DATE NOT NULL,
    event_time      TIME,
    total_seats     INT DEFAULT 0,
    available_seats INT DEFAULT 0,
    ticket_price    DECIMAL(10,2) DEFAULT 0.00,
    status          ENUM('upcoming','ongoing','completed','cancelled') DEFAULT 'upcoming',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organiser_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE bookings (
    booking_id     INT AUTO_INCREMENT PRIMARY KEY,
    event_id       INT NOT NULL,
    participant_id INT NOT NULL,
    booking_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    seats_booked   INT DEFAULT 1,
    total_amount   DECIMAL(10,2),
    booking_status ENUM('confirmed','cancelled','refund_pending','refunded') DEFAULT 'confirmed',
    FOREIGN KEY (event_id)       REFERENCES events(event_id)  ON DELETE CASCADE,
    FOREIGN KEY (participant_id) REFERENCES users(user_id)    ON DELETE CASCADE
);

CREATE TABLE payments (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    booking_id     INT NOT NULL,
    amount         DECIMAL(10,2) NOT NULL,
    payment_method ENUM('card','qr') NOT NULL,
    card_last4     VARCHAR(4),
    transaction_id VARCHAR(100) UNIQUE,
    payment_status ENUM('success','failed','refunded') DEFAULT 'success',
    payment_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
);