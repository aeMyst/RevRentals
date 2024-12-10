# **RevRentals**

**Course**: CPSC 471 - Database Management Systems
[RevRentals Backend Repository]([url](https://github.com/fion-lei/RevRentals-backend))

RevRentals is a database-driven platform showcasing the integration of a relational database with a front-end application for managing motorized vehicles, gear, and storage lot rentals. The platform supports both renters and sellers, providing seamless notifications, reservations, and transaction workflows, while also providing an admin dashboard to oversee transactions and manage lot listings.

It highlights the practical application of database concepts, including:
- Designing a relational database schema to manage user profiles, reservations, agreements, and transactions.
- Implementing SQL queries for CRUD operations and relational joins.
- Integrating a MySQL database with a Django REST Framework backend.
- Demonstrating front-end and back-end integration using a modern tech stack.
- Incorporating functionality for 3 users: renters, sellers, and administrators.
  
---
## **Group Members: Group 18**

- **Fion Lei**
- **Peter Tran**
- **Kaylee Xiao**
- **Kai Ferrer**

---
## ** Project Structure **
```
RevRentals/
├── RevRentals-backend/
├── RevRentals/                                  # Frontend files
│   ├── lib/                                     # Flutter code
│   │   ├── admin/                               # Admin-specific screens and logic
│   │   │   ├── admin_agreement.dart             # Admin agreement management
│   │   │   ├── admin_home.dart                  # Admin dashboard
│   │   │   ├── admin_login.dart                 # Admin login page
│   │   │   └── admin_lot.dart                   # Admin lot listings
│   │   ├── components/                          # Reusable widgets (buttons, text fields, etc.)
│   │   │   ├── my_button.dart                   # Custom button component
│   │   │   ├── my_textfield.dart                # Custom text field component
│   │   │   └── signup_button.dart               # Signup-specific button
│   │   ├── images/                              # App images and assets
│   │   │   ├── gear/                            # Images of gear
│   │   │   │   └── agv_pista.webp               # Helmet image
│   │   │   ├── lots/                            # Storage lot images
│   │   │   │   └── storage_units.png            # Storage unit image
│   │   │   ├── motorcycle/                      # Motorcycle images
│   │   │   │   └── default_motorcycle.png       # Default motorcycle image
│   │   │   └── rr_logo.png                      # App logo
│   │   ├── main_pages/                          # Main app screens (login, user home, etc.)
│   │   │   ├── login_page.dart                  # Login page
│   │   │   └── user_home.dart                   # User home page
│   │   ├── regex/                               # Input validation using regex
│   │   │   ├── listing_regex.dart               # Regex for item listings
│   │   │   └── signup_regex.dart                # Regex for signup forms
│   │   ├── services/                            # API integrations
│   │   │   ├── admin_service.dart               # Admin-related API calls
│   │   │   ├── auth_service.dart                # Authentication API calls
│   │   │   └── listing_service.dart             # Listing-related API calls
│   │   ├── user/                                # User-specific screens and logic
│   │   │   ├── garage/                          # Garage management
│   │   │   │   ├── add_listing.dart             # Add a listing to the garage
│   │   │   │   ├── garage.dart                  # Garage page
│   │   │   │   ├── maint_records.dart           # Maintenance records
│   │   │   │   └── rental_details.dart          # Rental details
│   │   │   ├── item_details/                    # Detailed views for items
│   │   │   │   ├── gear/                        # Gear details
│   │   │   │   │   ├── gear.dart                # Gear item details
│   │   │   │   │   └── gear_details.dart        # Detailed gear view
│   │   │   │   ├── lot/                         # Storage lot details
│   │   │   │   │   ├── lot.dart                 # Lot item details
│   │   │   │   │   └── lot_details.dart         # Detailed lot view
│   │   │   │   └── motorcycle/                  # Motorcycle details
│   │   │   │       ├── motorcycle.dart          # Motorcycle item details
│   │   │   │       └── motorcycle_details.dart  # Detailed motorcycle view
│   │   │   ├── marketplace/                     # Marketplace functionality
│   │   │   │   └── marketplace.dart             # Marketplace page
│   │   │   └── notifications/                   # Notification management
│   │   │       ├── agreement_transaction.dart   # Agreement transactions
│   │   │       ├── notifications.dart           # Notification list
│   │   │       └── rental_approval.dart         # Rental approval page
│   ├── macos/                                   # macOS Flutter files
│   ├── windows/                                 # Windows Flutter files
│   ├── pubspec.yaml                             # Flutter dependencies
│   └── analysis_options.yaml                    # Linting rules for Flutter
├── README.md                                    # Project documentation
└── .gitignore                                   # Git ignore rules
```

## **Features**
### **Buyer Functionality**
- Search for items available for rent (vehicles, gear, storage lots).
- Place rental requests.
- View rented items in the garage.
  
### **Seller Functionality**
- List new rental items.
- Approve or reject incoming rental requests.
- View listed items in the garage.

### **Admin Functionality**
- Oversee all transactions in the system.
- Add or manage storage lot listings.

---

## **Tech Stack**
The application is powered by a backend built with Django REST Framework and a MySQL database, and the front end is developed using Flutter
### Frontend

- Framework: Flutter
- Libraries:
  - `http` for API requesets
  - `provider` for state management
  - Custom UI components

### Backend
[RevRentals Backend Repository]([url](https://github.com/fion-lei/RevRentals-backend))
- Framework: Django with Django Rest Framework
- Database: MySQL
- APIs: RESTful endpoints for user authentication, reservations, notifications, and more.

---

## **Set Up**
### Prerequisites
**Required Tools**
To run this project, you must have the following installed:
- Android Studio or any Flutter-supported IDE.
- Frontend: Flutter and Dart SDK.
- Backend: Python 3.9+ and MySQL.
- Install required dependencies using pip and flutter pub get.

**Emulator or Physical Device**
- Ensure an emulator or physical Android device is running before starting the app.
- If using Android Studio, you can set up an emulator from the AVD Manager.
- Alternatively, you can use other tools like iOS Simulator (for macOS) or Flutter-supported emulators.

### Frontend Setup
1. Clone the repository: ```git clone https://github.com/your-repo/revrentals.git```
2. Navigate to the Flutter directory: ```cd revrentals```
3. Install dependencies: ```flutter pub get```
4. Launch the app: ```flutter run```

### Backend Setup
1. Navigate to the backend directory: ```cd revrentals-backend/revrentals```
2. Set up a virtual environment and install dependencies:
```python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```
3. Configure the database:
- Ensure MySQL is running and set up the database.
- Run migrations:
```
python manage.py makemigrations
python manage.py migrate
```
4. Start the Django development server: ```python manage.py runserver```
