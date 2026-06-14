USE event_management;

INSERT INTO users (name, email, phone, password_hash, role)
VALUES ('Admin', 'admin@ems.com', '9000000000', MD5('admin123'), 'admin');

INSERT INTO users (name, email, phone, password_hash, role)
VALUES ('Ravi Kumar', 'ravi@ems.com', '9111111111', MD5('org123'), 'organiser');

INSERT INTO organiser_details (user_id, organisation_name, address, id_proof)
VALUES (2, 'Ravi Events Pvt Ltd', 'Chennai, Tamil Nadu', 'AADH1234X');

INSERT INTO users (name, email, phone, password_hash, role)
VALUES ('Priya S', 'priya@ems.com', '9222222222', MD5('part123'), 'participant');

INSERT INTO participant_details (user_id, age, address)
VALUES (3, 24, 'T Nagar, Chennai');

INSERT INTO events (organiser_id, title, description, venue, event_date, event_time,
                    total_seats, available_seats, ticket_price)
VALUES (2, 'Tech Summit 2026', 'Annual technology conference',
        'Chennai Trade Centre', '2026-06-15', '10:00:00', 200, 200, 499.00);

INSERT INTO events (organiser_id, title, description, venue, event_date, event_time,
                    total_seats, available_seats, ticket_price)
VALUES (2, 'Music Night', 'Live classical music performance',
        'Music Academy, Chennai', '2026-07-20', '18:30:00', 100, 100, 299.00);