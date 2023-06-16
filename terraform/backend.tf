terraform {
  backend "s3" {
    bucket         = "averak-personal-terraform-state"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-lock-state"
  }
}
