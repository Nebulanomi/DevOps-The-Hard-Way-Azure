variable "name" {
  type        = string
  default     = "devopsthehardway"
  description = "Name for resources"
}

variable "location" {
  type        = string
  default     = "uksouth"
  description = "Azure Location of resources"
}

variable "tags" {
  type = map(string)
}

variable "log_analytics_workspace_name" {
  type        = string
  default     = "law-devopsthehardway"
  description = "Log Analytics Workspace Name"
}

variable "sku" {
  type        = string
  default     = "PerGB2018"
  description = "Log Analytics Workspace SKU"
}

variable "retention_in_days" {
  type        = number
  default     = 30
  description = "Log Analytics Workspace Retention in days"
}