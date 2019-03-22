variable "prefix" {
  default     = "aks-dev-jc"
  description = "A prefix used for all resources in this example"
}

variable "location" {
  default     = "West Europe"
  description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "kubernetes_client_id" {
  description = "The Client ID for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "kubernetes_client_secret" {
  description = "The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "client_id" {
  description = "App id for SPN"
}

variable "client_secret" {
  description = "App secret for SPN"
}

variable "subscription_id" {
  description = "Subscription id"
}

variable "tenant_id" {
  description = "Tenant id"
}




