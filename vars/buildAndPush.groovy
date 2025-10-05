def call(Map config) {
    def imageURI = config.imageURI
    def dockerfile = config.dockerfile ?: 'Dockerfile'
    def context = config.context ?: '.'

    container('kaniko') {
        echo "Building and pushing image: ${imageURI}"
        sh """
        /kaniko/executor --dockerfile=${dockerfile} --context=${context} --destination=${imageURI} --cache=false
        """
    }
}