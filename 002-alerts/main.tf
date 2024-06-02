# creates conditions, alert policy, and subscribes channels
# module "alerts" {
#   source            = "../modules/alerts"
#   alert_policy_name = var.alert_policy_name
#   nrql_conditions   = var.nrql_conditions
#   infra_conditions  = var.infra_conditions
# }

# module "alerts" {
#   source = "../modules/alerts"
#   alert_policy_name = var.alert_policy_name
#   account_id = var.account_id
#   nrql_conditions = var.nrql_conditions
#   infra_conditions = var.infra_conditions
# }

locals {
  app_names_string = join("', '", var.app_names)
  nrql_query = replace(var.nrql_base_query, "WHERE ", "WHERE appName IN ('${local.app_names_string}') AND ")
}

module "alerts" {
  source = "../modules/alerts"
  alert_policy_name = var.alert_policy_name
  account_id = var.account_id
  nrql_conditions = var.nrql_conditions
  infra_conditions = var.infra_conditions
  app_names = var.app_names  # Pass the app_names variable
}



# module "alerts" {
#   source = "../modules/alerts"
#   alert_policy_name = var.alert_policy_name
#   account_id = var.account_id
#   nrql_conditions = var.nrql_conditions
#   infra_conditions = var.infra_conditions
#   app_names = var.app_names
# }


# data "newrelic_alert_policy" "example_policy" {
#   name = "my-alert-policy"
# }

# Creates a Slack notification channel
resource "newrelic_notification_channel" "slack_channel" {
  name = var.slack_channel_name
  type = "SLACK"
  destination_id = var.slack_destination_id
  product = "IINT"

  property {
    key   = "channelId"
    value = "C067ZM79R24"  # Ensure this is the correct Slack channel ID
  }
  property {
    key = "customDetailsSlack"
    value = var.slack_custom_details
  }
}

# Connects the Slack channel to the policy using the channel id
# resource "newrelic_alert_policy_channel" "policy_channel" {
#   policy_id   = module.alerts.alert_policy_id
#   channel_ids = [newrelic_notification_channel.slack_channel.id]
# }

# Creates a workflow that uses the Slack channel
resource "newrelic_workflow" "workflow" {
  name = var.workflow_name
  muting_rules_handling = "NOTIFY_ALL_ISSUES"
  issues_filter {
    name = "Filter-name"
    type = "FILTER"
    predicate {
      attribute = "labels.policyIds"
      operator = "EXACTLY_MATCHES"
      values = [module.alerts.alert_policy_id]
    }
  }
  destination {
    channel_id = newrelic_notification_channel.slack_channel.id
  }
}



# Fetches the data for this policy from your New Relic account
# and is referenced in the newrelic_alert_policy_channel block below.



# resource "newrelic_notification_channel" "my-channel" {
#   # account_id = 1863749
#   name = "demo-cf"
#   type = "SLACK"
#   destination_id = "f96edd6d-d200-4661-9cae-90be2f41d8a5"
#   product = "IINT"

#   property {
#     key = "channelId"
#     value = "C071QJBLNMN"
#   }
#   property {
#     key = "customDetailsSlack"
#     value = "issue id - {{issueId}}\n Label - {{accumulations.tag.label.Name.[0]}}"
#   }
# }

# # resource "newrelic_notification_destination" "slack-imported-destination" {
# # }

# # resource "newrelic_alert_policy" "my-policy" {
# #   name = "my_policy"
# #   incident_preference = "PER_CONDITION_AND_TARGET"
# # }

# resource "newrelic_workflow" "my-workflow" {
#   name = "workflow-example"
#   muting_rules_handling = "NOTIFY_ALL_ISSUES"

#   issues_filter {
#     name = "Filter-name"
#     type = "FILTER"

#     predicate {
#       attribute = "labels.policyIds"
#       operator = "EXACTLY_MATCHES"
#       values = [ newrelic_alert_policy.my-policy.id ] # Here is the policy you created in step #1
#     }
#   }

#   destination {
#     channel_id = newrelic_notification_channel.my-channel.id # Here is the notification channel you created in step #4
#   }
# }


# Creates an email alert channel.
# resource "newrelic_notification_channel" "email_channel" {
#   name = "bar"
#   type = "email"

#   config {
#     recipients              = "rahul.rm@surveysparrow.com"
#     include_json_attachment = "1"
#   }
# }

# # Creates a Slack alert channel.
# resource "newrelic_notification_channel" "slack_channel" {
#   name = "slack-channel-example"
#   type = "slack"

#   config {
#     channel = "#example-channel"
#     url     = "https://surveysparrow.slack.com"
#   }
# }

# # Applies the created channels above to the alert policy
# # referenced at the top of the config.
# resource "newrelic_alert_policy_channel" "foo" {
#   policy_id  = data.newrelic_alert_policy.example_policy.id
#   channel_ids = [
#     newrelic_notification_channel.email_channel.id,
#     newrelic_notification_channel.slack_channel.id
#   ]
# }