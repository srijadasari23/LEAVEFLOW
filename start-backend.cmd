@echo off
echo ========================================================
echo Starting LeaveFlow Java Backend (Spring Boot 3.3.4)...
echo ========================================================
cd /d "%~dp0backend"
call .\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=h2
pause

