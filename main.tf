locals {
  task_name            = format("%s-%s-td", var.context.name_prefix, var.container_name)
  service_name         = format("%s-%s-ecss", var.context.name_prefix, var.container_name)
  container_name       = format("%s-%s-ecsc", var.context.name_prefix, var.container_name)
  service_discovery    = format("%s-%s", var.context.project, var.container_name)
  cwlog_grp_name       = format("/ecs/%s", local.service_name)
  enable_load_balancer = var.enable_load_balancer && var.target_group_arn != null && var.container_port > 0 ? true : false

  logConfiguration = var.enable_cloudwatch_log_group ? length(keys(var.logConfiguration.options)) > 0 ? var.logConfiguration : {
    logDriver = "awslogs"
    options   = {
      awslogs-group         = local.cwlog_grp_name
      awslogs-region        = var.context.region
      awslogs-stream-prefix = local.service_name
    }
  } : {
    logDriver = null
    options   = {}
  }

  container_definition = {
    name         = local.container_name
    image        = var.container_image
    essential    = var.essential
    memory       = var.memory
    cpu          = var.cpu
    command      = toset(var.command)
    portMappings = toset(var.port_mappings)
    environment  = toset(var.environments)
    secrets      = toset(var.secrets)
    ulimits      = toset(var.ulimits)

    logConfiguration = local.logConfiguration

    linuxParameters = {
      initProcessEnabled = var.initProcessEnabled
    }

  }

  task_role_arn = coalesce(var.task_role_arn, concat(aws_iam_role.task_role.*.arn, [""])[0])
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.task_name
  requires_compatibilities = var.requires_compatibilities
  network_mode             = "awsvpc"

  task_role_arn      = local.task_role_arn
  execution_role_arn = var.execution_role_arn

  cpu                   = var.cpu
  memory                = var.memory
  container_definitions = "[${jsonencode(local.container_definition)}]"

  tags = merge(var.context.tags,
    { Name = local.task_name }, var.tags)
}

resource "aws_ecs_service" "this" {
  name                    = local.service_name
  cluster                 = var.cluster_id
  task_definition         = format("%s:%s", aws_ecs_task_definition.this.family, aws_ecs_task_definition.this.revision)
  # task_definition         = aws_ecs_task_definition.this.id
  desired_count           = var.desired_count
  launch_type             = var.launch_type
  scheduling_strategy     = var.scheduling_strategy
  enable_ecs_managed_tags = var.enable_ecs_managed_tags
  enable_execute_command  = var.enable_execute_command

  deployment_controller {
    type = var.deployment_controller
  }

  dynamic "load_balancer" {
    for_each = local.enable_load_balancer == true ? [1] : []
    content {
      container_name   = local.container_name
      container_port   = var.container_port
      target_group_arn = var.target_group_arn
    }
  }

  network_configuration {
    assign_public_ip = var.assign_public_ip
    subnets          = toset(var.subnets)
    security_groups  = toset(var.security_group_ids)
  }

  propagate_tags = var.propagate_tags

  dynamic "service_registries" {
    for_each = var.cloud_map_namespace_id != null ? [1] : []
    content {
      registry_arn   = concat(aws_service_discovery_service.this.*.arn, [""])[0]
      container_name = local.service_name
    }
  }

  lifecycle {
    ignore_changes = [load_balancer, desired_count]
  }

  tags = merge(var.tags,
    { Name = local.service_name }
  )

  depends_on = [aws_ecs_task_definition.this]
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.enable_cloudwatch_log_group ? 1 : 0
  name              = local.cwlog_grp_name
  retention_in_days = var.retention_in_days
}

resource "aws_service_discovery_service" "this" {
  count = var.cloud_map_namespace_id != null ? 1 : 0
  name  = local.service_discovery

  dns_config {
    namespace_id = var.cloud_map_namespace_id
    dns_records {
      ttl  = 60
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }

}
