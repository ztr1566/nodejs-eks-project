def call(Map config) {
    def imageURI = config.imageURI
    def manifestPath = config.manifestPath
    def namespace = config.namespace ?: 'default'

    container('deploy') {
        echo "Deploying image ${imageURI} to EKS..."
        sh """
        curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.5/2024-01-04/bin/linux/amd64/kubectl
        chmod +x ./kubectl
        mv ./kubectl /usr/local/bin/
        sed -i "s|image: .*|image: ${imageURI}|g" ${manifestPath}
        kubectl apply -f ${manifestPath} --namespace ${namespace}
        """
    }
}