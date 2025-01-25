#!/bin/bash

# Script to delete all existing routes and create new routes for the Care 360 backend project
# Run this script from the root of your Dart project directory

# Enable verbose mode
set -x

# Function to delete a directory (route) if it exists
delete_route() {
  local route_path=$1
  if [ -d "$route_path" ]; then
    rm -rf "$route_path" && echo "Deleted route: $route_path"
  else
    echo "Route does not exist: $route_path"
  fi
}

# Function to create a new route and print a success message
create_route() {
  local route_path=$1
  dart_frog new route "$route_path" && echo "Created route: $route_path"
}

# Delete all existing routes
echo "Deleting all existing routes..."
delete_route "routes/caregivers"
delete_route "routes/carehomes"
delete_route "routes/clients"
delete_route "routes/requests"
delete_route "routes/shifts"
delete_route "routes/notifications"
delete_route "routes/reports"
delete_route "routes/users"

# Create new routes for users
create_route "/users/index"
create_route "/users/[id]"

# Create new routes for caregivers
create_route "/caregivers/index"
create_route "/caregivers/[id]"       # Dynamic route after static routes

# Create new routes for carehomes
create_route "/carehomes/index"
create_route "/carehomes/[id]"

# Create new routes for clients (domiciliary care)
create_route "/clients/index"
create_route "/clients/[id]"

# Create new routes for requests
create_route "/requests/index"
create_route "/requests/[id]"
create_route "/requests/[id]/match"

# Create new routes for shifts
create_route "/shifts/index"
create_route "/shifts/[id]"       # Dynamic route after static routes
create_route "/shifts/[id]/clockin"
create_route "/shifts/[id]/clockout"

# Create new routes for notifications
create_route "/notifications/index"
create_route "/notifications/[id]/read"

# Create new routes for reports
create_route "/reports/index"
create_route "/reports/[id]"

# Print completion message
echo "All routes created successfully!"