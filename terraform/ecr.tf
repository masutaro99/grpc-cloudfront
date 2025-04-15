resource "aws_ecr_repository" "grpc_app" {
  name = "grpc-app"
}

resource "aws_ecr_lifecycle_policy" "grpc_app" {
  repository = aws_ecr_repository.grpc_app.name
  policy     = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep last 30 release tagged images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["release"],
          "countType": "imageCountMoreThan",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}
