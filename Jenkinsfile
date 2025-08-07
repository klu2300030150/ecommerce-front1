pipeline {
    agent any
    
    tools {
        nodejs "NodeJS" // Make sure NodeJS is configured in Jenkins Global Tool Configuration
    }
    
    environment {
        NODE_ENV = 'production'
        NODEJS_HOME = tool 'NodeJS'
        PATH = "${NODEJS_HOME}/bin:${env.PATH}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo 'Installing npm dependencies...'
                bat 'npm ci --production=false'
            }
        }
        
        stage('Lint') {
            steps {
                echo 'Running ESLint...'
                bat 'npm run lint'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building the application...'
                bat 'npm run build'
            }
        }
        
        stage('Test Build') {
            steps {
                echo 'Testing the build...'
                script {
                    if (fileExists('dist/index.html')) {
                        echo 'Build successful - dist folder created'
                    } else {
                        error 'Build failed - dist folder not found'
                    }
                }
            }
        }
        
        stage('Archive Artifacts') {
            steps {
                echo 'Archiving build artifacts...'
                archiveArtifacts artifacts: 'dist/**/*', allowEmptyArchive: false
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'master'
            }
            steps {
                echo 'Deploying to staging environment...'
                script {
                    // Copy build files to web server directory
                    // Adjust the path according to your web server setup
                    bat '''
                        if exist "C:\\inetpub\\wwwroot\\ecommerce-staging" (
                            rmdir /s /q "C:\\inetpub\\wwwroot\\ecommerce-staging"
                        )
                        mkdir "C:\\inetpub\\wwwroot\\ecommerce-staging"
                        xcopy /s /e /h /y "dist\\*" "C:\\inetpub\\wwwroot\\ecommerce-staging\\"
                    '''
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                allOf {
                    branch 'master'
                    expression { 
                        return env.DEPLOY_TO_PROD == 'true'
                    }
                }
            }
            steps {
                echo 'Deploying to production environment...'
                input message: 'Deploy to production?', ok: 'Deploy'
                script {
                    // Copy build files to production web server directory
                    bat '''
                        if exist "C:\\inetpub\\wwwroot\\ecommerce-prod" (
                            rmdir /s /q "C:\\inetpub\\wwwroot\\ecommerce-prod"
                        )
                        mkdir "C:\\inetpub\\wwwroot\\ecommerce-prod"
                        xcopy /s /e /h /y "dist\\*" "C:\\inetpub\\wwwroot\\ecommerce-prod\\"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
            // You can add notification steps here
            // emailext (
            //     subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            //     body: "Good news! The build succeeded.",
            //     to: "your-email@example.com"
            // )
        }
        failure {
            echo 'Pipeline failed!'
            // You can add notification steps here
            // emailext (
            //     subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            //     body: "Bad news! The build failed.",
            //     to: "your-email@example.com"
            // )
        }
    }
}
