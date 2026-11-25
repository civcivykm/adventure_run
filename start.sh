#!/bin/bash

# Adventure Run - Start Script
# Checks dependencies, installs if needed, then starts backend and frontend

echo "Starting Adventure Run..."

# Check and install dependencies if needed
if [ -f "./install.sh" ]; then
  bash ./install.sh
  echo ""
fi

# Start backend (port 3000)
echo "Starting backend..."
(cd backend && npm run dev) &
BACKEND_PID=$!

# Start frontend (port 5173)
echo "Starting frontend..."
(cd frontend && npm run dev) &
FRONTEND_PID=$!

echo "Adventure Run is running!"
echo "  Frontend: http://localhost:5173"
echo "  Backend:  http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop both servers"

# Wait for interrupt
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT TERM
wait
