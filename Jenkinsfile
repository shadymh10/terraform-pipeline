pipeline {
    agent any

    // ---- Environment variables ----
    environment {
        AWS_REGION = 'us-east-1'
    }

    // ---- Parameters ----
    parameters {
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Set true to destroy infra after run')
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "🔹 Checking out repository..."
                git(
                    branch: 'main',
                    url: 'https://github.com/shadymh10/terraform-pipeline.git'
                    // No credentials needed for public repo
                )
            }
        }

        stage('Terraform Init') {
            steps {
                echo "🔹 Initializing Terraform..."
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-access-key']]) {
                    sh 'terraform init -input=false -reconfigure'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                echo "🔍 Validating Terraform files..."
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "📦 Creating Terraform plan..."
                sh 'terraform plan -input=false -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "🚀 Applying Terraform plan..."
                sh 'terraform apply -input=false -auto-approve tfplan'
                echo "✅ Infrastructure deployed successfully!"
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.DESTROY == true }
            }
            steps {
                echo "🗑️ Destroying Terraform infrastructure..."
                sh 'terraform destroy -auto-approve'
                echo "🔥 Infrastructure destroyed successfully!"
            }
        }

    }

    post {
        success {
            echo "🎉 Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
