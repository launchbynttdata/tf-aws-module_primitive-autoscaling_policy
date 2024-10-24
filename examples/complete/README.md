# Complete example
This example demonstrates creating an auto-scaling policy (MemoryUtilization) for an ECS service.

Note: This module assumes that a sample application is already present in the ECR (`var.container_image`) in the same AWS account where this module is run. Cross account ECR image pull is not supported at this moment as VPC endpoints only work in the same account. Our setup is done in a private VPC without internet connection.

## Provider requirements
Make sure a `provider.tf` file is created with the below contents inside the `examples/with_tls_enforced` directory
```shell
provider "aws" {
  profile = "<profile_name>"
  region  = "<aws_region>"
}
# Used to create a random integer postfix for aws resources
provider "random" {}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.0.0 |
| <a name="module_ecs_platform"></a> [ecs\_platform](#module\_ecs\_platform) | terraform.registry.launch.nttdata.com/module_collection/ecs_appmesh_platform/aws | ~> 1.0 |
| <a name="module_sg_ecs_service"></a> [sg\_ecs\_service](#module\_sg\_ecs\_service) | terraform-aws-modules/security-group/aws | ~> 4.17.1 |
| <a name="module_container_definition"></a> [container\_definition](#module\_container\_definition) | git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git | 0.58.2 |
| <a name="module_ecs_alb_service_task"></a> [ecs\_alb\_service\_task](#module\_ecs\_alb\_service\_task) | cloudposse/ecs-alb-service-task/aws | ~> 0.69.0 |
| <a name="module_autoscaling_target"></a> [autoscaling\_target](#module\_autoscaling\_target) | terraform.registry.launch.nttdata.com/module_primitive/autoscaling_target/aws | ~> 1.0 |
| <a name="module_autoscaling_policies"></a> [autoscaling\_policies](#module\_autoscaling\_policies) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [random_integer.priority](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"ecs"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which the infra needs to be provisioned | `string` | `"us-east-2"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | `"10.1.0.0/16"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet cidrs | `list(string)` | <pre>[<br>  "10.1.1.0/24",<br>  "10.1.2.0/24",<br>  "10.1.3.0/24"<br>]</pre> | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones for the VPC | `list(string)` | <pre>[<br>  "us-east-2a",<br>  "us-east-2b",<br>  "us-east-2c"<br>]</pre> | no |
| <a name="input_interface_vpc_endpoints"></a> [interface\_vpc\_endpoints](#input\_interface\_vpc\_endpoints) | List of VPC endpoints to be created | <pre>map(object({<br>    service_name        = string<br>    subnet_names        = optional(list(string), [])<br>    private_dns_enabled = optional(bool, false)<br>    tags                = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_gateway_vpc_endpoints"></a> [gateway\_vpc\_endpoints](#input\_gateway\_vpc\_endpoints) | List of VPC endpoints to be created | <pre>map(object({<br>    service_name        = string<br>    subnet_names        = optional(list(string), [])<br>    private_dns_enabled = optional(bool, false)<br>    tags                = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_vpce_security_group"></a> [vpce\_security\_group](#input\_vpce\_security\_group) | Default security group to be attached to all VPC endpoints | <pre>object({<br>    ingress_rules            = optional(list(string))<br>    ingress_cidr_blocks      = optional(list(string))<br>    ingress_with_cidr_blocks = optional(list(map(string)))<br>    egress_rules             = optional(list(string))<br>    egress_cidr_blocks       = optional(list(string))<br>    egress_with_cidr_blocks  = optional(list(map(string)))<br>  })</pre> | `null` | no |
| <a name="input_ecs_security_group"></a> [ecs\_security\_group](#input\_ecs\_security\_group) | Security group for the  ECS application. | <pre>object({<br>    ingress_rules            = optional(list(string))<br>    ingress_cidr_blocks      = optional(list(string))<br>    ingress_with_cidr_blocks = optional(list(map(string)))<br>    egress_rules             = optional(list(string))<br>    egress_cidr_blocks       = optional(list(string))<br>    egress_with_cidr_blocks  = optional(list(map(string)))<br>    ingress_with_sg          = optional(list(map(string)))<br>    egress_with_sg           = optional(list(map(string)))<br>  })</pre> | `null` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Docker image url. Must be in the same account as the ECS as VPC endpoints are configured | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | n/a | `string` | n/a | yes |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Min capacity of the scalable target. | `number` | n/a | yes |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Max capacity of the scalable target. | `number` | n/a | yes |
| <a name="input_scale_in_cooldown"></a> [scale\_in\_cooldown](#input\_scale\_in\_cooldown) | Amount of time, in seconds, after a scale in activity completes before another scale in activity can start. | `string` | `"60"` | no |
| <a name="input_scale_out_cooldown"></a> [scale\_out\_cooldown](#input\_scale\_out\_cooldown) | Amount of time, in seconds, after a scale out activity completes before another scale out activity can start. | `string` | `"60"` | no |
| <a name="input_auto_scaling_policy_name"></a> [auto\_scaling\_policy\_name](#input\_auto\_scaling\_policy\_name) | Name of the auto scaling policy | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | An arbitrary map of tags that can be added to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_random_int"></a> [random\_int](#output\_random\_int) | Random Int postfix |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
| <a name="output_vpce_sg_id"></a> [vpce\_sg\_id](#output\_vpce\_sg\_id) | VPC Endpoing Security Group ID |
| <a name="output_ecs_sg_id"></a> [ecs\_sg\_id](#output\_ecs\_sg\_id) | ECS Service Security Group ID |
| <a name="output_fargate_arn"></a> [fargate\_arn](#output\_fargate\_arn) | Fargate Cluster ARN |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ECS Service ID/Name |
| <a name="output_autoscaling_target_arn"></a> [autoscaling\_target\_arn](#output\_autoscaling\_target\_arn) | ARN of the auto-scaling target |
| <a name="output_autoscaling_target_id"></a> [autoscaling\_target\_id](#output\_autoscaling\_target\_id) | ID of the auto-scaling target |
| <a name="output_autoscaling_policy_arn"></a> [autoscaling\_policy\_arn](#output\_autoscaling\_policy\_arn) | ARN of the auto-scaling policy |
| <a name="output_autoscaling_policy_id"></a> [autoscaling\_policy\_id](#output\_autoscaling\_policy\_id) | ID of the auto-scaling policy |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
