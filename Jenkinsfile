pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: git
            image: alpine/git:latest
            command:
            - cat
            tty: true
          - name: docker
            image: docker:latest
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          - name: shell
            image: viejo/kubectl
            command:
            - cat
            tty: true
          volumes:
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock    
        '''
    }
  }
  
  environment {
    DOCKER_HUB_CREDENTIALS = credentials('DEVSDS_DOCKERHUB')
    }
  
  
  stages {
    stage('Clone') {
      steps {
        container('git') {
          git branch: 'main', changelog: false, poll: false, url: 'https://github.com/kalpitrcc/JupyterHub.git'
        }
      }
    }  
    stage('Build-Docker-Image') {
      steps {
        container('docker') {
          sh 'docker build -t devsds/jupyterhub:v1.0_$BUILD_NUMBER .'
        }
      }
    }
    stage('Login-Into-Docker') {
      steps {
        container('docker') {
          sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
        }
      }
    }
    stage('Push-Images-Docker-to-DockerHub') {
      steps {
        container('docker') {
          sh 'docker push devsds/jupyterhub:v1.0_$BUILD_NUMBER'
        }
      }
   }
   stage('Deploy Jupyterhub'){
     steps{
        script{
	         String filenew = readFile('jupyterhub-deploy.yaml').replaceAll('@@@IMAGE_TAG@@@',"devsds/jupyterhub:v1.0_" + env.BUILD_NUMBER )   
	         writeFile file:'jupyterhub-deploy.yaml', text: filenew
        }
        container('shell') {
           withKubeConfig([credentialsId: 'KUBECONFIG', serverUrl: 'https://hpecp-10-1-100-147.rcc.local:10007']) {
             sh 'kubectl delete -f jupyterhub-deploy.yaml'
	     sh 'sleep 10s'
             sh 'kubectl create -f jupyterhub-deploy.yaml'
	     sh 'sleep 10s'
             sh 'kubectl get  svc jupyter-svc -o jsonpath="{.metadata.annotations.hpecp-internal-gateway/8888}"'
           }
        }
     }
   }
       
  }
    post {
      always {
        container('docker') {
          sh 'docker rmi -f devsds/jupyterhub:v1.0_$BUILD_NUMBER'
      }
      }
    }
}
