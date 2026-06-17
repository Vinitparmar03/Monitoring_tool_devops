# Linux Monitoring & Security Dashboard

A Full Stack Linux Monitoring & Security Dashboard designed to monitor Linux server resources, user activities, security events, and SSH attacks in real-time.

The monitoring service collects system information from the Linux host, generates monitoring reports in JSON format, and sends the data to a web dashboard where administrators can visualize system health and security-related events.

---

## Features

### System Monitoring

* CPU Usage Monitoring
* RAM Usage Monitoring
* System Load Monitoring
* Real-Time Resource Tracking
* JSON-Based Monitoring Reports

### User & Group Monitoring

* Detect Newly Added Users
* Detect Deleted Users
* Detect Newly Created Groups
* Detect Deleted Groups

### Security Monitoring

* Detect Unauthorized Listening Ports
* Monitor Open Ports
* Generate Security Alerts

### SSH Attack Detection

* Monitor Failed SSH Login Attempts
* Detect SSH Brute Force Attacks
* Identify Suspicious IP Addresses
* Generate Email Alerts

### Email Alert System

* Automatic Security Notifications
* SSH Attack Alerts
* Unauthorized Port Detection Alerts
* User and Group Change Notifications

### Dashboard

* Real-Time Monitoring Dashboard
* Resource Usage Visualization
* Security Event Tracking
* JSON Data Representation

---

## Project Architecture

```text
Linux Server
      │
      ▼
monitoring.sh
      │
      ▼
output.json
      │
      ▼
node-api.js
      │
      ▼
Backend API
      │
      ▼
Frontend Dashboard
```

---

## Project Structure

```text
project-root/
│
├── web/
│   │
│   ├── frontend/
│   │   ├── .env.example
│   │   └── ...
│   │
│   └── backend/
│       ├── .env.example
│       └── ...
│
├── monitoring/
│   │
│   ├── monitoring.sh
│   ├── node-api.js
│   ├── output.json
│   └── ...
│
├── .env.example
├── docker-compose.yml
└── README.md
```

---

## Why Is Monitoring Separate?

The monitoring service runs directly on the Linux server because it requires access to actual host-level information such as:

* CPU Usage
* RAM Usage
* System Load
* Users
* Groups
* SSH Logs
* Open Ports

Running the monitoring script inside a Docker container may only provide container-level information rather than actual host-level system information.

Therefore:

* Frontend and Backend run inside Docker containers.
* Monitoring Service runs directly on the Linux Server.

---

## Benefits

### Real-Time Monitoring

Monitor CPU, RAM, and system load continuously.

### Security Enhancement

Detect suspicious SSH activities and unauthorized listening ports.

### User Activity Tracking

Monitor newly added users and groups.

### Automated Alerts

Receive email notifications whenever suspicious activities are detected.

### Centralized Dashboard

View all monitoring information from a single web interface.

---

## Prerequisites

Before running this project, ensure the following are installed:

* Docker
* Docker Compose
* Node.js
* Linux Server
* Gmail Account (for Email Alerts)

---

## Environment Configuration

Rename all `.env.example` files to `.env`.

### Root

```bash
mv .env.example .env
```

### Frontend

```bash
mv web/frontend/.env.example web/frontend/.env
```

### Backend

```bash
mv web/backend/.env.example web/backend/.env
```

---

## Gmail Alert Configuration

This project uses Gmail SMTP to send alert notifications.

### Step 1: Enable Two-Factor Authentication

Open:

https://myaccount.google.com/security

Enable:

* 2-Step Verification

### Step 2: Generate an App Password

After enabling 2FA:

1. Open Google Account
2. Navigate to Security
3. Select App Passwords
4. Generate a new password

Example:

```env
EMAIL_USER=yourgmail@gmail.com
EMAIL_PASS=your_generated_app_password
```

> Do not use your Gmail account password. Always use the generated App Password.

---

## Backend Environment Variables and Root Environment Variables

Example:

```env
PORT=5000

EMAIL_USER=yourgmail@gmail.com
EMAIL_PASS=your_generated_app_password
ALERT_EMAIL=sender@gmail.com

SUDO_PASSWORD=adminpassword

MONITOR_PATH=/app/monitoring
```

---

## Frontend Environment Variables

Example:

```env
VITE_BACKEND=http://localhost:5000
```

---

## Running the Web Application

After configuring all `.env` files:

```bash
docker-compose up --build -d
```

This command will:

* Build Frontend Container
* Build Backend Container
* Create Containers
* Start Services

---

## Stopping Containers

```bash
docker-compose down
```

---

## Running the Monitoring Service

Navigate to the monitoring directory:

```bash
cd monitoring
```

Make the monitoring script executable:

```bash
chmod +x monitoring.sh
```

Start the monitoring script:

```bash
./monitoring.sh
```

Open a new terminal and start the Monitoring API:

```bash
node node-api.js
```

Both services must remain running for monitoring data to be collected and served to the backend.

---

## Data Flow

```text
Linux Server
     │
     ▼
monitoring.sh
     │
     ▼
output.json
     │
     ▼
node-api.js
     │
     ▼
Backend API
     │
     ▼
Frontend Dashboard
```

---

## Technologies Used

### Frontend

* React.js
* Vite
* Axios

### Backend

* Node.js
* Express.js

### Monitoring

* Bash Scripting
* Journalctl
* Linux System Utilities
* Cron Jobs

### Deployment

* Docker
* Docker Compose

---

## Demo Video

Add your LinkedIn project basic overview:

```text
https://www.linkedin.com/posts/vinit-kumar-parmar-22522a215_linux-devops-docker-ugcPost-7473091441485955072-7nHO/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADZRDr0B3jGUgimvN4mtmvOEEJqmA9dQEvQ
```

---

## Contact

### Vinit Parmar

**Email**

[vinitparmar03@gmail.com](mailto:vinitparmar03@gmail.com)

**LinkedIn**

https://www.linkedin.com/in/vinit-kumar-parmar-22522a215/

**GitHub**

https://github.com/Vinitparmar03

---

## License

This project is licensed under the MIT License.

---

## Support

If you found this project useful, consider giving it a ⭐ on GitHub.
