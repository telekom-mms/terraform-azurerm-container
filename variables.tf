# replace local_name with your usecase
# e.g. local_name = local_name

variable "local_name" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    /** resource definition */
    local_name = {
      name                          = ""
      tags = {}
    }
  }

  /** compare and merge custom and default values */
  /** merge all custom and default values */
  local_name = {
    for local_name in keys(var.local_name) :
    local_name => merge(local.default.local_name, var.local_name[local_name])
  }
}
