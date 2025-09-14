variable "name" {
  type        = string
  default     = "acrdevopsthehardway"
  description = "Name for resources"
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Azure Location of resources"
}

variable "tags" {
  type = map(string)
}