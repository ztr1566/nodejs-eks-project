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