# EKS-Terraform

# Terraform AWS IAM Roles and Policies for EKS

This Terraform module sets up the necessary AWS Identity and Access Management (IAM) roles and policies to support an Amazon Elastic Kubernetes Service (EKS) cluster and its associated node groups. The module creates the following resources:

- IAM role for the EKS cluster with the required policies.
- IAM role for the EKS node group with the required policies.

## Prerequisites

Before using this module, ensure you have the following:

1. An AWS account with sufficient permissions to create IAM roles and policies.
2. Terraform installed on your local machine or CI/CD pipeline.
3. AWS CLI configured with the appropriate credentials and region settings.

## Resources Created

### EKS Cluster Role

The IAM role for the EKS cluster allows the EKS service to assume this role to manage your Kubernetes cluster.

```hcl
resource "aws_iam_role" "kien_cluster_role" {
  name = "kien-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kien_cluster_role_policy" {
  role       = aws_iam_role.kien_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
```

### EKS Node Group Role

The IAM role for the EKS node group allows EC2 instances to join the EKS cluster and communicate with other AWS services.

```hcl
resource "aws_iam_role" "kien_node_group_role" {
  name = "kien-node-group-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kien_node_group_role_policy" {
  role       = aws_iam_role.kien_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "kien_node_group_cni_policy" {
  role       = aws_iam_role.kien_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "kien_node_group_registry_policy" {
  role       = aws_iam_role.kien_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
```

## Usage

1. Clone this repository or copy the Terraform files into your project.
2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Review and customize variables in `variables.tf` to match your requirements.
4. Preview the Terraform plan:

   ```bash
   terraform plan
   ```

5. Apply the Terraform configuration to create the resources:

   ```bash
   terraform apply
   ```

6. Verify the resources have been created successfully in the AWS Management Console.

## Variables

Ensure to define any required variables in the `variables.tf` file. Example:

```hcl
variable "region" {
  description = "The AWS region to deploy resources to."
  default     = "us-west-2"
}
```

## Outputs

The `output.tf` file can be configured to provide outputs for the created IAM roles, such as:

```hcl
output "eks_cluster_role_arn" {
  description = "The ARN of the EKS cluster IAM role."
  value       = aws_iam_role.kien_cluster_role.arn
}

output "node_group_role_arn" {
  description = "The ARN of the EKS node group IAM role."
  value       = aws_iam_role.kien_node_group_role.arn
}
```

## Cleanup

To destroy the resources created by this module, run:

```bash
terraform destroy
```

## Notes

- Ensure you do not hard-code sensitive information such as access keys.
- Follow best practices for IAM role and policy management to adhere to the principle of least privilege.

## License

This project is licensed under the MIT License - see the LICENSE file for details.


