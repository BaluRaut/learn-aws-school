# 🛡️ Lesson 24 lab — the bouncer at the gate
# A web ACL: AWS managed common rules in COUNT mode (read the logs first!) + a rate limit that BLOCKS.
# Attach to lesson 15's ALB:  terraform apply -var alb_arn=arn:aws:elasticloadbalancing:...

variable "region"  { default = "us-east-1" }
variable "alb_arn" {}
provider "aws" { region = var.region }

resource "aws_wafv2_web_acl" "bouncer" {
  name  = "school-bouncer"
  scope = "REGIONAL"                       # ALB / API Gateway; CLOUDFRONT for the edge
  default_action { allow {} }

  # 📋 the rule book — count first, block after a day of reading logs
  rule {
    name     = "aws-common-rules"
    priority = 1
    override_action { count {} }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config { cloudwatch_metrics_enabled = true; metric_name = "CommonRules"; sampled_requests_enabled = true }
  }

  # ⏱️ the refresh kid: > 2000 requests / 5 min from one IP → blocked for a while
  rule {
    name     = "rate-limit"
    priority = 2
    action { block {} }
    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }
    visibility_config { cloudwatch_metrics_enabled = true; metric_name = "RateLimit"; sampled_requests_enabled = true }
  }

  visibility_config { cloudwatch_metrics_enabled = true; metric_name = "SchoolBouncer"; sampled_requests_enabled = true }
  tags = { project = "school-lab" }
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.bouncer.arn
}

output "web_acl_arn" { value = aws_wafv2_web_acl.bouncer.arn }
