# 📚 Library Management System (SQL Server)

A database project for managing library operations including book lending, reviews, payments, and admin reporting.

## 🚀 Features

- Member & Book Management
- Loan & Return Transactions (with validation)
- Fine tracking and payments
- Reviews and ratings
- Admin dashboards (top books, revenue, occupancy)
- Views, Functions, Procedures, Triggers
- Data consistency using Transactions

## 🛠 Tech Stack

- SQL Server
- T-SQL (Views, Functions, Triggers, Procedures)

## 📂 Structure

- `Tables/` → Database schema
- `Views/` → Reusable query views for frontend
- `Functions/` → Logic for ratings, fines, etc.
- `Procedures/` → Loan/return/payment automation
- `Triggers/` → Real-time updates (e.g., book availability)
- `Dashboards/` → Analytical queries

## 💡 Example Use Cases

- 📄 Member profile: borrowed books, fines, reviews
- 🔍 Book search: ratings, availability, location
- 📊 Admin dashboard: occupancy, top readers, revenue

## 🧠 Developer Reflection (Optional)
-What part was hardest and why?
Handling return logic with transactions and triggers required precise conditions.

-Which concept helped you think like a backend developer?
Writing stored procedures and using transactions for data consistency gave the real feel of backend logic.

-How would you test this if it were a live web app?
By simulating borrowing/returning in a test DB, checking if triggers fire correctly, and verifying dashboard views return updated data.
