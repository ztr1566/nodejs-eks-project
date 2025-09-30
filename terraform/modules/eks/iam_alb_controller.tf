# terraform/modules/eks/iam_alb_controller.tf

# This data source downloads the IAM policy document from AWS documentation
data "http" "aws_load_balancer_controller_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}

# This resource creates the IAM policy from the document we just downloaded
resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "${var.cluster_name}-alb-controller-policy"
  description = "IAM policy for the AWS Load Balancer Controller"
  policy      = data.http.aws_load_balancer_controller_policy.response_body
}

# This is the IAM module that creates the role for the Kubernetes service account
module "iam_assumable_role_for_service_account" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.30"

  create_role = true

  role_name    = "${var.cluster_name}-alb-controller-role"
  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")

  # We now attach the ARN of the policy WE CREATED, not the data source
  role_policy_arns = [aws_iam_policy.aws_load_balancer_controller.arn]

  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}
