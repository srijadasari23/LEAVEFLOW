# LeaveFlow – Smart Leave Request Management System

> **"Simple. Smart. Seamless Leave Management."**
> Complete Java Full-Stack Hackathon Project built strictly with Java 21, Spring Boot 3.x, React, and MySQL 8.

---

## 1. Problem Statement & Overview

> *"An organization wants employees to request leave and administrators to approve or reject requests."*

**LeaveFlow** is a professional, high-reliability leave management platform designed for three organization categories:
1. **School** (e.g., *Green Valley Public School*)
2. **College** (e.g., *RCE College of Engineering*)
3. **Office / Company** (e.g., *TechNova Solutions*)

All three organization categories operate on the **same Java backend and common leave management logic** while maintaining **strict organization-level data isolation**.

---

## 2. Technology Stack

- **Backend**:
  - **Java 21 LTS**
  - **Spring Boot 3.3.4** (Spring Web, Spring Data JPA, Spring Security, Spring Validation)
  - **Hibernate 6**
  - **JJWT 0.12.5** (Stateless Bearer JWT Authentication)
  - **Maven 3.x** (with bundled Maven Wrapper `mvnw.cmd`)
- **Frontend**:
  - **React 18** (Vite build system)
  - **JavaScript (ES6+)**, **HTML5**, **CSS3**
  - **Axios** (with automatic JWT interceptors)
  - **React Router DOM 6**
  - **Lucide React** icons
- **Database**:
  - **MySQL 8.x** (DDL in `database/schema.sql` and `database/demo-data.sql`)
  - In-memory H2 profile available for instant zero-config testing (`application-h2.properties`)
- **Testing**:
  - **JUnit 5**, **Mockito**, **Spring Boot Test**, **MockMvc** (25 automated test cases, 100% pass)

---

## 3. Core Feature: Java-Based Overlap Detection

The cornerstone of the system is the **mathematical overlap check** executed in Java at the time of administrative decision:

$$\text{existing.startDate} \le \text{requested.endDate} \quad \text{AND} \quad \text{existing.endDate} \ge \text{requested.startDate}$$

Additional criteria verified:
- Belonging to the **same employee**
- Belonging to the **same organization**
- Existing status is strictly **`APPROVED`**

### Live Demonstration Test Scenarios
| Scenario | Existing Leave | Requested Leave | Status | Backend Result |
|---|---|---|---|---|
| **Scenario 1 (EMP001)** | Nov 10 – Nov 15 | Nov 12 – Nov 18 | `PENDING` | **BLOCK APPROVAL (HTTP 409)** |
| **Scenario 2 (EMP001)** | Nov 10 – Nov 15 | Nov 16 – Nov 20 | `PENDING` | **ALLOW APPROVAL (200 OK)** |
| **Scenario 3 (EMP001)** | Nov 10 – Nov 15 | Nov 05 – Nov 09 | `PENDING` | **ALLOW APPROVAL (200 OK)** |
| **Scenario 4 (EMP001)** | Nov 10 – Nov 15 | Nov 15 – Nov 18 | `PENDING` | **BLOCK APPROVAL (Boundary day overlap)** |
| **Scenario 5** | EMP001: Nov 10–15 | EMP002: Nov 10–15 | `PENDING` | **ALLOW APPROVAL (Different employee)** |
| **Scenario 6** | REJECTED: Nov 10–15 | New: Nov 12–18 | `PENDING` | **ALLOW APPROVAL (Not approved)** |
| **Scenario 7** | PENDING: Nov 10–15 | New: Nov 12–18 | `PENDING` | **ALLOW APPROVAL (Not approved)** |

When an overlap is detected:
- The approval is blocked.
- The request status **remains `PENDING`**.
- The backend throws `LeaveOverlapException` returning **HTTP 409 Conflict**.
- The frontend displays the required warning:
  > **"Approval blocked! This employee already has an approved leave during the selected dates."**

---

## 4. Demonstration Credentials

All demo accounts are pre-seeded automatically on first startup via `DataInitializer`:

| Role | Organization Category | Organization Name | Email | Password |
|---|---|---|---|---|
| **Admin** | Company | TechNova Solutions | `admin.company@leaveflow.com` | `Admin@123` |
| **Admin** | School | Green Valley Public School | `admin.school@leaveflow.com` | `Admin@123` |
| **Admin** | College | RCE College of Engineering | `admin.college@leaveflow.com` | `Admin@123` |
| **Employee** | Company (EMP001) | TechNova Solutions | `alex.mercer@leaveflow.com` | `User@123` |
| **Employee** | Company (EMP002) | TechNova Solutions | `emily.chen@leaveflow.com` | `User@123` |
| **Employee** | School (SCH001) | Green Valley Public School | `robert.taylor@leaveflow.com` | `User@123` |
| **Employee** | College (COL001) | RCE College of Engineering | `priya.sharma@leaveflow.com` | `User@123` |

> 💡 **Quick Login Buttons**: The login page provides 1-click credentials filler buttons for evaluators and judges!

---

## 5. VS Code Execution Guide (Windows)

### Prerequisites
1. **Java 21 LTS** installed and added to `PATH` (or `JAVA_HOME`).
2. **Node.js LTS** (v18+) and `npm` installed.
3. **MySQL 8.x** (or use zero-config H2 profile).

---

### Step 1: Database Setup (MySQL 8)
1. Open MySQL command line or MySQL Workbench:
   ```sql
   CREATE DATABASE IF NOT EXISTS leaveflow_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
2. By default, `backend/src/main/resources/application.properties` connects to:
   - Host: `localhost:3306`
   - Database: `leaveflow_db`
   - Username: `root` (configurable via `SPRING_DATASOURCE_USERNAME`)
   - Password: `root` (configurable via `SPRING_DATASOURCE_PASSWORD`)

*(Optional) If you don't have MySQL running locally, activate the standalone in-memory mode by adding `--spring.profiles.active=h2`.*

---

### Step 2: Start the Java Backend
Open a terminal in VS Code:
```powershell
cd backend
.\mvnw.cmd spring-boot:run
```
*(Or specify H2 profile if MySQL is not started):*
```powershell
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=h2
```
Backend will start on: **`http://localhost:8080`**

---

### Step 3: Start the React Frontend
Open a second terminal in VS Code:
```powershell
cd frontend
npm install
npm run dev
```
Frontend will start on: **`http://localhost:5173`**

---

### Step 4: Run the Automated Test Suite
In the `backend` terminal:
```powershell
cd backend
.\mvnw.cmd test
```
Runs all 25 unit, overlap, employee management, and REST API integration tests.

---

## 6. Project Folder Structure

```
LEAVEFLOW/
│
├── backend/
│   ├── pom.xml                                 # Maven dependencies (Java 21, Spring Boot 3.3.4)
│   ├── mvnw / mvnw.cmd                         # Maven Wrappers for zero-install builds
│   ├── .mvn/wrapper/                           # Maven wrapper binaries
│   ├── src/main/java/com/leaveflow/
│   │   ├── LeaveFlowApplication.java           # Spring Boot application entrypoint
│   │   ├── config/                             # SecurityConfig, DataInitializer, CORS
│   │   ├── controller/                         # Auth, Org, Employee, Leave, Admin, Dashboard
│   │   ├── dto/                                # Requests, Responses, Filter DTOs
│   │   ├── entity/                             # Organization, User, Employee, LeaveRequest, ActivityLog
│   │   ├── enums/                              # OrganizationType, Role, LeaveStatus, EmploymentStatus
│   │   ├── exception/                          # LeaveOverlapException, GlobalExceptionHandler
│   │   ├── repository/                         # JPA Repositories with custom queries & locks
│   │   ├── security/                           # JWT Provider, Filter, UserPrincipal, UserDetails
│   │   └── service/ (and impl/)                # Auth, Org, Employee, LeaveRequest, Approval, Dashboard
│   ├── src/main/resources/
│   │   ├── application.properties              # MySQL 8 datasource configuration
│   │   └── application-h2.properties           # Standalone in-memory fallback profile
│   └── src/test/java/com/leaveflow/
│       ├── LeaveOverlapServiceTest.java        # 10 Overlap tests (all 7 problem statement examples)
│       ├── EmployeeServiceTest.java            # Employee creation, duplicate email, deactivate
│       ├── LeaveRequestSubmissionTest.java     # Date validation, days calculation, active status
│       └── LeaveFlowApiIntegrationTest.java    # Full Spring Boot MockMvc integration suite
│
├── frontend/
│   ├── package.json                            # React 18, Vite, Axios, Lucide React, React Router
│   ├── vite.config.js                          # Vite configuration with /api backend proxy
│   ├── index.html                              # Clean HTML5 template with Inter typography
│   └── src/
│       ├── App.jsx                             # Route definitions & guards
│       ├── main.jsx                            # React root & providers
│       ├── index.css                           # Professional SaaS styling & design system
│       ├── context/AuthContext.jsx             # Authentication & organization state
│       ├── services/api.js                     # Axios client with JWT interceptor
│       ├── components/                         # Navbar, Sidebar, StatusBadge, OverlapAlertBanner, Modal
│       ├── layouts/                            # AdminLayout, EmployeeLayout
│       └── pages/                              # LandingPage, LoginPage, AdminDashboard, AdminEmployees,
│                                               # AdminLeaveRequests (Filters), AdminApprovals, EmployeeDashboard
│
├── database/
│   ├── schema.sql                              # MySQL 8 table DDL, indexes, constraints
│   └── demo-data.sql                           # Demonstration dataset for School, College, Company
│
├── docs/
│   ├── API_DOCUMENTATION.md                    # REST API endpoints catalog & samples
│   ├── DATABASE_DOCUMENTATION.md               # ER diagram, schema details & data dictionary
│   └── TESTING.md                              # Automated test specifications & results
│
├── .gitignore
└── README.md
```

---

## 7. Hackathon Evaluation Checklist

- [x] **Strict Tech Stack**: Java 21, Spring Boot 3.x, React, MySQL 8, Maven. No Python, Flask, Django, or Node backends.
- [x] **Multi-Organization**: School (*Green Valley*), College (*RCE College*), Company (*TechNova*) supported under one application.
- [x] **Strict Data Isolation**: Organizations only access their own records.
- [x] **Role-Based Authentication**: Secure Spring Security + BCrypt password hashing + JWT tokens.
- [x] **Employee Management**: Add, View, Edit, Search, Deactivate, and delete-protection if leave history exists.
- [x] **Leave Submission**: Auto-calculated days, date validation, no past dates, non-empty reason.
- [x] **Admin Approvals & Rejections**: Approve or reject with mandatory remarks.
- [x] **Core Overlap Detection in Java**: `existing.startDate <= requested.endDate AND existing.endDate >= requested.startDate` with employee-level synchronization and HTTP 409 error handling.
- [x] **Multi-Criteria Backend Filtering**: Employee Code, Employee Name, Department, Status, Date Ranges.
- [x] **Real Database Updates**: Dashboard counts and tables update dynamically from database queries.
- [x] **100% Automated Test Pass**: 25 JUnit 5 and Mockito tests passing.
- [x] **VS Code Ready**: Includes Maven Wrapper, Vite config, package.json, and Windows setup scripts.

