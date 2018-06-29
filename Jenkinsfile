pipeline {
    agent none
    stages {
        stage('Build Stage') {
            agent{label 'swarm'}
            steps {
                echo "Build'n'Push"
                script {
                    def customImage = docker.build("catalinalab/hello-world:${BUILD_NUMBER}")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-catalinalab') {
                        echo "Pushing artifacts to registry"
                        customImage.push()
                    }
                }
            }
        }

        stage('Testing') {
            agent{label 'master'}
            steps {
                script {
                    sh("ls -la && pwd && id")
                    env.WORKSPACE = pwd()
                    def words = new File("${env.WORKSPACE}/words.txt") as String[]
                    words.each {
                        code = sh (
                                script: "curl -o /dev/null --silent --head --write-out '%{http_code}\\n' $it",
                                returnStdout: true
                            ).trim()
                    
                        if (code == 200) {
                            println "$it - OK (code: $code)"
                        } else {
                           println "$it  - Bad! (code: $code)"
                        }
                    }
                }
            }
        }
    }
}