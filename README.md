# **RevRentals**

**Course**: CPSC 471 - Database Management Systems


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

## **Tech Stack**
The application is powered by a backend built with Django REST Framework and a MySQL database, and the front end is developed using Flutter
### Frontend

- Framework: Flutter
- Libraries:
  - `http` for API requesets
  - `provider` for state management
  - Custom UI components

### Backend
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
