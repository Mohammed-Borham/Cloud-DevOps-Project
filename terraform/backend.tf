terraform {
  backend "s3" {
    bucket         = "cloud-devops-project-tfstate"
    key            = "eks-devops/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
