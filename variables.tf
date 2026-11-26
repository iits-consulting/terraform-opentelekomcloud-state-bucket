variable "tf_state_bucket_name" {
  type        = string
  description = "Bucket name."
}

data "opentelekomcloud_identity_project_v3" "current" {}

resource "errorcheck_is_valid" "provider_project_constraint" {
  name = "Check if the provider is correctly set to top level project."
  test = {
    assert        = data.opentelekomcloud_identity_project_v3.current.name == data.opentelekomcloud_identity_project_v3.current.region
    error_message = "ERROR! This module requires the provider project (tenant_name) to be a region level project. See README.md for more information."
  }
}

variable "key_suffix_byte_length" {
  type        = number
  description = "Byte length of the random suffix to be used for the KMS key"
  default     = 4
}
variable "kms_key_rotation_interval" {
  type        = number
  description = "Rotation interval in days (30-365) for the KMS key created by this module. Setting a value enables automatic key rotation. null turns rotation off, also on a key where it was enabled outside of Terraform. (default: null)"
  default     = null
  validation {
    condition     = var.kms_key_rotation_interval == null ? true : var.kms_key_rotation_interval >= 30 && var.kms_key_rotation_interval <= 365
    error_message = "kms_key_rotation_interval not in range 30 <= x <= 365"
  }
}
