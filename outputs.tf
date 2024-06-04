output "policy_ids" {
  value = [for policy in newrelic_alert_policy.app_policy : policy.id]
}
