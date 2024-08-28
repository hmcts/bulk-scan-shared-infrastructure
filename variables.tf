variable "product" {
  type    = string
  default = "Bulk Scan"
}

variable "location" {
  type    = string
  default = "UK South"
}

// TODO move to UK South as it's available there now
variable "appinsights_location" {
  type        = string
  default     = "West Europe"
  description = "Location for Application Insights"
}

variable "env" {
  type = string
}

variable "application_type" {
  type        = string
  default     = "web"
  description = "Type of Application Insights (Web/Other)"
}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. This is usually sourced from environemnt variables and not normally required to be specified."
}

variable "jenkins_AAD_objectId" {
  description = "(Required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}

variable "subscription" {}
variable "mgmt_subscription_id" {}

variable "common_tags" {
  type = map(any)
}

variable "envelope_queue_max_delivery_count" {
  type        = string
  default     = "10" // same as module's config
  description = "Envelope queue message max delivery counter. Extracted to variable so it can be assigned to application environment."
}

variable "payment_queue_max_delivery_count" {
  type        = string
  default     = "10" // same as module's config
  description = "Payment queue message max delivery counter. Extracted to variable so it can be overridden per environment."
}

variable "managed_identity_object_id" {
  default = ""
}

variable "wafFileUploadLimit" {
  description = "Maximum file upload size in MB for WAF"
  default     = "100"
}

variable "sku_service_bus" {
  description = "Basic, Standard or Premium"
  default     = "Standard"
}

variable "capacity_service_bus" {
  default = 0
}

variable "zone_redundant_service_bus" {
  default = false
}

variable "aks_subscription_id" {}