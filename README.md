\# 🎪 Plan My Event



A full-stack Event Management System built with Java Servlets, JSP, and MySQL. Supports event booking, scheduling, payments, and refund management with three user roles.



\## Features



\- \*\*Role-based access\*\*: Admin, Organiser, Participant

\- \*\*Event management\*\*: Create, view, cancel, delete events

\- \*\*Booking system\*\*: Browse and book events with real-time seat tracking

\- \*\*Payment portal\*\*: Card payment and QR code generation

\- \*\*Refund policy\*\*:

&#x20; - Organiser cancels event → 100% refund within 3 days

&#x20; - Participant cancels:

&#x20;   - 7+ days before → 100% refund

&#x20;   - 3-6 days before → 75% refund

&#x20;   - 1-2 days before → 50% refund

&#x20;   - Same day → No refund

\- \*\*Search functionality\*\*: Search across all admin panels and event listings

\- \*\*AM/PM time display\*\* for all events



\## Tech Stack



\- \*\*Backend\*\*: Java Servlets, JSP

\- \*\*Database\*\*: MySQL 8.0

\- \*\*Server\*\*: Apache Tomcat 10.1.53

\- \*\*Build Tool\*\*: Maven

\- \*\*Libraries\*\*: ZXing (QR codes), JDBC



\## Setup Instructions



1\. Clone the repository

2\. Create MySQL database using `sql/schema.sql`

3\. Insert test data using `sql/seed.sql`

4\. Update database credentials in `src/main/java/com/ems/util/DBConnection.java`

5\. Build the project: `mvn clean package`

6\. Deploy `target/PlanMyEvent.war` to Apache Tomcat `webapps/` folder

7\. Access at `http://localhost:8080/PlanMyEvent/pages/login.jsp`



\## Test Credentials



| Role | Email | Password |

|---|---|---|

| Admin | admin@ems.com | admin123 |

| Organiser | ravi@ems.com | org123 |

| Participant | priya@ems.com | part123 |



\## Database Schema



The system uses 6 tables:

\- `users` — stores all roles (admin/organiser/participant)

\- `organiser\_details` — extra info for organisers

\- `participant\_details` — extra info for participants

\- `events` — event information

\- `bookings` — booking records

\- `payments` — payment records

