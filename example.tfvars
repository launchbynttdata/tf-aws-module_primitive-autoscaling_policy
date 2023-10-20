# Please populate the fields within <> with actual values
name               = "memory-scaling-policy"
scalable_dimension = "ecs:service:DesiredCount"
service_namespace  = "ecs"
resource_id        = "service/<ecs_cluster_name>/<ecs_service_name>"
# Either CPU for Memory for ecs type
predefined_metric_type = "ECSServiceAverageMemoryUtilization"
target_value           = "80"
