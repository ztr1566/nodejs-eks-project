# Step 1: Create the OIDC Identity Provider to establish trust with GitHub
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # Standard GitHub thumbprint
}

# Step 2: Create the IAM Role that GitHub Actions will assume
resource "aws_iam_role" "github_actions_ecr" {
  name = "github-actions-ecr-role"

  # The Trust Policy: This is the most important part
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          # Only trusts the OIDC provider we created above
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            # Condition: Only allow actions from your specific GitHub repository's main branch
            "token.actions.githubusercontent.com:sub" = "repo:ztr1566/nodejs-eks-project:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

# Step 3: Attach the necessary permissions to the role
# This policy allows actions needed to log in and push images to ECR
resource "aws_iam_role_policy_attachment" "github_ecr_power_user" {
  role       = aws_iam_role.github_actions_ecr.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}