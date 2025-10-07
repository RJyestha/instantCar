# instantCar
# 🚗 Car Rental System — ASP.NET Web Forms (VB.NET + SQL Server)

A complete **Car Rental Management System** built using **ASP.NET Web Forms (VB.NET)** and **SQL Server**.  
This project allows users to browse, book, and manage vehicle rentals, while providing administrators full control over vehicles, bookings, and users through an interactive dashboard.

---

## 🧩 Features

### 👤 User Side
- **User Registration & Login** with session management  
- **Vehicle Search & Filtering** by category, make, or model  
- **Booking System** with live vehicle availability  
- **My Bookings Page** to view, filter, or cancel bookings  
- **User Profile Management** (view/update personal info)  

### 🛠️ Admin Side
- **Admin Dashboard** showing statistics & quick actions  
- **Manage Vehicles, Makes & Models** (Add / Edit / Delete)  
- **View and Manage Bookings**  
- **View Registered Users**  
- **System Overview with recent activities and pending tasks**

---

## 🗂️ Project Structure

| Folder/File | Description |
|--------------|-------------|
| `/Admin` | Admin dashboard and management pages |
| `/User` | User-facing pages (search, bookings, profile) |
| `/App_Data` | Contains SQL database or connection settings |
| `Web.config` | Application configuration file (DB connection, settings) |
| `Master Pages` | Common layout for Admin and User interfaces |
| `*.aspx / *.vb` | ASP.NET Web Forms and their backend logic |

---

## 🧠 Technologies Used

| Category | Technology |
|-----------|-------------|
| Frontend | HTML5, CSS3, ASP.NET Server Controls |
| Backend | ASP.NET Web Forms (VB.NET) |
| Database | SQL Server |
| IDE | Visual Studio |
| Validation | ASP.NET Validation Controls (no JavaScript used) |

---

## ⚙️ How to Run the Project

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/CarRentalSystem.git

Open in Visual Studio

Go to File > Open > Project/Solution

Open the .sln file

Configure Database

Open SQL Server Management Studio (SSMS)

Execute the SQL script in /App_Data to create the database

Update your connection string in Web.config

<connectionStrings>
    <add name="ConnStr" connectionString="Data Source=YOUR_SERVER;Initial Catalog=CarRentalDB;Integrated Security=True" providerName="System.Data.SqlClient"/>
</connectionStrings>

Run the Project

Press F5 or click Start Debugging

Access the site via:
User: http://localhost:xxxx/
Admin: http://localhost:xxxx/AdminDashboard.aspx

🔐 Default Login Credentials (for testing)
Role	Username	Password
Admin	admin26	    Admin123$
User	jess01	    Rteesha26$

(You can modify these in the database.)