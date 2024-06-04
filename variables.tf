variable "apps" {
  description = "Map of application names to their IDs and Slack channel details"
  type = map(object({
    name                = string
    slack_channel_name  = string
    slack_destination_id = string
    slack_channel_id    = string
    slack_custom_details = string
  }))
  default = {
    "salesparrow" = { 
      name = "salesparrow",
      slack_channel_name = "demo-cf",
      slack_destination_id = "f96edd6d-d200-4661-9cae-90be2f41d8a5",
      slack_channel_id = "C067ZM79R24",
      slack_custom_details = "issue id - {{issueId}}\n Label - {{accumulations.tag.label.Name.[0]}}"
    },
    # "Surveysparrow UK EKS" = {  //Add upcoming application's in this list with appropriate channelid
    #   name = "Surveysparrow UK EKS",
    #   slack_channel_name = "demo-cf",
    #   slack_destination_id = "f96edd6d-d200-4661-9cae-90be2f41d8a5",
    #   slack_channel_id = "C071QJBLNMN",
    #   slack_custom_details = "issue id - {{issueId}}\n Label - {{accumulations.tag.label.Name.[0]}}"
    # }
  }
}



variable "newrelic_api_key" {
  description = "New Relic API Key"
  type        = string
}

# variable "apps" {
#   description = "Map of application names to their IDs"
#   type = map(object({
#     name = string
#   }))
#   default = {
#     "Surveysparrow US EKS" = { name = "salesparrow" }
#   }
# }

# variable "slack_channel_name" {
#   description = "Name of the Slack channel"
#   type        = string
# }

# variable "slack_destination_id" {
#   description = "Slack destination ID"
#   type        = string
# }

# variable "slack_channel_id" {
#   description = "Slack channel ID"
#   type        = string
# }

# variable "slack_custom_details" {
#   description = "Custom details for Slack notifications"
#   type        = string
# }

# variable "workflow_name" {
#   description = "Name of the New Relic workflow"
#   type        = string
# }
