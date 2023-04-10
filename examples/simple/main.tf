locals {
  context = {
    region      = "string"
    project     = "string"
    name_prefix = "string"
    pri_domain  = "string"
    tags        = {
    }
  }
}


module "myapp" {
  source                 = "../../"
  context                = local.context
  cluster_id             = data.aws_ecs_cluster.this.id
  vpc_id                 = data.aws_vpc.this.id
  subnets                = data.aws_subnets.apps.ids
  security_group_ids     = [aws_security_group.container_sg.id]
  #
  cloud_map_namespace_id = data.aws_service_discovery_dns_namespace.this.id
  container_name         = "agent"
  container_image        = "ngrinder/agent:3.5.8"
  container_port         = -1
  command                = ["ngrinder-controller.dev.fin.opsnow.com:80"]
  desired_count          = 2
  cpu                    = 512
  memory                 = 1024
  #task_role_arn          = data.aws_iam_role.ecs_task_ssm_role.arn
  execution_role_arn     = data.aws_iam_role.ecs_task_execution_role.arn
  target_group_arn       = null
  enable_load_balancer   = false

}
