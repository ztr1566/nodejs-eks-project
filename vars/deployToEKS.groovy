def call(Map config) {
    def imageURI = config.imageURI
    def manifestPath = config.manifestPath
    def gitRepoUrl = "github.com/ztr1566/nodejs-eks-project.git"

    withCredentials([usernamePassword(credentialsId: 'github-pat', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
        sh """
        echo "Updating Kubernetes manifest..."
        
        git config --global user.email "jenkins@example.com"
        git config --global user.name "Jenkins CI"
        
        sed -i 's|image: .*|image: ${imageURI}|g' ${manifestPath}
        
        git add ${manifestPath}
        git commit -m "chore(release): Update image to ${imageURI} [skip ci]"
        git push https://${GIT_USER}:${GIT_TOKEN}@${gitRepoUrl} HEAD:main
        """
    }
}