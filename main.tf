provider "aws" {
  region = "eu-north-1" # Change this to your desired AWS region
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster" # Change this to your desired cluster name
}

data "aws_ecr_repository" "wordpress" {
  name = "wordpress" # Change this to your ECR repository name for WordPress container
}

resource "aws_ecs_task_definition" "wordpress_task" {
  family                   = "wordpress-task" # Change this to your desired task definition name
  container_definitions    = jsonencode([{
    name      = "wordpress-container",
    image     = "918542549428.dkr.ecr.eu-north-1.amazonaws.com/wordpress:wp-latest",
    portMappings = [{
      containerPort = 80,
      hostPort      = 80,
    }],
    memory = 512,
    cpu    = 256,
  }])
  requires_compatibilities = ["EC2"] # Change this based on your desired launch type
}

resource "aws_ecs_service" "wordpress_service" {
  name            = "wordpress-service" # Change this to your desired service name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.wordpress_task.arn
  desired_count   = 1
  launch_type     = "EC2" # Change this based on your desired launch type
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.id
}
