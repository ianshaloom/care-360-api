# Care360 API

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)


[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

The backend for the **Care360** platform, built using **Dart Frog**. This backend provides APIs for managing caregivers, care homes, clients, requests, shifts, notifications, and reports.

---

## **Project Structure**

```
care-360-api/
├── lib/
│   ├── models/                  # Data model classes
│   │   ├── user.dart
│   │   ├── caregiver.dart
│   │   ├── carehome.dart
│   │   ├── client.dart
│   │   ├── request.dart
│   │   ├── shift.dart
│   │   ├── notification.dart
│   │   └── report.dart
│   ├── services/                # Business logic and service layers
│   │   ├── caregiver_service.dart
│   │   ├── carehome_service.dart
│   │   ├── client_service.dart
│   │   ├── request_service.dart
│   │   ├── shift_service.dart
│   │   ├── notification_service.dart
│   │   └── report_service.dart
│   ├── utils/                   # Utility functions and helpers
│   │   ├── firestore_helper.dart
│   │   ├── auth_helper.dart      # For verifying Firebase ID tokens
│   │   └── notification_helper.dart
│   ├── middleware/              # Custom middleware
│   │   └── auth_middleware.dart  # For protecting routes
│   └── main.dart                # Entry point for the backend
├── routes/                      # Dart Frog route handlers
│   ├── users/
│   │   ├── [uid].dart
│   │   └── index.dart
│   ├── caregivers/
│   │   ├── [caregiverId].dart
│   │   └── index.dart
│   ├── carehomes/
│   │   ├── [careHomeId]/
│   │   │   ├── clients/
│   │   │   │   ├── [clientId].dart
│   │   │   │   └── index.dart
│   │   │   └── index.dart
│   │   └── index.dart
│   ├── requests/
│   │   ├── [requestId]/
│   │   │   ├── assign.dart
│   │   │   └── index.dart
│   │   └── index.dart
│   ├── shifts/
│   │   ├── [shiftId].dart
│   │   └── index.dart
│   ├── notifications/
│   │   └── index.dart
│   ├── reports/
│   │   ├── [reportId].dart
│   │   └── index.dart
│   └── index.dart               # Root route handler
├── test/                        # Unit and integration tests
│   ├── models/
│   ├── services/
│   ├── routes/
│   └── utils/
├── .env                         # Environment variables
├── pubspec.yaml                 # Dart dependencies
└── README.md                    # Project documentation
```

---

## **Getting Started**

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/care-360-api.git
   cd care-360-api

2. **Install Dependencies**:
   ```bash
   dart pub get
   ```

3. **Run the Backend**:
   ```bash
   dart_frog dev
   ```

4. **Run Tests**:
   ```bash
   dart test
   ```



## **API Endpoints**

### **Users**
- `GET /users/{uid}`: Fetch user details by UID.
- `PUT /users/{uid}`: Update user details.
- `DELETE /users/{uid}`: Delete a user account.

### **Caregivers**
- `GET /caregivers`: Fetch all caregivers.
- `GET /caregivers/{caregiverId}`: Fetch details of a specific caregiver.
- `POST /caregivers`: Create a new caregiver profile.
- `PUT /caregivers/{caregiverId}`: Update a caregiver’s profile.
- `DELETE /caregivers/{caregiverId}`: Delete a caregiver profile.

### **Care Homes**
- `GET /carehomes`: Fetch all care homes.
- `GET /carehomes/{careHomeId}`: Fetch details of a specific care home.
- `POST /carehomes`: Create a new care home profile.
- `PUT /carehomes/{careHomeId}`: Update a care home’s profile.
- `DELETE /carehomes/{careHomeId}`: Delete a care home profile.

### **Clients**
- `GET /carehomes/{careHomeId}/clients`: Fetch all clients for a care home.
- `GET /carehomes/{careHomeId}/clients/{clientId}`: Fetch details of a specific client.
- `POST /carehomes/{careHomeId}/clients`: Create a new client profile.
- `PUT /carehomes/{careHomeId}/clients/{clientId}`: Update a client’s profile.
- `DELETE /carehomes/{careHomeId}/clients/{clientId}`: Delete a client profile.

### **Requests**
- `GET /requests`: Fetch all requests.
- `GET /requests/{requestId}`: Fetch details of a specific request.
- `POST /requests`: Create a new request.
- `PUT /requests/{requestId}/assign`: Assign a caregiver to a request.
- `DELETE /requests/{requestId}`: Delete a request.

### **Shifts**
- `GET /shifts`: Fetch all shifts.
- `GET /shifts/{shiftId}`: Fetch details of a specific shift.
- `POST /shifts`: Create a new shift.
- `PUT /shifts/{shiftId}`: Update a shift.
- `DELETE /shifts/{shiftId}`: Delete a shift.

### **Notifications**
- `GET /users/{uid}/notifications`: Fetch all notifications for a user.
- `POST /notifications`: Send a notification to a user.

### **Reports**
- `GET /reports`: Fetch all reports.
- `GET /reports/{reportId}`: Fetch details of a specific report.
- `POST /reports`: Generate a new report.

---

## **Contributing**

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

---

## **License**

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
