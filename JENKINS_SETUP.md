# Jenkins Deployment Setup Guide

This guide will help you set up Jenkins for automated deployment of your E-commerce Frontend project.

## Prerequisites

1. **Jenkins Server**: Jenkins installed and running
2. **Node.js Plugin**: Install Node.js plugin in Jenkins
3. **Git Plugin**: Install Git plugin in Jenkins (usually pre-installed)
4. **Web Server**: IIS or Apache/Nginx for hosting

## Jenkins Configuration Steps

### 1. Install Required Plugins

Go to Jenkins Dashboard → Manage Jenkins → Manage Plugins → Available

Install these plugins:
- **NodeJS Plugin**
- **Git Plugin** (if not already installed)
- **Pipeline Plugin** (if not already installed)
- **Email Extension Plugin** (for notifications)

### 2. Configure Global Tools

Go to Jenkins Dashboard → Manage Jenkins → Global Tool Configuration

**Configure Node.js:**
- Click "Add NodeJS"
- Name: `NodeJS`
- Version: Choose Node.js 18.x or later
- Check "Install automatically"

### 3. Create New Pipeline Job

1. Go to Jenkins Dashboard → New Item
2. Enter item name: `ecommerce-frontend-deployment`
3. Select "Pipeline" and click OK

### 4. Configure Pipeline Job

**General Settings:**
- Description: `E-commerce Frontend Deployment Pipeline`
- Check "GitHub project" and enter: `https://github.com/klu2300030150/ecommerce-front1`

**Build Triggers:**
- Check "GitHub hook trigger for GITScm polling" (for automatic builds on push)
- Or check "Poll SCM" with schedule: `H/5 * * * *` (check every 5 minutes)

**Pipeline:**
- Definition: `Pipeline script from SCM`
- SCM: `Git`
- Repository URL: `https://github.com/klu2300030150/ecommerce-front1.git`
- Branch: `*/master`
- Script Path: `Jenkinsfile`

### 5. Environment Variables (Optional)

In the Pipeline job configuration, under "Pipeline" → "Environment Variables":
- `DEPLOY_TO_PROD`: `false` (set to `true` when you want to enable production deployment)

## Directory Structure for Deployment

Create these directories on your Jenkins server (or target deployment server):

```
C:\inetpub\wwwroot\ecommerce-staging\    # Staging environment
C:\inetpub\wwwroot\ecommerce-prod\       # Production environment
```

## Webhook Setup (for automatic builds)

### GitHub Webhook Configuration:

1. Go to your GitHub repository: `https://github.com/klu2300030150/ecommerce-front1`
2. Click Settings → Webhooks → Add webhook
3. Payload URL: `http://your-jenkins-server:8080/github-webhook/`
4. Content type: `application/json`
5. Events: Select "Just the push event"
6. Active: Check this option

## Manual Deployment Commands

### Using the deployment script:
```bash
# Deploy to staging only
deploy.bat staging

# Deploy to production only
deploy.bat production

# Deploy to both environments
deploy.bat both
```

### Using Docker (alternative deployment):
```bash
# Build Docker image
docker build -t ecommerce-frontend .

# Run container
docker-compose up -d

# Stop container
docker-compose down
```

## Pipeline Stages Explained

1. **Checkout**: Downloads code from GitHub
2. **Install Dependencies**: Runs `npm ci` to install packages
3. **Lint**: Runs ESLint to check code quality
4. **Build**: Creates production build using `npm run build`
5. **Test Build**: Verifies that build artifacts were created
6. **Archive Artifacts**: Stores build files for future reference
7. **Deploy to Staging**: Automatically deploys to staging on master branch
8. **Deploy to Production**: Manual approval required, only when `DEPLOY_TO_PROD=true`

## Troubleshooting

### Common Issues:

1. **Node.js not found**:
   - Ensure Node.js plugin is installed and configured in Global Tool Configuration

2. **Build fails**:
   - Check that all dependencies are correctly specified in package.json
   - Verify that the build script works locally

3. **Deployment fails**:
   - Check directory permissions
   - Ensure target directories exist
   - Verify Jenkins has write access to deployment directories

4. **Git authentication issues**:
   - For private repositories, configure Jenkins credentials
   - Go to Jenkins → Manage Jenkins → Manage Credentials

### Logs and Monitoring:

- Check Jenkins build console output for detailed error messages
- Monitor deployment directories for successful file copying
- Use Jenkins Pipeline Blue Ocean plugin for better visualization

## Security Considerations

1. **Credentials**: Store sensitive information in Jenkins credentials store
2. **Access Control**: Set up proper user permissions in Jenkins
3. **HTTPS**: Use HTTPS for Jenkins and webhook communications
4. **Firewall**: Configure firewall rules appropriately

## Notifications

Uncomment and configure the email sections in the Jenkinsfile to receive build notifications:

```groovy
emailext (
    subject: "Build Status: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
    body: "Build details here...",
    to: "your-email@example.com"
)
```
