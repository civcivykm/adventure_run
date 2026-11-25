#!/bin/bash

# Adventure Run - Install Script
# Checks for node_modules and installs if missing

echo "Checking dependencies..."

NEEDS_INSTALL=false

# Check backend
if [ ! -d "backend/node_modules" ]; then
  echo "  Backend dependencies missing."
  NEEDS_INSTALL=true
else
  echo "  Backend dependencies OK."
fi

# Check frontend
if [ ! -d "frontend/node_modules" ]; then
  echo "  Frontend dependencies missing."
  NEEDS_INSTALL=true
else
  echo "  Frontend dependencies OK."
fi

if [ "$NEEDS_INSTALL" = true ]; then
  echo ""
  echo "Installing dependencies..."
  
  if [ ! -d "backend/node_modules" ]; then
    echo "  Installing backend dependencies..."
    (cd backend && npm install)
  fi
  
  if [ ! -d "frontend/node_modules" ]; then
    echo "  Installing frontend dependencies..."
    (cd frontend && npm install)
  fi
  
  echo ""
  echo "Installation complete!"
else
  echo ""
  echo "All dependencies are installed."
fi
