pipeline {
    agent any

    environment {
        REGISTRY   = "default-route-openshift-image-registry.apps.elephant.zoo.local"
        IMAGE_NAME = "nginx-demo/nginx-ranjeet"
        OCP_API    = "https://api.elephant.zoo.local:6443"
        OCP_USER   = "kubeadmin"
        OCP_PASS   = "tfGdb-oeZoA-V8Anc-GeiCa"   // TODO: move to Jenkins credentials
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Login to OpenShift & Registry') {
            steps {
                sh '''
                  set -e

                  echo "Logging into OpenShift API..."
                  oc login ${OCP_API} \
                    --username=${OCP_USER} \
                    --password=${OCP_PASS} \
                    --insecure-skip-tls-verify=true

                  echo "Getting token for registry login..."
                  TOKEN=$(oc whoami -t)

                  echo "Logging Docker into OpenShift registry..."
                  echo "$TOKEN" | docker login ${REGISTRY} \
                    --username=${OCP_USER} --password-stdin
                '''
            }
        }

        stage('Build Docker image') {
            steps {
                sh '''
                  set -e
                  echo "Building image ${REGISTRY}/${IMAGE_NAME}:latest"
                  docker build -t ${REGISTRY}/${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Push Docker image') {
            steps {
                sh '''
                  set -e
                  echo "Pushing image to OpenShift registry..."
                  docker push ${REGISTRY}/${IMAGE_NAME}:latest
                '''
            }
        }

        // Optional: trigger ArgoCD sync via API (advanced, skipped here)
    }

    post {
        success {
            echo "Build and push successful. Now sync ArgoCD app to deploy the new image."
        }
    }
}

