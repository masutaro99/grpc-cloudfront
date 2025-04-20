terraform {
  backend "s3" {
    bucket = "<BUCKET_NAME>"
    key    = "grpc-cloudfront/terraform.tfstate"
    region = "ap-northeast-1"
  }
}