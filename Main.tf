
provider "aws" {
  region = var.region
}

################################################
locals {
  # common_tags = {
  #   "Environment"       = var.medtronic-tags["environment-stage"]
  #   "Business Unit"     = var.medtronic-tags["business-unit"]
  #   "Business Contact"  = var.medtronic-tags["business-contact"]
  #   "Support Contact"   = var.medtronic-tags["support-contact"]
  #   "Cost Center"       = var.medtronic-tags["cost-center"]
  #   "WBS"               = var.medtronic-tags["wbs-code"]
  #   "deployment_source" = var.project-info["deployment-source"]
  #   "project-id"         = var.project-info["project-id"]
  #   "environment_name"  = var.project-info["environment-name"]
  # }

  Lambda-name = "${var.appshortname}-${var.envtype}-${var.apishortname}-Lambda" 
  
}


data archive_file lambda {
  type        = "zip"
  source_file = "index.js"
  output_path = "lambda_function.zip"
}


resource aws_iam_role iam {
  name = "iam_for_lambda1_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource aws_iam_policy this {
  name        = "Lambda-policy1"
  description = "Allow to access base resources and trigger transcoder"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SomeVeryDefaultAndOpenActions",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "ec2:DescribeNetworkInterfaces",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}

EOF
}
module lambda {
  source = "./Module/"

  function_name  = local.Lambda-name
  filename       = data.archive_file.lambda.output_path
  description    = "description should be here"
  handler        = "index.handler"
  runtime        = "nodejs12.x"
  memory_size    = "128"
  concurrency    = "5"
  lambda_timeout = "20"
  log_retention  = "1"
  role_arn       = aws_iam_role.iam.arn
  #tags           = local.common_tags

  # vpc_config = {
  #   subnet_ids         = ["sb-q53asdfasdfasdf", "sf-3asdfasdfasdf6"]
  #   security_group_ids = ["sg-3asdfadsfasdfas"]
  # }

  environment = {
    Environment = "Dev"
  }
  
}
