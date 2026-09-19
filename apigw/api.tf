# 🎟️ Lesson 25 lab — the API front desk in front of lesson 19's hello helper
# Deploys lambda/hello.py behind an HTTP API. Per-request billing; idle = $0.

variable "region" { default = "us-east-1" }
provider "aws" { region = var.region }

data "archive_file" "hello" {
  type        = "zip"
  source_file = "${path.module}/../lambda/hello.py"
  output_path = "${path.module}/hello.zip"
}

resource "aws_iam_role" "helper" {                    # lesson 04's hat, for Lambda
  name               = "school-hello-helper"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Principal = { Service = "lambda.amazonaws.com" }, Action = "sts:AssumeRole" }] })
}
resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.helper.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"   # diaries only
}

resource "aws_lambda_function" "hello" {
  function_name    = "school-hello"
  role             = aws_iam_role.helper.arn
  runtime          = "python3.12"
  handler          = "hello.handler"
  filename         = data.archive_file.hello.output_path
  source_code_hash = data.archive_file.hello.output_base64sha256
}

# 🎟️ the front desk
resource "aws_apigatewayv2_api" "desk" {
  name          = "school-api"
  protocol_type = "HTTP"
  cors_configuration { allow_origins = ["*"]; allow_methods = ["GET"] }
}

resource "aws_apigatewayv2_integration" "hello" {
  api_id                 = aws_apigatewayv2_api.desk.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.hello.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "hello" {           # 🪧 the route: GET /hello → the helper
  api_id    = aws_apigatewayv2_api.desk.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.hello.id}"
}

resource "aws_apigatewayv2_stage" "default" {         # 🎭 one stage, auto-deployed, with ⏱️ tickets
  api_id      = aws_apigatewayv2_api.desk.id
  name        = "$default"
  auto_deploy = true
  default_route_settings { throttling_rate_limit = 100; throttling_burst_limit = 50 }
}

resource "aws_lambda_permission" "desk_may_call" {    # the desk may wake the helper
  statement_id  = "AllowAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.desk.execution_arn}/*/*"
}

output "api_url" { value = aws_apigatewayv2_api.desk.api_endpoint }
