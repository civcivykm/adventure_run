@echo off
REM Adventure Run - Install Script (Windows)
REM Checks for node_modules and installs if missing

echo Checking dependencies...

set NEEDS_INSTALL=0

REM Check backend
if not exist "backend\node_modules" (
  echo   Backend dependencies missing.
  set NEEDS_INSTALL=1
) else (
  echo   Backend dependencies OK.
)

REM Check frontend
if not exist "frontend\node_modules" (
  echo   Frontend dependencies missing.
  set NEEDS_INSTALL=1
) else (
  echo   Frontend dependencies OK.
)

if %NEEDS_INSTALL%==1 (
  echo.
  echo Installing dependencies...

  if not exist "backend\node_modules" (
    echo   Installing backend dependencies...
    cd backend
    call npm install
    cd ..
  )

  if not exist "frontend\node_modules" (
    echo   Installing frontend dependencies...
    cd frontend
    call npm install
    cd ..
  )

  echo.
  echo Installation complete!
) else (
  echo.
  echo All dependencies are installed.
)
