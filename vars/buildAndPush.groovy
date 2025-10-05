def call(Map config) {
    def imageURI = config.imageURI
    def dockerfile = config.dockerfile ?: 'Dockerfile'
    def context = config.context ?: '.'
    def digestFileName = "image-digest.txt"
    def cacheRepo = "${config.awsAccountId}.dkr.ecr.${config.awsRegion}.amazonaws.com/kaniko-cache"

    container('kaniko') {
        echo "Building and pushing image: ${imageURI}"
        sh """
        /kaniko/executor --dockerfile=${dockerfile}
                         --context=${context}
                         --destination=${imageURI}
                         --cache=true
                         --cache-repo=${cacheRepo}
                         --cache-ttl=6h
                         --digest-file=${digestFileName}
        """
    }
    return digestFileName
}