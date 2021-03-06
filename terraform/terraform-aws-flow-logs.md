
# Terraform AWS Flow Logs

The code below will implement AWS flow logs.

```
data "aws_iam_policy_document" "flow_log_role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "flow_log_role" {
  name               = "flow_log_role-${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.flow_log_role.json}"
}

data "aws_iam_policy_document" "flow_log_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "flow_log_policy" {
  name   = "flow_log_policy-${var.environment}"
  role   = "${aws_iam_role.flow_log_role.id}"
  policy = "${data.aws_iam_policy_document.flow_log_policy.json}"
}

resource "aws_cloudwatch_log_group" "vpc-flow-log-group" {
  name = "vpc-flow-log-group-${var.environment}"

  tags = "${merge(
      map("Name", "vpc-flow-log-group-${var.environment}"),
      var.tags
    )}"
}

resource "aws_flow_log" "flow_log" {
  log_destination = "${aws_cloudwatch_log_group.vpc-flow-log-group.arn}"
  iam_role_arn    = "${aws_iam_role.flow_log_role.arn}"
  vpc_id          = "${aws_vpc.shared-services.id}"
  traffic_type    = "ALL"
}
```
