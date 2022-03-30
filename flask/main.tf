data "aws_vpc" "default" {
  default = true
} 

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.default.id}"
}

output "subnet_cidr_blocks" {
  value = data.aws_subnet_ids.public
}

# EKS Cluster
resource "aws_eks_cluster" "eks-cluster" {
  name     = "nord-cloud-cluster"
  role_arn = aws_iam_role.EKSNordCloudClusterRole.arn
  version  = "1.21"

  vpc_config {
    subnet_ids          =  flatten( data.aws_subnet_ids.public.ids )
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSNordCloudClusterPolicy
  ]
}

# NODE GROUP
resource "aws_eks_node_group" "node-ec2" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "t3_small-nord-cloud-group"
  node_role_arn   = aws_iam_role.NodeGroupRole.arn
  subnet_ids      = flatten( data.aws_subnet_ids.public.ids )

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 10

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSNordCloudWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonNordCloudEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonNordCloudEKS_CNI_Policy
  ]
  
  update_config {
    max_unavailable = 1
  }
}


#create ECR repositiory in stockholm
resource "aws_ecr_repository" "nordcloud" {
  name                 = "nordcloud"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


#Creating terraform bucket

#resource "aws_s3_bucket" "nordcloud" {
#  bucket = "nordcloud-terraform-state"

#  tags = {
#    Name        = "nordcloud tf state"
#    Environment = "Dev"
#  }
#}

#  bucket = aws_s3_bucket.nishanordcloud.id
#  acl    = "private"
##}