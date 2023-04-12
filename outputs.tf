output "ecs_task_definition_id" {
  description = "ID of the ECS Task Definition"
  value       = aws_ecs_task_definition.this.id
}

output "ecs_service_id" {
  description = "ID of the ECS Application Service"
  value       = aws_ecs_service.this.id
  # value       = concat([aws_ecs_service.this.id], [""])[0]
}

output "ecs_service_name" {
  description = "The name of the ECS Application Service"
  value       = local.service_name
}

output "ecs_container_name" {
  value       = local.container_name
}

output "service_discovery" {
  value       = local.service_discovery
}

output "log_group_name" {
  description = "The name of the ECS Application Container"
  value       = local.cwlog_grp_name
}

