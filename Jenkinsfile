pipeline {
    agent any

    environment {
        TF_LOG = "INFO"
        TF_WORKSPACE = "default"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                echo "🔹 Checking out repository..."
                git branch: 'main', url: 'https://github.com/shadymh10/terraform-pipeline.git'
            }
        }

        stage('Terraform Init') {
            steps {
                echo "🔹 Initializing Terraform..."
                sh '''
                    terraform init -input=false -reconfigure | tee tf_init.log
                '''
                archiveArtifacts artifacts: 'tf_init.log', allowEmptyArchive: true
            }
        }

        stage('Terraform Validate') {
            steps {
                echo "🔍 Validating Terraform files..."
                sh '''
                    terraform validate | tee tf_validate.log
                '''
                archiveArtifacts artifacts: 'tf_validate.log', allowEmptyArchive: true
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "📄 Running Terraform plan..."
                sh '''
                    terraform plan -out=tfplan | tee tf_plan.log
                '''
                archiveArtifacts artifacts: 'tf_plan.log', allowEmptyArchive: true
            }
        }

        stage('Optional: Terraform Apply') {
            steps {
                script {
                    def doApply = input message: "Do you want to APPLY these changes?", ok: "Yes, Apply"
                    if (doApply) {
                        echo "🚀 Applying Terraform plan..."
                        sh '''
                            terraform apply -auto-approve tfplan | tee tf_apply.log
                        '''
                        archiveArtifacts artifacts: 'tf_apply.log', allowEmptyArchive: true
                    } else {
                        echo "⚠️ Skipped Terraform Apply."
                    }
                }
            }
        }

        stage('Optional: Terraform Destroy') {
            steps {
                script {
                    def doDestroy = input message: "Do you want to DESTROY the infrastructure?", ok: "Yes, Destroy"
                    if (doDestroy) {
                        echo "🗑️ Destroying Terraform infrastructure..."
                        sh '''
                            terraform destroy -auto-approve | tee tf_destroy.log
                        '''
                        archiveArtifacts artifacts: 'tf_destroy.log', allowEmptyArchive: true
                    } else {
                        echo "⚠️ Skipped Terraform Destroy."
                    }
                }
            }
        }

    }

    post {
        always {
            echo "✅ Pipeline finished."
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
