terraform {
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
    }
  }
}

provider "newrelic" {
  account_id = 1863749
  api_key    = var.newrelic_api_key
}

resource "newrelic_alert_policy" "app_policy" {
  for_each = var.apps

  name = "${each.value.name} Alert Policy"
}

resource "newrelic_nrql_alert_condition" "response_time_more_than_3_seconds" {
  for_each = var.apps

  account_id = 1863749
  policy_id  = newrelic_alert_policy.app_policy[each.key].id
  type       = "static"
  name       = "${each.value.name} - Response time more than 3 seconds"
  enabled    = false
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT max(((totalTime OR duration OR 0) + (queueDuration OR 0) OR 0) ) AS 'Response time' FROM Transaction WHERE appName = '${each.value.name}' AND transactionType = 'Web' FACET `name`"
  }

  critical {
    operator            = "above"
    threshold           = 5
    threshold_duration  = 180
    threshold_occurrences = "all"
  }

  warning {
    operator            = "above"
    threshold           = 3
    threshold_duration  = 300
    threshold_occurrences = "all"
  }

  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "response_time_web_is_above_500ms" {
  for_each = var.apps

  account_id = 1863749
  policy_id  = newrelic_alert_policy.app_policy[each.key].id
  type       = "static"
  name       = "${each.value.name} - Response time (web) is above 500ms"
  enabled    = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appName = '${each.value.name}' AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appName"
  }

  warning {
    operator            = "above"
    threshold           = 0.75
    threshold_duration  = 300
    threshold_occurrences = "all"
  }

  critical {
    operator            = "above"
    threshold           = 1
    threshold_duration  = 300
    threshold_occurrences = "all"
  }

  fill_option        = "static"
  fill_value         = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "throughput_background_high" {
  for_each = var.apps

  account_id = 1863749
  policy_id  = newrelic_alert_policy.app_policy[each.key].id
  type       = "static"
  name       = "${each.value.name} - Throughput (background) (High)"
  enabled    = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(count(newrelic.timeslice.value), WHERE metricTimesliceName = 'OtherTransaction/all') OR 0 FROM Metric WHERE appName='${each.value.name}' AND metricTimesliceName IN ('OtherTransaction/all', 'Agent/MetricsReported/count') FACET appName"
  }

  critical {
    operator            = "above"
    threshold           = 50000
    threshold_duration  = 300
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator            = "above"
    threshold           = 20000
    threshold_duration  = 300
    threshold_occurrences = "at_least_once"
  }

  fill_option        = "static"
  fill_value         = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "throughput_web_high" {
  for_each = var.apps

  account_id = 1863749
  policy_id  = newrelic_alert_policy.app_policy[each.key].id
  type       = "static"
  name       = "${each.value.name} - Throughput (web) (High)"
  enabled    = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(count(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appName='${each.value.name}'  AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appName"
  }

  critical {
    operator            = "above"
    threshold           = 50000
    threshold_duration  = 300
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator            = "above"
    threshold           = 20000
    threshold_duration  = 300
    threshold_occurrences = "at_least_once"
  }

  fill_option        = "static"
  fill_value         = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "web_transactions_response_time_deviation" {
  for_each = var.apps

  account_id = 1863749
  policy_id  = newrelic_alert_policy.app_policy[each.key].id
  type       = "static"
  name       = "${each.value.name} - Web Transactions Response Time Deviation"
  enabled    = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM Transaction SELECT max(duration) WHERE appName IN ('${each.value.name}') and transactionType = 'Web' and name not like '%superadmin%' and duration > 10 and host NOT LIKE '%worker%' FACET appName, name, path, request.method, http.statusCode, request.headers.host, host"
  }

  critical {
    operator            = "above"
    threshold           = 30
    threshold_duration  = 60
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator            = "above"
    threshold           = 10
    threshold_duration  = 60
    threshold_occurrences = "at_least_once"
  }

  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_notification_channel" "slack_channel" {
  for_each = var.apps

  name            = each.value.slack_channel_name
  type            = "SLACK"
  destination_id  = each.value.slack_destination_id
  product         = "IINT"

  property {
    key   = "channelId"
    value = each.value.slack_channel_id
  }

  property {
    key   = "customDetailsSlack"
    value = each.value.slack_custom_details
  }
}

resource "newrelic_workflow" "workflow" {
  for_each = var.apps

  name                     = "${each.value.name} Workflow"
  muting_rules_handling    = "NOTIFY_ALL_ISSUES"

  issues_filter {
    name     = "${each.value.name} Filter"
    type     = "FILTER"
    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values    = [newrelic_alert_policy.app_policy[each.key].id]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.slack_channel[each.key].id
  }
}



# terraform {
#   required_providers {
#     newrelic = {
#       source = "newrelic/newrelic"
#     }
#   }
# }

# provider "newrelic" {
#   account_id = 1863749
#   api_key    = var.newrelic_api_key
# }

# resource "newrelic_alert_policy" "app_policy" {
#   for_each = var.apps

#   name = "${each.value.name} Alert Policy"
# }

# resource "newrelic_nrql_alert_condition" "response_time_more_than_3_seconds" {
#   for_each = var.apps

#   account_id = 1863749
#   policy_id  = newrelic_alert_policy.app_policy[each.key].id
#   type       = "static"
#   name       = "${each.value.name} - Response time more than 3 seconds"
#   enabled    = false
#   violation_time_limit_seconds = 259200

#   nrql {
#     query = "SELECT max(((totalTime OR duration OR 0) + (queueDuration OR 0) OR 0) ) AS 'Response time' FROM Transaction WHERE appName = '${each.value.name}' AND transactionType = 'Web' FACET `name`"
#   }

#   critical {
#     operator            = "above"
#     threshold           = 5
#     threshold_duration  = 180
#     threshold_occurrences = "all"
#   }

#   warning {
#     operator            = "above"
#     threshold           = 3
#     threshold_duration  = 300
#     threshold_occurrences = "all"
#   }

#   fill_option        = "none"
#   aggregation_window = 60
#   aggregation_method = "event_flow"
#   aggregation_delay  = 120
# }

# resource "newrelic_nrql_alert_condition" "response_time_web_is_above_500ms" {
#   for_each = var.apps

#   account_id = 1863749
#   policy_id  = newrelic_alert_policy.app_policy[each.key].id
#   type       = "static"
#   name       = "${each.value.name} - Response time (web) is above 500ms"
#   enabled    = true
#   violation_time_limit_seconds = 259200

#   nrql {
#     query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appName = '${each.value.name}' AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appName"
#   }

#   warning {
#     operator            = "above"
#     threshold           = 0.75
#     threshold_duration  = 300
#     threshold_occurrences = "all"
#   }

#   critical {
#     operator            = "above"
#     threshold           = 1
#     threshold_duration  = 300
#     threshold_occurrences = "all"
#   }

#   fill_option        = "static"
#   fill_value         = 0
#   aggregation_window = 60
#   aggregation_method = "event_flow"
#   aggregation_delay  = 120
# }

# resource "newrelic_nrql_alert_condition" "throughput_background_high" {
#   for_each = var.apps

#   account_id = 1863749
#   policy_id  = newrelic_alert_policy.app_policy[each.key].id
#   type       = "static"
#   name       = "${each.value.name} - Throughput (background) (High)"
#   enabled    = true
#   violation_time_limit_seconds = 259200

#   nrql {
#     query = "SELECT filter(count(newrelic.timeslice.value), WHERE metricTimesliceName = 'OtherTransaction/all') OR 0 FROM Metric WHERE appName='${each.value.name}' AND metricTimesliceName IN ('OtherTransaction/all', 'Agent/MetricsReported/count') FACET appName"
#   }

#   critical {
#     operator            = "above"
#     threshold           = 50000
#     threshold_duration  = 300
#     threshold_occurrences = "at_least_once"
#   }

#   warning {
#     operator            = "above"
#     threshold           = 20000
#     threshold_duration  = 300
#     threshold_occurrences = "at_least_once"
#   }

#   fill_option        = "static"
#   fill_value         = 0
#   aggregation_window = 60
#   aggregation_method = "event_flow"
#   aggregation_delay  = 120
# }

# resource "newrelic_nrql_alert_condition" "throughput_web_high" {
#   for_each = var.apps

#   account_id = 1863749
#   policy_id  = newrelic_alert_policy.app_policy[each.key].id
#   type       = "static"
#   name       = "${each.value.name} - Throughput (web) (High)"
#   enabled    = true
#   violation_time_limit_seconds = 259200

#   nrql {
#     query = "SELECT filter(count(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appName='${each.value.name}'  AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appName"
#   }

#   critical {
#     operator            = "above"
#     threshold           = 50000
#     threshold_duration  = 300
#     threshold_occurrences = "at_least_once"
#   }

#   warning {
#     operator            = "above"
#     threshold           = 20000
#     threshold_duration  = 300
#     threshold_occurrences = "at_least_once"
#   }

#   fill_option        = "static"
#   fill_value         = 0
#   aggregation_window = 60
#   aggregation_method = "event_flow"
#   aggregation_delay  = 120
# }

# resource "newrelic_nrql_alert_condition" "web_transactions_response_time_deviation" {
#   for_each = var.apps

#   account_id = 1863749
#   policy_id  = newrelic_alert_policy.app_policy[each.key].id
#   type       = "static"
#   name       = "${each.value.name} - Web Transactions Response Time Deviation"
#   enabled    = true
#   violation_time_limit_seconds = 300

#   nrql {
#     query = "FROM Transaction SELECT max(duration) WHERE appName IN ('${each.value.name}') and transactionType = 'Web' and name not like '%superadmin%' and duration > 10 and host NOT LIKE '%worker%' FACET appName, name, path, request.method, http.statusCode, request.headers.host, host"
#   }

#   critical {
#     operator            = "above"
#     threshold           = 30
#     threshold_duration  = 60
#     threshold_occurrences = "at_least_once"
#   }

#   warning {
#     operator            = "above"
#     threshold           = 10
#     threshold_duration  = 60
#     threshold_occurrences = "at_least_once"
#   }

#   fill_option        = "none"
#   aggregation_window = 60
#   aggregation_method = "event_flow"
#   aggregation_delay  = 120
# }

# resource "newrelic_notification_channel" "slack_channel" {
#   name            = var.slack_channel_name
#   type            = "SLACK"
#   destination_id  = var.slack_destination_id
#   product         = "IINT"

#   property {
#     key   = "channelId"
#     value = var.slack_channel_id
#   }

#   property {
#     key   = "customDetailsSlack"
#     value = var.slack_custom_details
#   }
# }

# resource "newrelic_workflow" "workflow" {
#   name                     = var.workflow_name
#   muting_rules_handling    = "NOTIFY_ALL_ISSUES"

#   issues_filter {
#     name     = "Filter-name"
#     type     = "FILTER"
#     predicate {
#       attribute = "labels.policyIds"
#       operator  = "EXACTLY_MATCHES"
#       values    = [for key, policy in newrelic_alert_policy.app_policy : policy.id]
#     }
#   }

#   destination {
#     channel_id = newrelic_notification_channel.slack_channel.id
#   }
# }
