// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "name" {
  description = "Name of the auto scaling policy"
  type        = string
}

variable "policy_type" {
  description = "The type of Autoscaling policy. Valid values are TargetTrackingScaling and StepScaling. Default is TargetTrackingScaling"
  type        = string
  default     = "TargetTrackingScaling"
}

variable "scalable_dimension" {
  description = <<EOF
    Scalable dimension of scalable target. Details to be found at
    https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html#API_RegisterScalableTarget_RequestParameters
  EOF
  type        = string
}

variable "service_namespace" {
  description = <<EOF
    AWS service namespace of the scalable target. Details to be found at
    https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html#API_RegisterScalableTarget_RequestParameters
  EOF
  type        = string
}

variable "resource_id" {
  description = <<EOF
    Resource type and unique identifier string for the resource associated with the scaling policy. Details found at
    https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html#API_RegisterScalableTarget_RequestParameters
  EOF
  type        = string
}

variable "predefined_metric_type" {
  description = "The metric type. Currently the valid values are ECSServiceAverageCPUUtilization or ECSServiceAverageMemoryUtilization"
  type        = string
}

variable "target_value" {
  description = "Target value for the metric threshold at which the auto-scaling will be triggerred"
  type        = string
}

variable "scale_in_cooldown" {
  description = "Amount of time, in seconds, after a scale in activity completes before another scale in activity can start."
  type        = string
  default     = "60"
}

variable "scale_out_cooldown" {
  description = "Amount of time, in seconds, after a scale out activity completes before another scale out activity can start."
  type        = string
  default     = "60"
}

variable "tags" {
  description = "An arbitrary map of tags that can be added to all resources."
  type        = map(string)
  default     = {}
}
