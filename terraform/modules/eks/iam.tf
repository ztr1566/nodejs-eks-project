# terraform/modules/eks/iam.tf

resource "aws_iam_role" "eks_nodes" {
  name = "${var.cluster_name}-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}


resource "aws_iam_role_policy_attachment" "eks_ebs_csi_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.eks_nodes.name
}

data "aws_iam_policy_document" "ecr_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = [
      var.app_repo_arn,
      var.kaniko_cache_repo_arn
    ]
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "${var.cluster_name}-ecr-policy"
  description = "Policy that grants push/pull access to ECR repos for the project"
  policy      = data.aws_iam_policy_document.ecr_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}
