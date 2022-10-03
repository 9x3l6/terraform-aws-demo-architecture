# CloudWatch rules & lambda permissions
# start every_day_8am
resource "aws_cloudwatch_event_rule" "every_day_8am" {
  name                = "every_day_8am"
  description         = "Fires every day 8AM"
  schedule_expression = "cron(0 8 * * ? *)"
}
resource "aws_lambda_permission" "allow_cloudwatch_every_day_8am_lambda_start_ec2_instances" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_start_ec2_instances.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every_day_8am.arn}"
}
resource "aws_cloudwatch_event_target" "lambda_start_ec2_instances_every_day_8am" {
  rule      = "${aws_cloudwatch_event_rule.every_day_8am.name}"
  target_id = "lambda"
  arn       = "${aws_lambda_function.lambda_start_ec2_instances.arn}"
}

# stop every_day_6pm
resource "aws_cloudwatch_event_rule" "every_day_6pm" {
  name                = "every_day_6pm"
  description         = "Fires every day 6PM"
  schedule_expression = "cron(0 18 * * ? *)"
}
resource "aws_lambda_permission" "allow_cloudwatch_every_day_6pm_lambda_stop_ec2_instances" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_stop_ec2_instances.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every_day_6pm.arn}"
}
resource "aws_cloudwatch_event_target" "lambda_stop_ec2_instances_every_day_6pm" {
  rule      = "${aws_cloudwatch_event_rule.every_day_6pm.name}"
  target_id = "lambda"
  arn       = "${aws_lambda_function.lambda_stop_ec2_instances.arn}"
}

# # start weekdays_8am
# resource "aws_cloudwatch_event_rule" "weekdays_8am" {
#   name                = "weekdays_8am"
#   description         = "Fires on the weekdays 8AM"
#   schedule_expression = "cron(0 8 * * MON-FRI *)"
# }
# resource "aws_lambda_permission" "allow_cloudwatch_weekdays_8am_lambda_start_ec2_instances" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = "${aws_lambda_function.lambda_start_ec2_instances.function_name}"
#   principal     = "events.amazonaws.com"
#   source_arn    = "${aws_cloudwatch_event_rule.weekdays_8am.arn}"
# }
# resource "aws_cloudwatch_event_target" "lambda_start_ec2_instances_weekdays_8am" {
#   rule      = "${aws_cloudwatch_event_rule.weekdays_8am.name}"
#   target_id = "lambda"
#   arn       = "${aws_lambda_function.lambda_start_ec2_instances.arn}"
# }

# # stop weekdays_6pm
# resource "aws_cloudwatch_event_rule" "weekdays_6pm" {
#   name                = "weeksdays_6pm"
#   description         = "Fires on the weekdays 6PM"
#   schedule_expression = "cron(0 18 * * MON-FRI *)"
# }
# resource "aws_lambda_permission" "allow_cloudwatch_weekdays_6pm_lambda_stop_ec2_instances" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = "${aws_lambda_function.lambda_stop_ec2_instances.function_name}"
#   principal     = "events.amazonaws.com"
#   source_arn    = "${aws_cloudwatch_event_rule.weekdays_6pm.arn}"
# }
# resource "aws_cloudwatch_event_target" "lambda_stop_ec2_instances_weekdays_6pm" {
#   rule      = "${aws_cloudwatch_event_rule.weekdays_6pm.name}"
#   target_id = "lambda"
#   arn       = "${aws_lambda_function.lambda_stop_ec2_instances.arn}"
# }

# archive file
data "archive_file" "zip_the_code" {
  type        = "zip"
  source_dir  = "${path.module}/../../${var.archive_file_source_dir}"
  output_path = "${path.module}/../../${var.archive_file_output_path}"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name         = "aws_iam_policy_for_terraform_aws_lambda_role"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   },
   {
      "Action": [
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
 ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.iam_for_lambda.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

# Lambda functions
resource "aws_lambda_function" "lambda_start_ec2_instances" {
  filename      = "${path.module}/../../${var.archive_file_output_path}"
  function_name = "start_ec2_instances"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.lambda_function_handler
  runtime       = var.lambda_function_runtime
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]

  environment {
    variables = {
      action = "start"
      instances = var.server_instance_ids
    }
  }
}
resource "aws_lambda_function" "lambda_stop_ec2_instances" {
  filename      = "${path.module}/../../${var.archive_file_output_path}"
  function_name = "stop_ec2_instances"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.lambda_function_handler
  runtime       = var.lambda_function_runtime
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]

  environment {
    variables = {
      action = "stop"
      instances = var.server_instance_ids
    }
  }
}
