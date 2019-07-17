provider "aws" {
    region = "us-east-1"
#    allowed_account_ids = ["0123456789"]
}

terraform {
 backend "s3" {
 encrypt = true
 bucket = "terraform-remote-state-storage-s3-for-youtube"
 region = "us-east-1"
 key = "youtube/terraform.tfstate"
 dynamodb_table = "terraform-state-lock-dynamo"
 }
}


resource "aws_s3_bucket" "terraform-state-storage-s3" {
    bucket = "terraform-remote-state-storage-s3-for-youtube"

    versioning {
      enabled = true
    }

    lifecycle {
      prevent_destroy = true
    }

    tags = {
      Name = "S3 Remote Terraform State Store"
    }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  
  # I changed the model because this pay per request is more efficient for this purpose
  billing_mode = "PAY_PER_REQUEST"
  #read_capacity = 20
  #write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
