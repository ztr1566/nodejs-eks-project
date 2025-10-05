def call(Map config) {
    def imageURI = config.imageURI
    def dockerfile = config.dockerfile ?: 'Dockerfile'
    def context = config.context ?: '.'
    def digestPath = "/workspace/${env.JOB_NAME.replace('/', '-')}-${env.BUILD_NUMBER}-digest.txt"

    container('kaniko') {
        echo "Building and pushing image: ${imageURI}"
        sh """
        /kaniko/executor --dockerfile=${dockerfile} \
                         --context=${context} \
                         --destination=${imageURI} \
                         --cache=true \
                         --digest-file=${digestPath}
        """
    }
    return digestPath
}