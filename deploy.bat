@echo off
REM Jenkins Deployment Script for E-commerce Frontend
REM This script handles the deployment process

echo Starting E-commerce Frontend Deployment...

REM Set environment variables
set PROJECT_NAME=ecommerce-frontend
set BUILD_DIR=dist
set STAGING_DIR=C:\inetpub\wwwroot\ecommerce-staging
set PROD_DIR=C:\inetpub\wwwroot\ecommerce-prod

REM Check if build directory exists
if not exist "%BUILD_DIR%" (
    echo ERROR: Build directory not found. Please run 'npm run build' first.
    exit /b 1
)

REM Function to deploy to staging
:deploy_staging
echo Deploying to staging environment...
if exist "%STAGING_DIR%" (
    echo Removing existing staging files...
    rmdir /s /q "%STAGING_DIR%"
)
mkdir "%STAGING_DIR%"
echo Copying build files to staging...
xcopy /s /e /h /y "%BUILD_DIR%\*" "%STAGING_DIR%\"
if %errorlevel% equ 0 (
    echo Staging deployment successful!
) else (
    echo ERROR: Staging deployment failed!
    exit /b 1
)
goto :eof

REM Function to deploy to production
:deploy_production
echo Deploying to production environment...
if exist "%PROD_DIR%" (
    echo Removing existing production files...
    rmdir /s /q "%PROD_DIR%"
)
mkdir "%PROD_DIR%"
echo Copying build files to production...
xcopy /s /e /h /y "%BUILD_DIR%\*" "%PROD_DIR%\"
if %errorlevel% equ 0 (
    echo Production deployment successful!
) else (
    echo ERROR: Production deployment failed!
    exit /b 1
)
goto :eof

REM Main deployment logic
if "%1"=="staging" (
    call :deploy_staging
) else if "%1"=="production" (
    call :deploy_production
) else if "%1"=="both" (
    call :deploy_staging
    call :deploy_production
) else (
    echo Usage: deploy.bat [staging^|production^|both]
    echo   staging    - Deploy to staging environment
    echo   production - Deploy to production environment  
    echo   both       - Deploy to both environments
    exit /b 1
)

echo Deployment completed successfully!
