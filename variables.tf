variable "task_role_arn" {
  description = "task_role_arn"
  type        = string
}

variable "execution_role_arn" {
  description = "execution_role_arn"
  type        = string
}

variable "requires_compatibilities" {
  description = "requires_compatibilities"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "cluster_id" {
  description = "ecs cluster id"
  type        = string
}

variable "container_name" {
  description = "container name"
  type        = string
}

variable "container_image" {
  description = "container image"
  type        = string
}

variable "container_port" {
  description = "container_port"
  type        = number
}

# ECS Tasks

variable "essential" {
  description = "essential"
  type        = bool
  default     = true
}

variable "cpu" {
  description = "cpu"
  type        = number
  default     = 512
}

variable "memory" {
  description = "memory"
  type        = number
  default     = 1024
}

variable "command" {
  description = "run command"
  type        = list(string)
  default     = []
}

variable "port_mappings" {
  description = "port_mappings"
  type        = list(any)
  default     = []
  /*
  port_mappings = [
    {
      "protocol": "tcp",
      "containerPort": 8"
    }
  ]
  */
}

variable "environments" {
  description = "environment variables"
  type        = list(map(string))
  default     = []
  /*
    environments = [
      {
        name = "spring.profiles.active"
        value = "dev"
      }
    ]
  */
}

# aws ssm get-parameter --name /dev/apps/apple
variable "secrets" {
  description = "secret variables"
  type        = list(map(string))
  default     = []
  /*
    secrets = [
      {
        name = "apple.clientId"
        valueFrom = "arn:aws:ssm:<aws_region>:<aws_account>:parameter/dev/apps/apple/client-id"
      },
      {
        name = "apple.clientSecrets"
        valueFrom = "arn:aws:ssm:<aws_region>:<aws_account>:parameter/dev/apps/apple/client-secrets"
      }
    ]
  */
}

variable "ulimits" {
  description = "ulimits"
  type        = list(map(string))
  default     = []
  /*
    ulimits = [
      {
        "name": "nofile",
        "softLimit": 1000000,
        "hardLimit": 1000000
      }
    ]
  */
}

variable "logConfiguration" {
  description = "logConfiguration"
  type        = object({
    logDriver = string
    options   = map(string)
  })
  default = {
    logDriver = null
    options   = {}
  }
  /*
  {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/simple-an2p-myapp-ecss"
          awslogs-region        = "ap-northeast-2"
          awslogs-stream-prefix = "simple-an2p-myapp"
        }
      }
  */
}

variable "initProcessEnabled" {
  description = "initProcessEnabled"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_log_group" {
  description = "create cloudwatch log group"
  type        = bool
  default     = true
}

variable "retention_in_days" {
  description = "cloudwatch log group retention_in_days"
  type        = number
  default     = 90
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# ECS Service

variable "launch_type" {
  description = "launch_type of ECS Service"
  type        = string
  default     = "FARGATE"
}

variable "scheduling_strategy" {
  description = "scheduling_strategy of ECS Service"
  type        = string
  default     = "REPLICA"
  /*
  REPLICA | DAEMON
  */
}

variable "desired_count" {
  description = "desired_count of ECS Service"
  type        = number
  default     = 1
}

variable "enable_ecs_managed_tags" {
  description = "enable_ecs_managed_tags of ECS Service"
  type        = bool
  default     = true
}

variable "enable_execute_command" {
  description = "enable_execute_command of ECS Service"
  type        = bool
  default     = true
}

variable "health_check_grace_period_seconds" {
  description = "health_check_grace_period_seconds of ECS Service"
  type        = number
  default     = 360
}

variable "deployment_controller" {
  description = "deployment_controller of ECS Service"
  type        = string
  default     = "ECS"
  /*
  CODE_DEPLOY | ECS
  */
}

variable "enable_load_balancer" {
  description = "enable_load_balancer of ECS Service"
  type        = bool
  default     = true
}

variable "assign_public_ip" {
  description = "assign_public_ip of ECS Service"
  type        = bool
  default     = false
}

variable "subnets" {
  description = "subnets of ECS Service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "security_group_ids of ECS Service"
  type        = list(string)
}

variable "target_group_arn" {
  description = "target_group_arn of ECS Service"
  type        = string
}

variable "propagate_tags" {
  description = "propagate_tags of ECS Service"
  type        = string
  default     = "SERVICE"
  # SERVICE | TASK_DEFINITION | NONE
}

variable "cloud_map_namespace_id" {
  description = "cloud_map_namespace_id of Cloud Map Service Discovery"
  type        = string
  default     = null
}
