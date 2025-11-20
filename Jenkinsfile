pipeline {

    agent any

    // ---- Environment variables ----
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
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
                    url: 'https://github.com/shadymh10/terraform-pipeline.git',
                    credentialsId: 'github-token'
                )
            }
        }

        stage('Terraform Init') {
            steps {
                echo "🔹 Initializing Terraform..."
                sh 'terraform init -input=false -reconfigure'
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

        // ---- Apply infra (optional) ----
        stage('Terraform Apply') {
            steps {
                echo "🚀 Applying Terraform plan..."
                sh 'terraform apply -input=false -auto-approve tfplan'
                echo "✅ Infrastructure deployed successfully!"
            }
        }

        // ---- Destroy infra (optional) ----
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
