@echo off
echo ========================================================
echo Launching LeaveFlow Application (Backend + Frontend)
echo ========================================================
echo Starting Backend in separate window...
start "LeaveFlow Backend (Spring Boot :8080)" cmd /k "cd /d ""%~dp0backend"" && .\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=h2"

echo Waiting 5 seconds for backend initialization...
timeout /t 5 >nul

echo Starting Frontend in separate window...
start "LeaveFlow Frontend (React :5173)" cmd /k "cd /d ""%~dp0frontend"" && npm run dev"

echo ========================================================
echo LeaveFlow is running!
echo Frontend: http://localhost:5173
echo Backend:  http://localhost:8080/api
echo ========================================================
pause

