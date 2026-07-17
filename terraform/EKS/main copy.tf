provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "backend" {
  bucket = "vinayak-project-backend-bucket"
  region = "ap-south-1"

  tags = {
    name = "project-backend"
    environment = "prod"
  }
}

resource "aws_dynamodb_table" "terraform_statelock" {
  name = "project-tf-eks-statelock"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}