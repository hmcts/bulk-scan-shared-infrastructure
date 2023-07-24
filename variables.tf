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

variable "aks_subscription_id" {}

variable "zone_redundant_service_bus" {
 default = false
}

variable "sku_service_bus" {
 default = "Basic"
}

variable "duplicate_detection_history_time_window_service_bus" {
 default = "PT59M"
}

variable "requires_duplicate_service_bus" {
 default = false
}

# Region names
variable "envelopes_queue_send_name" {
 default = "envelopes-queue-send-shared-access-key"
}

variable "envelopes_queue_listen_name" {
 default = "envelopes-queue-listen-shared-access-key"
}

variable "processed_envelopes_queue_send_name" {
 default = "processed-envelopes-queue-send-shared-access-key"
}

variable "processed_envelopes_queue_listen_name" {
 default = "processed-envelopes-queue-listen-shared-access-key"
}

variable "payments_queue_send_name" {
 default = "payments-queue-send-shared-access-key"
}

variable "payments_queue_listen_name" {
 default = "payments-queue-listen-shared-access-key"
}

# region connection strings and other shared queue information as Key Vault secrets

variable "envelopes_queue_send_resource_name" {
 default = "envelopes-queue-send-connection-string"
}

variable "envelopes_queue_listen_resource_name" {
 default = "envelopes-queue-listen-connection-string"
}

variable "envelopes_queue_max_delivery_count_resource_name" {
 default = "envelopes-queue-max-delivery-count"
}

variable "processed_envelopes_queue_send_resource_name" {
 default = "processed-envelopes-queue-send-connection-string"
}

variable "processed_envelopes_queue_listen_resource_name" {
 default = "processed-envelopes-queue-listen-connection-string"
}

variable "payments_queue_send_resource_name" {
 default = "payments-queue-send-connection-string"
}

variable "payments_queue_listen_resource_name" {
 default = "payments-queue-listen-connection-string"
}