pipeline {
    //import groovy.io.FileType
    agent{label 'swarm'} 
    parameters {
        string(name: 'URL_TO_CHECK', defaultValue: 'http://10.176.45.133:9180/mfd/celtra/carousel/USA/99/21EF69A1-E480-46CD-BACC-2C2BD1FC49C9', description: 'Specify URL to test.')        
        choice(name: 'SKIP_TESTS', choices: 'true\nfalse', description: 'Switch OFF or switch ON tests. OFF by default.')        
        choice(name: 'URLS_FILE', choices: 'OK\nNOT_OK', description: 'Please choice URLs file to test.')
        }

    environment {
            URL_TO_CHECK = "${params.URL_TO_CHECK}"
            SKIP_TESTS = "${params.SKIP_TESTS}"
            URLS_FILE = "${params.URLS_FILE}"
    }

    stages {
    //         stage('Build Stage') {
    //             steps {
    //                 echo "Build'n'Push"
    //                 script {
    //                     def customImage = docker.build("catalinalab/hello-world:${BUILD_NUMBER}")
    //                     docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-catalinalab') {
    //                         echo "Pushing artifacts to registry"
    //                         customImage.push()
    //                     }
    //                 }
    //             }
    //         }

            stage('Testing') {
                steps {
                    script {
                        sh("chmod -R 777 ./* && ls -la && pwd && id")
                        UrlFilePath = sh ( script: "pwd", returnStdout: true ).trim()
                        String[] UrlsToCheck = new File("/etc/hosts")
                        //urls_${URLS_FILE}.txt")

                        UrlsToCheck.each {
                            println it
                        }

                        for (int i = 0; i < UrlsToCheck.length; i++) {
                            CHECK_RESULT = sh (
                                script: "curl -o /dev/null --silent --head --write-out '%{http_code}\\n' ${UrlsToCheck[i]}",
                                returnStdout: true
                            ).trim()

                            echo "Check result code: ${CHECK_RESULT}"

                            if (CHECK_RESULT != '200') sh('exit 1')
                        }
                    }
                }
            }
    }
}
