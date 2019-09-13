variable "product" {
  type = "string"
}

variable "location" {
  type    = "string"
  default = "UK South"
}

// as of now, UK South is unavailable for Application Insights
variable "appinsights_location" {
  type        = "string"
  default     = "West Europe"
  description = "Location for Application Insights"
}

variable "env" {
  type = "string"
}

variable "application_type" {
  type        = "string"
  default     = "Web"
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
  type = "map"
}

variable "envelope_queue_max_delivery_count" {
  type        = "string"
  default     = "10" // same as module's config
  description = "Envelope queue message max delivery counter. Extracted to variable so it can be assigned to application environment."
}

variable "notification_queue_max_delivery_count" {
  type        = "string"
  default     = "10" // same as module's config
  description = "Notification queue message max delivery counter. Extracted to variable so it can be overridden per environment."
}

variable "payment_queue_max_delivery_count" {
  type        = "string"
  default     = "10" // same as module's config
  description = "Payment queue message max delivery counter. Extracted to variable so it can be overridden per environment."
}
variable "external_cert_name" {}
variable "external_hostname" {}