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

locals {
  random_id               = random_integer.priority.result
  logical_product_service = "${var.logical_product_service}-${local.random_id}"
  naming_prefix           = "${var.logical_product_family}-${local.logical_product_service}"
  ingress_naming_prefix   = "${local.naming_prefix}-ing-${local.random_id}"
  vpc_name                = "${local.naming_prefix}-vpc-${local.random_id}"
  namespace_name          = "${local.naming_prefix}.local"
  ecs_sg_name             = "${local.naming_prefix}-sg-${local.random_id}"

  tags = merge(var.tags, { provisioner = "Terraform" })
}
