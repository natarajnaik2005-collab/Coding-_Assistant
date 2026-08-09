# 📝 Online Coding Assessment Platform

A full-stack web application for conducting and managing online technical coding tests.

##  Features

### User Authentication
- ✅ Secure login/registration with BCrypt password hashing
- ✅ Role-based access control (Admin/Candidate)
- ✅ Session management with timeout

### Admin Features
- ✅ Create and manage coding tests
- ✅ Add questions with test cases (Input/Output)
- ✅ View all candidate submissions
- ✅ Export results to CSV

### Candidate Features
- ✅ View available tests
- ✅ Take tests with countdown timer
- ✅ Auto-submit when time expires
- ✅ Run code before submission
- ✅ View results with score breakdown

### Technical Features
- ✅ Real Java code execution & validation
- ✅ Output comparison for scoring
- ✅ Dark modern UI theme
- ✅ Responsive design

## 🛠️ Technologies Used

| Category | Technology |
|----------|------------|
| **Backend** | Java, Servlets, JSP |
| **Database** | MySQL 8.0 |
| **Server** | Apache Tomcat 9.0 |
| **Security** | BCrypt Password Hashing |
| **Frontend** | HTML5, CSS3, JavaScript |
| **Build Tool** | Maven (Optional) |
| **IDE** | Eclipse / IntelliJ IDEA |

## 📋 Prerequisites

- Java JDK 8 or higher
- Apache Tomcat 9.0+
- MySQL 8.0+
- Maven 3.6+ (optional)

## 🔧 Installation

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/coding-assessment-platform.git
cd coding-assessment-platform
```
### 2. Database Setup
```bash
CREATE DATABASE coding_platform;
USE coding_platform;

-- Run the SQL script from /database/schema.sql
```

### 3. Configure Database Connection
```bash
Edit src/main/java/com/platform/util/DBConnection.java;

private static final String URL = "jdbc:mysql://localhost:3306/coding_platform";
private static final String USER = "root";
private static final String PASS = "your_password";
```
### 4. Build and Deploy
```bash 
# If using Maven
mvn clean package

# Copy WAR file to Tomcat webapps
copy target/coding-assessment.war C:\apache-tomcat-9.0\webapps\

# Start Tomcat
C:\apache-tomcat-9.0\bin\startup.bat
```

### 5. Access Application
```bash
http://localhost:8080/coding-assessment/login
```

## 📊 Database Schema

### Entity Relationship Diagram
```
users
├── user_id (PK)
├── username
├── password (BCrypt hashed)
└── role (ADMIN/CANDIDATE)

tests
├── test_id (PK)
├── title
├── duration_minutes
└── created_by (FK)

questions
├── question_id (PK)
├── test_id (FK)
├── question_text
├── expected_output
├── points
└── test_case_1/2/3 (input/output)

results
├── result_id (PK)
├── user_id (FK)
├── test_id (FK)
├── score
└── submission_time
