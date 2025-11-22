provider "aws" {
  region = var.region
  
  assume_role {
    role_arn = "arn:aws:iam::145426260677:role/Terraform-Control-Plane-Role"
  }
}
