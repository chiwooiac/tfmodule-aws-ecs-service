locals {
  ecs_task_role_name   = format("%s%s", var.context.project, replace(title( format("%s-EcsTaskRole", var.container_name) ), "-", "" ))
  ecs_task_policy_name = format("%s%s", var.context.project, replace(title( format("%s-EcsTaskPolicy", var.container_name) ), "-", "" ))
  tags                 = var.context.tags
  create_task_role     = var.task_role_arn == null ? true : false
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_role" {
  count              = local.create_task_role ? 1 : 0
  name               = local.ecs_task_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = merge(local.tags, { Name = local.ecs_task_role_name })
}

resource "aws_iam_role_policy_attachment" "ssm_session_policy" {
  count      = local.create_task_role ? 1 : 0
  role       = concat(aws_iam_role.task_role.*.name, [""])[0]
  policy_arn = "arn:aws:iam::aws:policy/AWSCloud9SSMInstanceProfile"
}

resource "aws_iam_policy" "task_policy" {
  count  = local.create_task_role && var.task_policy_json !=null ? 1 : 0
  name   = local.ecs_task_policy_name
  policy = var.task_policy_json # data.aws_iam_policy_document.task_policy.json (json formatted string)
  tags   = merge(local.tags, {
    Name = local.ecs_task_policy_name
  })
}

resource "aws_iam_role_policy_attachment" "custom" {
  count      = local.create_task_role && var.task_policy_json !=null ? 1 : 0
  role       = concat(aws_iam_role.task_role.*.name, [""])[0]
  policy_arn = concat(aws_iam_policy.task_policy.*.arn, [""])[0]
}
