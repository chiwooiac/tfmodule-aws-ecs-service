# tfmodule-aws-ecs-service

AWS ECS 애플리케이션 서비스를 구성 하는 테라폼 모듈 입니다.

## [ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)
ECS 는 AWS 의 다양한 서비스(기능)들과 통합과 빠르고 쉽게 구성이 가능합니다.

컨테이너 오케스트레이션 도구로는 AWS 이외에도 Docker Swarm, Kubernetes, 하시코프의 Nomad 등 오픈소스가 있습니다.

## Usage

```
module "ctx" {
  source = "git::https://github.com/chiwooiac/tfmodule-context.git"
  context = {  
    # ... You need to define context variables ...
  }
}

module "myapp" {
  source = "git::https://github.com/chiwooiac/tfmodule-aws-ecs-service.git"
  
  cluster_id             = data.aws_ecs_cluster.this.id
  vpc_id                 = data.aws_vpc.this.id
  subnets                = [ data.aws_subnets.apps.ids ]
  security_group_ids     = [ aws_security_group.container_sg.id ]
  task_role_arn          = data.aws_iam_role.ecs_task_ssm_role.arn
  execution_role_arn     = data.aws_iam_role.ecs_task_execution_role.arn
  #
  cloud_map_namespace_id = data.aws_service_discovery_dns_namespace.this.id
  container_name         = "nginx"
  container_image        = "nginx:alpine3.17"
  container_port         = -1
  target_group_arn       = null
  enable_load_balancer   = false
}

```

docker pull nginx:stable-alpine3.17
