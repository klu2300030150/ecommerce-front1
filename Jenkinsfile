pipeline {
    agent any
    
    tools {
        nodejs "NodeJS" // Make sure NodeJS is configured in Jenkins Global Tool Configuration
    }
    
    environment {
        NODE_ENV = 'production'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }
        
        stage('Check Node Version') {
            steps {
                echo 'Checking Node.js and npm versions...'
                bat 'node --version'
                bat 'npm --version'
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo 'Installing npm dependencies...'
                script {
                    try {
                        bat 'npm ci'
                    } catch (Exception e) {
                        echo 'npm ci failed, trying npm install...'
                        bat 'npm install'
                    }
                }
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
                        bat 'dir dist'
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
        
        stage('Deploy to Local') {
            when {
                branch 'master'
            }
            steps {
                echo 'Deploying to local directory...'
                script {
                    bat '''
                        echo "Creating deployment directory..."
                        if not exist "C:\\Jenkins\\deployments" mkdir "C:\\Jenkins\\deployments"
                        
                        echo "Removing old staging files..."
                        if exist "C:\\Jenkins\\deployments\\ecommerce-staging" (
                            rmdir /s /q "C:\\Jenkins\\deployments\\ecommerce-staging"
                        )
                        
                        echo "Creating new staging directory..."
                        mkdir "C:\\Jenkins\\deployments\\ecommerce-staging"
                        
                        echo "Copying build files..."
                        xcopy /s /e /h /y "dist\\*" "C:\\Jenkins\\deployments\\ecommerce-staging\\"
                        
                        echo "Deployment completed successfully!"
                        dir "C:\\Jenkins\\deployments\\ecommerce-staging"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed!'
            script {
                if (fileExists('dist')) {
                    echo 'Build artifacts found in dist folder'
                } else {
                    echo 'No build artifacts found'
                }
            }
        }
        success {
            echo 'Pipeline succeeded!'
            echo "✅ E-commerce frontend deployed successfully!"
            echo "📁 Deployment location: C:\\Jenkins\\deployments\\ecommerce-staging"
        }
        failure {
            echo 'Pipeline failed!'
            echo "❌ Check the console output above for error details"
        }
    }
}
