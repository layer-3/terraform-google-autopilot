variable "project_id" {
  description = "The GCP Project ID to deploy to."
}

variable "network_name" {
  description = "VPC network name"
}

variable "subnet_name" {
  description = "VPC subnet name"
}

variable "region" {
  description = "GCP region"
}

variable "is_private" {
  default     = false
  description = "Whether to create a private cluster"
}

variable "name" {
  description = "GKE cluster name"
}

variable "description" {
  description = "GKE cluster description"
  default     = ""
}

variable "release_channel" {
  description = "GKE release channel"
  default     = "STABLE"
}

variable "network_tags" {
  description = "Network tags to apply to the cluster nodes"
  type        = list(string)
  default     = []
}

variable "fleet_project" {
  description = "The GCP Project where the fleet is deployed"
  default     = null
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection for the cluster"
  default     = false
}

variable "bastion_zone" {
  description = "The zone where the bastion host is deployed"
  default     = null
}

variable "bastion_members" {
  description = "IAM members to grant access to the bastion host"
  type        = list(string)
  default     = []
}

variable "deploy_nat" {
  description = "Whether to deploy a Cloud NAT"
  default     = false
}

variable "router_name" {
  description = "Name of the router to create"
  default     = ""
}
