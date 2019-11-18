variable "app" {
  type        = string
  default     = "entity-service"
}

variable "env" {
  type        = string
  default     = "dev"
}

variable "region" {
  type        = string
  default     = "eu-west-1"
}

variable "accountid" {
  type        = string
}

#variable "tables" {
#  description = "tables to be created as part of the app"
#  type        = list(string)
#  default     = ["app-dev-parts"]
#}