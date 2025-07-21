resource "aws_iam_role" "codebuild_service_role" {
  name = "${var.app_name}-codebuild-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "codebuild_s3_policy" {
  name = "${var.app_name}-codebuild-s3-policy"
  role = aws_iam_role.codebuild_service_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.static_site.arn}",
          "${aws_s3_bucket.static_site.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_codebuild_project" "static_site" {
  name          = "${var.app_name}-codebuild"
  description   = "Build and deploy static site to S3"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild_service_role.arn

  source {
    type            = "GITHUB"
    location        = var.github_repo
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false


    environment_variable {
      name  = "S3_BUCKET"
      value = aws_s3_bucket.static_site.bucket
    }
  }

  tags = var.tags
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub's OIDC root CA
}

resource "aws_iam_role" "github_oidc_role" {
  name = "${var.app_name}-github-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:davidrf/davidrstudios:*"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "github_oidc_permissions" {
  name = "${var.app_name}-github-oidc-policy"
  role = aws_iam_role.github_oidc_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ],
        Resource = aws_codebuild_project.static_site.arn
      }
    ]
  })
}
