#!/bin/bash

# Create directories
echo "Creating directories..."
mkdir -p "./lib/services"
mkdir -p "./lib/utils"
mkdir -p "./lib/middleware"
mkdir -p "./test/models"
mkdir -p "./test/services"
mkdir -p "./test/routes"
mkdir -p "./test/utils"
echo "Directories created successfully!"

# Create Dart Frog routes
echo "Creating Dart Frog routes..."
dart_frog new route "/index" && echo "Created route: /index"
dart_frog new route "/users/index" && echo "Created route: /users/index"
dart_frog new route "/users/[id]" && echo "Created route: /users/[id]"
dart_frog new route "/caregivers/index" && echo "Created route: /caregivers/index"
dart_frog new route "/caregivers/[id]" && echo "Created route: /caregivers/[id]"
dart_frog new route "/carehomes/index" && echo "Created route: /carehomes/index"
dart_frog new route "/carehomes/[id]/index" && echo "Created route: /carehomes/[id]/index"
dart_frog new route "/carehomes/[id]/clients/index" && echo "Created route: /carehomes/[id]/clients/index"
dart_frog new route "/carehomes/[id]/clients/[id]" && echo "Created route: /carehomes/[id]/clients/[id]"
dart_frog new route "/requests/index" && echo "Created route: /requests/index"
dart_frog new route "/requests/[id]/index" && echo "Created route: /requests/[id]/index"
dart_frog new route "/requests/[id]/assign" && echo "Created route: /requests/[id]/assign"
dart_frog new route "/shifts/index" && echo "Created route: /shifts/index"
dart_frog new route "/shifts/[id]" && echo "Created route: /shifts/[id]"
dart_frog new route "/notifications/index" && echo "Created route: /notifications/index"
dart_frog new route "/reports/index" && echo "Created route: /reports/index"
dart_frog new route "/reports/[id]" && echo "Created route: /reports/[id]"
echo "All routes created successfully!"

# Create service files
echo "Creating service files..."
touch "./lib/services/caregiver_service.dart" && echo "Created file: ./lib/services/caregiver_service.dart"
touch "./lib/services/carehome_service.dart" && echo "Created file: ./lib/services/carehome_service.dart"
touch "./lib/services/client_service.dart" && echo "Created file: ./lib/services/client_service.dart"
touch "./lib/services/request_service.dart" && echo "Created file: ./lib/services/request_service.dart"
touch "./lib/services/shift_service.dart" && echo "Created file: ./lib/services/shift_service.dart"
touch "./lib/services/notification_service.dart" && echo "Created file: ./lib/services/notification_service.dart"
touch "./lib/services/report_service.dart" && echo "Created file: ./lib/services/report_service.dart"
echo "Service files created successfully!"

# Create utility files
echo "Creating utility files..."
touch "./lib/utils/firestore_helper.dart" && echo "Created file: ./lib/utils/firestore_helper.dart"
touch "./lib/utils/auth_helper.dart" && echo "Created file: ./lib/utils/auth_helper.dart"
touch "./lib/utils/notification_helper.dart" && echo "Created file: ./lib/utils/notification_helper.dart"
echo "Utility files created successfully!"

# Create middleware file
echo "Creating middleware file..."
touch "./lib/middleware/auth_middleware.dart" && echo "Created file: ./lib/middleware/auth_middleware.dart"
echo "Middleware file created successfully!"

# Create main.dart file
echo "Creating main.dart file..."
touch "./lib/main.dart" && echo "Created file: ./lib/main.dart"
echo "main.dart file created successfully!"

# Create test files
echo "Creating test files..."
touch "./test/models/example_test.dart" && echo "Created file: ./test/models/example_test.dart"
touch "./test/services/example_test.dart" && echo "Created file: ./test/services/example_test.dart"
touch "./test/routes/example_test.dart" && echo "Created file: ./test/routes/example_test.dart"
touch "./test/utils/example_test.dart" && echo "Created file: ./test/utils/example_test.dart"
echo "Test files created successfully!"

echo "Project structure created successfully!"
