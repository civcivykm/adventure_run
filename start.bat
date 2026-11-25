@echo off
REM Adventure Run - Start Script (Windows)
REM Checks dependencies, installs if needed, then starts backend and frontend

echo Starting Adventure Run...
echo.

REM Check and install dependencies if needed
if exist "install.bat" (
  call install.bat
  echo.
)

REM Start backend (port 3000)
echo Starting backend...
start "Adventure Run - Backend" cmd /k "cd backend && npm run dev"

REM Small delay
timeout /t 2 /nobreak >nul

REM Start frontend (port 5173)
echo Starting frontend...
start "Adventure Run - Frontend" cmd /k "cd frontend && npm run dev"

echo.
echo Adventure Run is running!
echo   Frontend: http://localhost:5173
echo   Backend:  http://localhost:3000
echo.
echo Close both terminal windows to stop the servers.
pause
