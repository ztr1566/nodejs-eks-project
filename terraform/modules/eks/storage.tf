# Create GP3 storage class using kubectl after cluster is ready
resource "null_resource" "gp3_storage_class" {
  # This will run after EKS cluster and EBS CSI driver are ready
  depends_on = [
    module.eks,
    aws_eks_addon.ebs_csi,
    aws_eks_pod_identity_association.ebs_csi
  ]

  # Create the storage class
  provisioner "local-exec" {
    command = <<-EOT
      # Update kubeconfig
      aws eks update-kubeconfig --region ${data.aws_region.current.name} --name ${module.eks.cluster_name}
      
      # Wait for EBS CSI driver to be ready
      kubectl wait --for=condition=Ready pod -l app=ebs-csi-controller -n kube-system --timeout=300s
      
      # Create GP3 storage class
      kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3-encrypted
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  iops: "3000"
  throughput: "125"
  encrypted: "true"
  fsType: ext4
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
EOF
      
      # Remove default from gp2 if it exists
      kubectl annotate storageclass gp2 storageclass.kubernetes.io/is-default-class=false --overwrite || true
    EOT
  }

  # Delete storage class when destroying
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete storageclass gp3-encrypted || true"
  }
}

# Data source for current region
data "aws_region" "current" {}
