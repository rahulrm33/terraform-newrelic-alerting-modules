# New Relic provider variables (could also be stored as env variables)
variable "nr_api_key" {
    description = "The New Relic API key"
    type = string
}

variable "nr_account_id" {
    description = "Your New Relic Account Id"
    type = string
}

variable "account_id" {
    description = "Your New Relic Account Id"
    type = string
}

variable "nr_region" {
    description = "Your New Relic Accounts data center region. US or EU."
    type = string
    default = "US"
}

variable "app_names" {
  description = "List of application names for NRQL queries"
  type        = list(string)
}


variable "nrql_base_query" {
  description = "Base NRQL query template"
  type        = string
  default     = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appId"
}


# Alert policy and notification channel variables
variable "alert_policy_name" {
    description = "name of the alert policy"
    type = string
    default = null
}

# variable "channel_name" {
#     description = "notification channel name"
#     type = list(string)
#     default = null
# }

variable "incident_preference" {
    description = "The rollup strategy for the policy."
    type = string
    default = "PER_POLICY"
}

variable "nrql_conditions" {
  description = "Object that is passed to create NRQL conditions"
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

# NRQL and Infrastructure alert condition variables
# variable "nrql_conditions" {
#     description = "object that is passed to create nrql conditions"
#     type = map
#     default = {}
# }

variable "infra_conditions" {
    description = "object that is passed to create infrastructure conditions"
    type = map
    default = {}
}


# Slack notification channel variables
variable "slack_channel_name" {
  description = "The name of the Slack channel"
  type        = string
}

variable "slack_destination_id" {
  description = "The destination ID for the Slack channel"
  type        = string
}

variable "slack_channel_id" {
  description = "The Slack channel ID"
  type        = string
}

variable "slack_custom_details" {
  description = "Custom details for the Slack notification"
  type        = string
}

variable "workflow_name" {
  description = "The name of the workflow"
  type        = string
}

# Other existing variables
# ...
