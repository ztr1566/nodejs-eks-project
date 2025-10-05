resource "aws_ecr_repository" "app_repo" {
  name                 = "nodejs-eks-app-repo"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = "nodejs-eks-app"
  }
}

resource "aws_ecr_repository" "kaniko_cache_repo" {
  name                 = "kaniko-cache"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Project = "nodejs-eks-app"
  }
}