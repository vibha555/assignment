pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'prod'], description: 'Terraform environment')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy', 'deploy-app'], description: 'Pipeline action')
        booleanParam(name: 'AUTO_APPROVE', defaultValue: false, description: 'Auto approve apply/destroy')
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        TF_IN_AUTOMATION   = 'true'
        TF_INPUT           = 'false'
        TF_DIR             = "terraform/envs/${params.ENVIRONMENT}"
        BACKEND_FILE       = "../../backend/${params.ENVIRONMENT}.hcl"
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Terraform Version') {
            steps {
                sh 'terraform version'
                sh 'aws --version'
            }
        }

        stage('Terraform Fmt') {
            steps {
                sh 'terraform fmt -recursive -check'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${env.TF_DIR}") {
                    sh 'terraform init -backend-config=${BACKEND_FILE} -reconfigure'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${env.TF_DIR}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            when { anyOf { expression { params.ACTION == 'plan' }; expression { params.ACTION == 'apply' } } }
            steps {
                dir("${env.TF_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval') {
            when { anyOf { expression { params.ACTION == 'apply' && !params.AUTO_APPROVE }; expression { params.ACTION == 'destroy' && !params.AUTO_APPROVE } } }
            steps {
                input message: "Approve ${params.ACTION} for ${params.ENVIRONMENT}?", ok: 'Approve'
            }
        }

        stage('Terraform Apply') {
            when { expression { params.ACTION == 'apply' } }
            steps {
                dir("${env.TF_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when { expression { params.ACTION == 'destroy' } }
            steps {
                dir("${env.TF_DIR}") {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }

        stage('Deploy App to EKS') {
            when { expression { params.ACTION == 'deploy-app' } }
            steps {
                dir("${env.TF_DIR}") {
                    script {
                        env.CLUSTER_NAME = sh(script: 'terraform output -raw cluster_name', returnStdout: true).trim()
                    }
                }
                sh 'aws eks update-kubeconfig --region ${AWS_DEFAULT_REGION} --name ${CLUSTER_NAME}'
                sh 'kubectl apply -f kubernetes/'
                sh 'kubectl get pods -n hospital'
                sh 'kubectl get svc -n hospital'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: "${env.TF_DIR}/tfplan", allowEmptyArchive: true
        }
    }
}
