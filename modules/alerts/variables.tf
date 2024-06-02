# Alert policy and notification channel variables
variable "alert_policy_name" {
    description = "name of the alert policy"
    type = string
    default = null
}

variable "app_names" {
  description = "List of application names for NRQL queries"
  type        = list(string)
}

variable "account_id" {
    description = "Our New Relic Account Id"
    type = number
}
# variable "channel_name" {
#     description = "notification channel name"
#     type = list(string)
# }

variable "incident_preference" {
    description = "The rollup strategy for the policy."
    type = string
    default = "PER_POLICY"
}

# NRQL and Infrastructure alert condition variables
# variable "nrql_conditions" {
#     description = "object that is passed to create nrql conditions"
#     type = map
#     default = {}
# }

# variable "nrql_conditions" {
#   description = "A map of NRQL alert conditions"
#   type        = map(object({
#     account_id                  = number
#     type                        = string
#     name                        = string
#     enabled                     = bool
#     violation_time_limit_seconds = number

#     nrql = object({
#       query = string
#     })

#     critical = object({
#       operator              = string
#       threshold             = number
#       threshold_duration    = number
#       threshold_occurrences = string
#     })

#     warning = object({
#       operator              = string
#       threshold             = number
#       threshold_duration    = number
#       threshold_occurrences = string
#     })

#     fill_option         = string
#     aggregation_window  = number
#     aggregation_method  = string
#     aggregation_delay   = number
#     slide_by            = number
#   }))
# }

variable "nrql_conditions" {
  description = "A map of NRQL alert conditions"
  type        = map(object({
    account_id                   = number
    type                         = string
    name                         = string
    enabled                      = bool
    violation_time_limit_seconds = number

    nrql = object({
      query = string
    })

    critical = object({
      operator              = string
      threshold             = number
      threshold_duration    = number
      threshold_occurrences = string
    })

    warning = optional(object({
      operator              = string
      threshold             = number
      threshold_duration    = number
      threshold_occurrences = string
    }))

    fill_option         = string
    aggregation_window  = number
    aggregation_method  = string
    aggregation_delay   = number
    slide_by            = optional(number)
  }))
  default = {}
}


# variable "nrql_conditions" {
#   description = "A map of NRQL alert conditions"
#   type        = map(object({
#     account_id                  = number
#     type                        = string
#     name                        = string
#     enabled                     = bool
#     violation_time_limit_seconds = number

#     nrql = object({
#       query = string
#     })

#     critical = object({
#       operator              = string
#       threshold             = number
#       threshold_duration    = number
#       threshold_occurrences = string
#     })

#     warning = object({
#       operator              = string
#       threshold             = number
#       threshold_duration    = number
#       threshold_occurrences = string
#     })
#     fill_option         = string
#     aggregation_window  = number
#     aggregation_method  = string
#     aggregation_delay   = number
#     slide_by            = number
#   }))
# }


variable "infra_conditions" {
    description = "object that is passed to create infrastructure conditions"
    type = map
    default = {}
}

