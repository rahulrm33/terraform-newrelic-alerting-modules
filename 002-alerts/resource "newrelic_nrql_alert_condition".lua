resource "newrelic_nrql_alert_condition" "hubspot_routes_error_alerts" {
  account_id = 1863749
  policy_id = 4474319
  type = "static"
  name = "Hubspot Routes Error Alerts"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM TransactionError SELECT count(*) WHERE appName = 'SurveySparrowProd' AND transactionName IN ('WebTransaction/Hapi/GET//api/internal/hubspot/{surveyIntegrationId}/contact/properties','WebTransaction/Hapi/GET//api/internal/hubspot/{surveyIntegrationId}/deal/properties','WebTransaction/Hapi/POST//api/internal/hubspot/{surveyIntegrationId}/map','WebTransaction/Hapi/POST//api/internal/hubspot/{surveyIntegrationId}/update-event-configuration','WebTransaction/Hapi/GET//api/internal/hubspot/{surveyIntegrationId}/fetch-deal-stage','WebTransaction/Hapi/GET//api/internal/hubspot/get-user-details') facet transactionName, path, request.uri, error.message,error.class, http.statusCode, request.headers.host"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "appv1marketplace_external_call_avg_response_time" {
  account_id = 1863749
  policy_id = 4507811
  type = "static"
  name = "app-v1-Marketplace External Call Avg Response Time"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT average(apm.service.external.host.duration * 1000 ) FROM Metric WHERE appName IN ('Surveysparrow US EKS', 'Surveysparrow AP EKS', 'Surveysparrow ME EKS') AND (`external.host` = 'marketplace.surveysparrow.com:443')  facet appName"
  }

  critical {
    operator = "above"
    threshold = 50
    threshold_duration = 300
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 35
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "background_job_process_count_static_threshold_alert" {
  account_id = 1863749
  policy_id = 5049840
  type = "static"
  name = "Background Job Process Count - Static Threshold Alert"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM Transaction SELECT count(*) WHERE transactionType = 'Other' WHERE appName IN ('Surveysparrow US EKS', 'Surveysparrow AP EKS') AND name in ('OtherTransaction/Nodejs/sendEmail', 'OtherTransaction/Nodejs/sendSMS') FACET appName, name"
  }

  critical {
    operator = "above"
    threshold = 3000
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 60
}

resource "newrelic_nrql_alert_condition" "background_jobs_count_anomaly" {
  account_id = 1863749
  policy_id = 5049840
  type = "baseline"
  name = "Background Jobs Count Anomaly"
  enabled = false
  violation_time_limit_seconds = 10800

  nrql {
    query = "FROM Transaction SELECT count(*) WHERE transactionType = 'Other' WHERE appName IN ('Surveysparrow US EKS', 'Surveysparrow AP EKS') FACET appName, name"
  }

  critical {
    operator = "above"
    threshold = 30
    threshold_duration = 120
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 60
  baseline_direction = "upper_and_lower"
}

resource "newrelic_nrql_alert_condition" "domain_request_count" {
  account_id = 1863749
  policy_id = 4840204
  type = "static"
  name = "Domain Request Count"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT rate(count(*), 5 minutes) FROM Transaction WHERE appName not in ('salesparrow', 'typesparrow', 'officesparrow', 'signsparrow', 'talksparrow') AND NOT(path LIKE '/n/%/tt-%/login' OR path LIKE '/s/%/tt-%/login' OR path LIKE '/s/%/tt-%/config' OR path LIKE '/n/%/ntt-%/config' OR path LIKE '/s/%/tt-%' OR path LIKE '/n/%/ntt-%' OR path LIKE '/widget/tt-%' OR path LIKE '/nps/widget/ntt-%' OR path LIKE '/api/internal/submissions/visit/%' OR path LIKE '/api/internal/submissions/%' OR path LIKE '/api/internal/submission/%' OR path LIKE '/api/internal/v1/submissions/%' OR path like '/api/internal/v1/submission/%') and transactionType = 'Web' and request.headers.host not like 'api.surveysparrow.com' and request.headers.host not like 'area51.surveysparrow.com' and request.headers.host not like 'area51.surveysparrow.com' and request.headers.host not like 'area51.surveysparrow.com' and request.headers.host not like 'integrations.surveysparrow.com' and request.headers.host not like 'billing.surveysparrow.com' and request.headers.host not like 'bull.surveysparrow.com' and request.headers.host not like 'app-templates.surveysparrow.com' and request.headers.host not like 'sprw.io' AND appName not like 'SparrowApps prod US' and appName not like 'Blink-US' AND request.headers.host not like 'app.surveysparrow.com' facet request.headers.host"
  }

  critical {
    operator = "above"
    threshold = 10000
    threshold_duration = 1800
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 300
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "excel_routes_errors" {
  account_id = 1863749
  policy_id = 4474319
  type = "static"
  name = "Excel Routes Errors"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM TransactionError SELECT count(*) WHERE appName = 'SurveySparrowProd' AND transactionName in ('WebTransaction/Hapi/POST//api/internal/excelonline/{surveyIntegrationId}/properties','WebTransaction/Hapi/GET//api/internal/excelonline/{id}/fetchAllExcel','WebTransaction/Hapi/POST//api/internal/excelonline/{surveyIntegrationId}/sync-excelonline','WebTransaction/Hapi/POST//api/internal/excelonline/{surveyIntegrationId}/fetch-excel-by-short-url') facet transactionName, path, request.uri, error.message,error.class, http.statusCode, request.headers.host"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "excel_routes_errors" {
  account_id = 1863749
  policy_id = 4474319
  type = "static"
  name = "Excel Routes Errors"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM TransactionError SELECT count(*) WHERE appName = 'SurveySparrowProd' AND transactionName in ('WebTransaction/Hapi/POST//api/internal/excelonline/{surveyIntegrationId}/properties','WebTransaction/Hapi/GET//api/internal/excelonline/{id}/fetchAllExcel','WebTransaction/Hapi/POST//api/internal/excelonline/{surveyIntegrationId}/sync-excelonline','WebTransaction/Hapi/POST//api/internal/excelonline/{surveyIntegrationId}/fetch-excel-by-short-url') facet transactionName, path, request.uri, error.message,error.class, http.statusCode, request.headers.host"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "google_sheet_routes_errors" {
  account_id = 1863749
  policy_id = 4474319
  type = "static"
  name = "Google Sheet Routes Errors"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM TransactionError SELECT count(*) WHERE appName = 'SurveySparrowProd' AND transactionName in ('WebTransaction/Hapi/GET//api/internal/google/sheets/{surveyIntegrationId}/getSheets','WebTransaction/Hapi/POST//api/internal/google/sheets/{surveyIntegrationId}/create','WebTransaction/Hapi/POST//api/internal/google/sheets/{surveyIntegrationId}/syncsheet') facet transactionName, path, request.uri, error.message,error.class, http.statusCode, request.headers.host"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "haproxy_rate_limit_breach_alerts" {
  account_id = 1863749
  policy_id = 4840204
  type = "static"
  name = "Haproxy Rate Limit Breach Alerts"
  enabled = true
  violation_time_limit_seconds = 10800

  nrql {
    query = "SELECT rate(count(*), 10 seconds) FROM Transaction WHERE appName not in ('salesparrow', 'typesparrow', 'officesparrow', 'signsparrow', 'talksparrow') AND NOT(path like '%/s/%' or path LIKE '%/widget/%' OR PATH LIKE '%/start/%' OR PATH LIKE '%/n/%' OR PATH LIKE '%/answer/%' OR path like '%/answers/%' OR path like '%/finish/%' OR path like '%/visit/%' or path like '%/widget%/') and transactionType = 'Web' and request.headers.host not IN ('app.surveysparrow.com','api.surveysparrow.com','area51.surveysparrow.com','billing.surveysparrow.com','integrations.surveysparrow.com','testautomation2.surveysparrow.com','testautomation-us.surveysparrow.com','testautomation-360-us.surveysparrow.com','automation-cxenterprise-us.surveysparrow.com','testautomation360.surveysparrow.com','automation-cxenterprise.surveysparrow.com','testautomation-hipaa.surveysparrow.com','testautomation-forgot-password.surveysparrow.com','sprw.io') AND appName not like 'SparrowApps prod US' and appName not like 'Blink-US' AND request.headers.host not like 'app.surveysparrow.com' facet request.headers.host"
  }

  critical {
    operator = "above"
    threshold = 1000
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 30
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "high_number_of_requests_by_host" {
  account_id = 1863749
  policy_id = 4838601
  type = "static"
  name = "High Number of Requests by Host"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM Transaction SELECT count(*) WHERE appName = 'Surveysparrow US EKS' AND transactionType = 'Web' AND request.headers.host not like 'sprw.io' FACET request.headers.host"
  }

  critical {
    operator = "above"
    threshold = 3000
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 60
}

resource "newrelic_nrql_alert_condition" "inactive_cron_job_alerts" {
  account_id = 1863749
  policy_id = 5036428
  type = "static"
  name = "Inactive Cron Job Alerts"
  enabled = true
  violation_time_limit_seconds = 10800

  nrql {
    query = "FROM Transaction SELECT count(*) WHERE name IN ('OtherTransaction/Nodejs/{ScheduleCron}', 'OtherTransaction/Nodejs/{NPSScheduleCron}', 'OtherTransaction/Nodejs/{DelayedCron}', 'OtherTransaction/Nodejs/{NPSDelayedCron}', 'OtherTransaction/Nodejs/{NpsReminderCron}') AND appName = 'Surveysparrow US EKS' FACET name"
  }

  critical {
    operator = "equals"
    threshold = 0
    threshold_duration = 1800
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 1800
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "salesforce_routes_errors" {
  account_id = 1863749
  policy_id = 4474319
  type = "static"
  name = "Salesforce Routes Errors"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM TransactionError SELECT count(*) WHERE appName = 'SurveySparrowProd' AND transactionName in ('WebTransaction/Hapi/GET//api/internal/salesforce/{surveyIntegrationId}/getObjects','WebTransaction/Hapi/GET//api/internal/salesforce/{surveyIntegrationId}/sObjects/{sObjectName}/fields','WebTransaction/Hapi/PUT//api/internal/salesforce/{surveyIntegrationId}/map','WebTransaction/Hapi/PUT//api/internal/salesforce/{surveyIntegrationId}/update-event-configuration') facet transactionName, path, request.uri, error.message,error.class, http.statusCode, request.headers.host"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}


resource "newrelic_nrql_alert_condition" "signup_errors" {
  account_id = 1863749
  policy_id = 4160504
  type = "static"
  name = "Signup Errors"
  enabled = false
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM Transaction SELECT count(*) WHERE appName = 'Surveysparrow US EKS' and name = 'WebTransaction/Hapi/POST//api/internal/signup' AND http.statusCode > '400' facet http.statusCode, http.statusText"
  }

  warning {
    operator = "above"
    threshold = 1
    threshold_duration = 900
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "response_time_more_than_3_seconds" {
  account_id = 1863749
  policy_id = 2760857
  type = "static"
  name = "Response time more than 3 seconds"
  enabled = false
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT max(((totalTime OR duration OR 0) + (queueDuration OR 0) OR 0) ) AS 'Response time' FROM Transaction WHERE appName = 'Surveysparrow US EKS' AND transactionType = 'Web'  FACET `name`"
  }

  critical {
    operator = "above"
    threshold = 5
    threshold_duration = 180
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 3
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "slack_routes_errors" {
  account_id = 1863749
  policy_id = 4474319
  type = "static"
  name = "Slack Routes Errors"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM TransactionError SELECT count(*) WHERE appName = 'SurveySparrowProd' AND transactionName in ('WebTransaction/Hapi/GET//api/internal/slack/{surveyIntegrationId}/getProperties','WebTransaction/Hapi/GET//api/internal/slack/workflow/{surveyId}/getProperties','WebTransaction/Hapi/GET//api/internal/slack/reputation/workflow/getProperties','WebTransaction/Hapi/POST//api/internal/slack/{surveyIntegrationId}/saveProperties','WebTransaction/Hapi/POST//api/internal/slack/standup/immediate','WebTransaction/Hapi/POST//api/internal/slack/action','WebTransaction/Hapi/POST//api/internal/slack/event') facet transactionName, path, request.uri, error.message,error.class, http.statusCode, request.headers.host"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}


resource "newrelic_nrql_alert_condition" "useragent_count" {
  account_id = 1863749
  policy_id = 3438665
  type = "static"
  name = "UserAgent Count"
  enabled = false
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT count(*) FROM Transaction WHERE appName IN ('Surveysparrow US EKS', 'Surveysparrow AP EKS', 'Surveysparrow ME EKS') AND transactionType = 'Web' FACET  appName, request.headers.userAgent "
  }

  critical {
    operator = "above"
    threshold = 5000
    threshold_duration = 180
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 2500
    threshold_duration = 180
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "twillio_verify_api_usage_alert" {
  account_id = 1863749
  policy_id = 3438665
  type = "static"
  name = "Twillio Verify API Usage Alert"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT rate(count(apm.service.external.host.duration), 1 minute) FROM Metric WHERE appName in ('Surveysparrow US EKS', 'Surveysparrow ME EKS', 'Surveysparrow AP EKS') AND (`external.host` = 'verify.twilio.com:443') FACET appName, `external.host`"
  }

  critical {
    operator = "above"
    threshold = 20
    threshold_duration = 60
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 15
    threshold_duration = 120
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "ss_email_service_abuse" {
  account_id = 1863749
  policy_id = 5110325
  type = "static"
  name = "SS email service abuse"
  enabled = true
  violation_time_limit_seconds = 3600

  nrql {
    query = "SELECT count(*) FROM Transaction WHERE appName NOT IN('salesparrow') AND (request.uri LIKE '%users/verify' OR request.uri LIKE '%/channels/portal/new' OR request.uri LIKE '%/test-email' OR name = 'WebTransaction/Hapi/POST//api/internal/submission/{submission_id}/finish/{token}/email' OR request.uri LIKE '%/workflows%' ) FACET appName, request.headers.host,name,  path"
  }

  critical {
    operator = "above"
    threshold = 10
    threshold_duration = 600
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 600
  aggregation_method = "event_flow"
  aggregation_delay = 2
}

resource "newrelic_nrql_alert_condition" "survey_share_load" {
  account_id = 1863749
  policy_id = 4417610
  type = "static"
  name = "Survey Share Load"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM Transaction SELECT count(*) WHERE appName = 'Surveysparrow US EKS' and (path like '%/n/%' OR path like '%/s/%') and path not like '%config' and path NOT LIKE '%start%' facet path, request.headers.host"
  }

  critical {
    operator = "above"
    threshold = 3000
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator = "above"
    threshold = 2000
    threshold_duration = 180
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "sqsmessagecountalertsubmissionsync" {
  account_id = 1863749
  policy_id = 4556843
  type = "static"
  name = "SQS-message-count-alert-Submission-sync"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT sum(`aws.sqs.ApproximateNumberOfMessagesVisible`) FROM Metric WHERE newrelic.cloudIntegrations.providerAccountId = '126529' and aws.sqs.QueueName in ('ss-submission-sync','ss-submission-sync-ap','ss-submission-sync-eu')"
  }

  critical {
    operator = "above"
    threshold = 500
    threshold_duration = 600
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 200
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 300
  aggregation_method = "event_flow"
  aggregation_delay = 300
  slide_by = 30
}

resource "newrelic_nrql_alert_condition" "ss_uptime_alerts" {
  account_id = 1863749
  policy_id = 4844808
  type = "static"
  name = "SS - Uptime Alerts"
  enabled = true
  violation_time_limit_seconds = 10800

  nrql {
    query = "SELECT filter(count(*), WHERE result = 'FAILED') AS 'Failures' FROM SyntheticCheck WHERE entityGuid IN ('MTg2Mzc0OXxTWU5USHxNT05JVE9SfDYwOTYxNjBmLWQ1ZGMtNGUyZi1hNDY0LTQ3Yjg4MThmZmNlNw') FACET monitorName, locationLabel, location, result, error"
  }

  critical {
    operator = "above_or_equals"
    threshold = 1
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 0
}

resource "newrelic_nrql_alert_condition" "high_response_time" {
  account_id = 1863749
  policy_id = 5346959
  type = "static"
  name = "High Response Time"

  description = <<-EOT
  Alert when response time is high
  EOT

  runbook_url = "https://example.com/runbook"
  enabled = true
  violation_time_limit_seconds = 3600

  nrql {
    query = "SELECT average(duration) FROM Transaction"
  }

  critical {
    operator = "above"
    threshold = 2
    threshold_duration = 600
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 1
    threshold_duration = 600
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}


resource "newrelic_nrql_alert_condition" "high_response_time_web_surveysparrow_us_eks" {
  account_id = 1863749
  policy_id = 5340992
  type = "static"
  name = "High Response Time (Web) - Surveysparrow US EKS"
  runbook_url = "https://www.example.com"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appId IN (543278964) AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appId"
  }

  critical {
    operator = "above"
    threshold = 5
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "static"
  fill_value = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "503_errors_from_lb" {
  account_id = 1863749
  policy_id = 4363086
  type = "static"
  name = "503 errors from LB"

  description = <<-EOT
  503 erros
  EOT

  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM LoadBalancerSample SELECT max(provider.httpCodeTarget5XXCount.Sum) FACET awsRegion"
  }

  critical {
    operator = "above"
    threshold = 10
    threshold_duration = 180
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 5
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "alert_exceededgraceperiod" {
  account_id = 1863749
  policy_id = 4956667
  type = "static"
  name = "Alert - ExceededGracePeriod"
  enabled = true
  violation_time_limit_seconds = 3600

  nrql {
    query = "SELECT count(*) FROM InfrastructureEvent 
    WHERE eventName = 'ExceededGracePeriod' 
    AND event.involvedObject.namespace NOT IN ('newrelic', 'kube-system', 'karpenter', 'px-operator') 
    FACET event.involvedObject.name, event.involvedObject.kind, event.message, event.involvedObject.namespace, event.source.host, clusterName 
    "
  }

  critical {
    operator = "above"
    threshold = 1
    threshold_duration = 3600
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}
resource "newrelic_nrql_alert_condition" "alert_failedkillpod" {
  account_id = 1863749
  policy_id = 4956667
  type = "static"
  name = "Alert - FailedKillPod"
  enabled = true
  violation_time_limit_seconds = 3600

  nrql {
    query = "SELECT count(*) FROM InfrastructureEvent 
    WHERE eventName = 'FailedKillPod' 
    AND event.involvedObject.namespace NOT IN ('newrelic', 'kube-system', 'karpenter', 'px-operator') 
    FACET event.involvedObject.name, event.involvedObject.kind, event.message, event.involvedObject.namespace, event.source.host, clusterName 
    "
  }

  critical {
    operator = "above"
    threshold = 1
    threshold_duration = 3600
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "aplong_running_queries" {
  account_id = 1863749
  policy_id = 4555212
  type = "static"
  name = "AP-Long Running Queries"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM  SqlTrace SELECT  max(maxCallTime) WHERE  applicationIds = ':550922626:' AND path NOT LIKE '%superadmin%' FACET databaseMetricName, path, uri, sql"
  }

  critical {
    operator = "above_or_equals"
    threshold = 60
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator = "above_or_equals"
    threshold = 30
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 30
  aggregation_method = "event_timer"
  aggregation_timer = 300
}



resource "newrelic_nrql_alert_condition" "aws_elastic_search_cpu_utilization" {
  account_id = 1863749
  policy_id = 3408276
  type = "static"
  name = "AWS - Elastic Search CPU Utilization"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT max(`aws.es.CPUUtilization.byCluster`) FROM Metric WHERE (`metricName` = 'aws.es.CPUUtilization.byCluster') FACET entity.guid, entity.name"
  }

  warning {
    operator = "above"
    threshold = 40
    threshold_duration = 300
    threshold_occurrences = "all"
  }

  critical {
    operator = "above"
    threshold = 50
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer = 30
}





resource "newrelic_nrql_alert_condition" "child_process_cpu_usage" {
  account_id = 1863749
  policy_id = 3859803
  type = "static"
  name = "Child Process - CPU Usage"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM ProcessSample SELECT max(cpuPercent) FACET commandLine, hostname, processId WHERE commandLine LIKE '%bull%' AND apmApplicationNames = '|SurveySparrow AP|'"
  }

  critical {
    operator = "above"
    threshold = 80
    threshold_duration = 120
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 50
    threshold_duration = 120
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "child_process_cpu_usage" {
  account_id = 1863749
  policy_id = 3856384
  type = "static"
  name = "Child Process - CPU Usage"
  enabled = false
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM ProcessSample SELECT max(cpuPercent) FACET commandLine, hostname, processId WHERE commandLine LIKE '%bull%' AND apmApplicationNames = '|Surveysparrow US EKS|'"
  }

  critical {
    operator = "above"
    threshold = 80
    threshold_duration = 120
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 50
    threshold_duration = 120
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "child_process_memory_usage" {
  account_id = 1863749
  policy_id = 3859803
  type = "static"
  name = "Child Process - Memory Usage"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM ProcessSample SELECT max(memoryResidentSizeBytes) FACET commandLine, hostname, processId WHERE commandLine LIKE '%bull%' AND apmApplicationNames = '|SurveySparrowProd|'"
  }

  critical {
    operator = "above"
    threshold = 3000000000
    threshold_duration = 120
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 2000000000
    threshold_duration = 120
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "child_process_memory_usage" {
  account_id = 1863749
  policy_id = 3858506
  type = "static"
  name = "Child Process - Memory Usage"
  enabled = false
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM ProcessSample SELECT max(memoryResidentSizeBytes) FACET commandLine, hostname, processId WHERE commandLine LIKE '%bull%' AND apmApplicationNames = '|Surveysparrow US EKS|'"
  }

  critical {
    operator = "above"
    threshold = 1500000000
    threshold_duration = 120
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 800000000
    threshold_duration = 120
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "container_cpu_usage_is_too_high" {
  account_id = 1863749
  policy_id = 4577551
  type = "static"
  name = "Container CPU Usage % is too high"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT `average`(`k8s.container.cpuCoresUtilization`) FROM Metric WHERE metricName IN ('k8s.container.cpuCoresUtilization') FACET entity.guid"
  }

  critical {
    operator = "above"
    threshold = 95
    threshold_duration = 300
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 90
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 60
}

resource "newrelic_nrql_alert_condition" "container_is_running_out_of_space" {
  account_id = 1863749
  policy_id = 4577551
  type = "static"
  name = "Container is running out of space"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT `average`(`k8s.container.fsUsedPercent`) FROM Metric WHERE metricName IN ('k8s.container.fsUsedPercent') FACET entity.guid"
  }

  critical {
    operator = "above"
    threshold = 90
    threshold_duration = 300
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 75
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 60
}

resource "newrelic_nrql_alert_condition" "container_memory_usage_is_too_high" {
  account_id = 1863749
  policy_id = 4577551
  type = "static"
  name = "Container Memory Usage % is too high"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT `average`(`k8s.container.memoryWorkingSetUtilization`) FROM Metric WHERE metricName IN ('k8s.container.memoryWorkingSetUtilization') FACET entity.guid"
  }

  critical {
    operator = "above"
    threshold = 95
    threshold_duration = 300
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 85
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 60
}



resource "newrelic_nrql_alert_condition" "eksno_active_containers_alert" {
  account_id = 1863749
  policy_id = 4417578
  type = "static"
  name = "EKS-No Active Containers Alert"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM K8sContainerSample SELECT count(*) FACET (cases(WHERE containerName like '%application%' AS 'application', WHERE containerName LIKE '%api%' AS 'api', WHERE containerName like '%eui%' AS 'eui', WHERE containerName LIKE '%reports%' AS 'reports', WHERE containerName LIKE '%generic%' AS 'generic', WHERE containerName LIKE '%hulk%' AS 'hulk', WHERE containerName like '%notification%' as 'notification', WHERE containerName like '%cron%' as 'cron')), apmApplicationNames"
  }

  critical {
    operator = "equals"
    threshold = 0
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "employee360invites_api_spam_alert" {
  account_id = 1863749
  policy_id = 5001040
  type = "static"
  name = "Employee360-invites api Spam Alert"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Transaction SELECT count(*) WHERE name = 'WebTransaction/Hapi/PUT//api/internal/employee360/{surveyId}/invites' FACET request.headers.host"
  }

  critical {
    operator = "above"
    threshold = 50
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "etcd_open_file_descriptors" {
  account_id = 1863749
  policy_id = 4577551
  type = "static"
  name = "ETCD open file descriptors"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT `average`(`k8s.etcd.process.processFdsUtilization`) FROM Metric WHERE metricName IN ('k8s.etcd.process.processFdsUtilization') FACET entity.guid"
  }

  critical {
    operator = "above"
    threshold = 90
    threshold_duration = 300
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 75
    threshold_duration = 180
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 60
}

resource "newrelic_nrql_alert_condition" "heimdall_connect_reset_alert" {
  account_id = 1863749
  policy_id = 3472094
  type = "static"
  name = "Heimdall COnnect reset alert"
  enabled = false
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT count(*) FROM Log WHERE`service_name` = 'Heimdall Staging' OR `serviceName` = 'Heimdall Staging' OR `service.name` = 'Heimdall Staging' OR `entity.name` = 'Heimdall Staging' AND message LIKE '%connection reset%'"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 30
  aggregation_method = "event_flow"
  aggregation_delay = 10
}

resource "newrelic_nrql_alert_condition" "high_error_rate" {
  account_id = 1863749
  policy_id = 5346959
  type = "static"
  name = "High Error Rate"

  description = <<-EOT
  Alert when error rate is high
  EOT

  runbook_url = "https://example.com/runbook"
  enabled = true
  violation_time_limit_seconds = 3600

  nrql {
    query = "SELECT count(*) FROM Transaction WHERE error IS true"
  }

  critical {
    operator = "above"
    threshold = 10
    threshold_duration = 600
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 5
    threshold_duration = 600
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}








resource "newrelic_nrql_alert_condition" "instances_cpu_utilization_alert" {
  account_id = 1863749
  policy_id = 4417578
  type = "static"
  name = "Instances CPU Utilization Alert"
  enabled = true
  violation_time_limit_seconds = 600

  nrql {
    query = "FROM SystemSample SELECT max(cpuPercent) WHERE apmApplicationNames = '|SurveySparrowProd|' FACET (cases(WHERE hostname like '%application%' AS 'Application', WHERE hostname like 'api%' AS 'API', WHERE hostname LIKE 'widget%' AS 'Widget', WHERE hostname LIKE 'reports%' as 'Reports'))"
  }

  critical {
    operator = "above"
    threshold = 85
    threshold_duration = 120
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 75
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "k8snodediskpressure" {
  account_id = 1863749
  policy_id = 4956667
  type = "static"
  name = "k8s_node_disk_pressure"

  description = <<-EOT
  Alert when Node Disk Pressure Condition is hit
  EOT

  runbook_url = "https://www.example.com"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM K8sNodeSample SELECT max(condition.DiskPressure) FACET nodeName, label.Name, clusterName"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "k8snodememorypressure" {
  account_id = 1863749
  policy_id = 4956667
  type = "static"
  name = "k8s_node_memory_pressure"

  description = <<-EOT
  Alert when Node Memory Pressure Condition is hit
  EOT

  runbook_url = "https://www.example.com"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM K8sNodeSample SELECT max(condition.MemoryPressure) FACET nodeName, label.Name, clusterName"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "k8snodereceivedbytes" {
  account_id = 1863749
  policy_id = 4956667
  type = "static"
  name = "k8s_node_received_bytes"

  description = <<-EOT
  Alert when a huge volume of Data is received by the nodes
  EOT

  runbook_url = "https://www.example.com"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM K8sNodeSample SELECT max(net.rxBytesPerSecond) FACET nodeName, label.Name,  clusterName"
  }

  critical {
    operator = "above"
    threshold = 100000000
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "k8snodetransmittedbytes" {
  account_id = 1863749
  policy_id = 4956667
  type = "static"
  name = "k8s_node_transmitted_bytes"

  description = <<-EOT
  Alert when a huge volume of Data is transmitted by the nodes
  EOT

  runbook_url = "https://www.example.com"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM K8sNodeSample SELECT max(net.txBytesPerSecond) FACET nodeName, label.Name, clusterName"
  }

  critical {
    operator = "above"
    threshold = 100000000
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "k8sreplicacountdrop" {
  account_id = 1863749
  policy_id = 4956667
  type = "static"
  name = "k8s_replica_count_drop"

  description = <<-EOT
  Desired Number of Replicas vs. Running number of Replicas
  EOT

  runbook_url = "https://www.example.com"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM K8sDeploymentSample SELECT max(podsDesired) - max(podsAvailable) WHERE namespaceName = 'surveysparrow' FACET deploymentName, namespaceName, clusterName"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "loadtest_uptime_monitor" {
  account_id = 1863749
  policy_id = 4906015
  type = "static"
  name = "Loadtest Uptime monitor"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "SELECT latest(result) FROM SyntheticCheck WHERE monitorId IN ('2df813a4-fb87-43ff-8b41-9c83178056c6') FACET entityGuid, location, locationLabel"
  }

  critical {
    operator = "above_or_equals"
    threshold = 1
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 30
  aggregation_method = "event_timer"
  aggregation_timer = 5
}

resource "newrelic_nrql_alert_condition" "melong_running_queries" {
  account_id = 1863749
  policy_id = 4555226
  type = "static"
  name = "ME-Long Running Queries"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM  SqlTrace SELECT  max(maxCallTime) WHERE  applicationIds = ':548925718:' AND path NOT LIKE '%superadmin%' FACET databaseMetricName, path, uri, sql"
  }

  critical {
    operator = "above_or_equals"
    threshold = 60
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator = "above_or_equals"
    threshold = 30
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 30
  aggregation_method = "event_timer"
  aggregation_timer = 300
}

resource "newrelic_nrql_alert_condition" "orphan_child_process" {
  account_id = 1863749
  policy_id = 3517984
  type = "static"
  name = "Orphan Child process"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "SELECT count(*) FROM ProcessSample FACET  hostname, apmApplicationNames WHERE commandLine  LIKE  '%bull%' AND parentProcessId=1"
  }

  warning {
    operator = "above"
    threshold = 0
    threshold_duration = 1800
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "pageload_duration_alert" {
  account_id = 1863749
  policy_id = 4449454
  type = "static"
  name = "PageLoad Duration Alert"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM PageView SELECT max(duration) FACET pageUrl, countryCode, city"
  }

  critical {
    operator = "above"
    threshold = 180
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator = "above"
    threshold = 120
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "pod_is_not_ready" {
  account_id = 1863749
  policy_id = 4577551
  type = "static"
  name = "Pod is not ready"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT `average`(`k8s.pod.isReady`) FROM Metric WHERE metricName IN ('k8s.pod.isReady') AND (NOT ((`k8s.status` = 'Succeeded')) AND NOT ((`k8s.status` = 'Failed'))) FACET entity.guid"
  }

  critical {
    operator = "equals"
    threshold = 0
    threshold_duration = 600
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 60
}

resource "newrelic_nrql_alert_condition" "pod_was_unable_to_be_scheduled" {
  account_id = 1863749
  policy_id = 4577551
  type = "static"
  name = "Pod was unable to be scheduled"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT `average`(`k8s.pod.isScheduled`) FROM Metric WHERE metricName IN ('k8s.pod.isScheduled') FACET entity.guid"
  }

  critical {
    operator = "equals"
    threshold = 0
    threshold_duration = 420
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 60
}

resource "newrelic_nrql_alert_condition" "rds_aurora_replica_lag" {
  account_id = 1863749
  policy_id = 4389061
  type = "static"
  name = "RDS Aurora Replica Lag"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.rds.AuroraReplicaLag) facet aws.rds.DBInstanceIdentifier"
  }

  critical {
    operator = "above"
    threshold = 10000
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator = "above"
    threshold = 5000
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "rds_connections_usage" {
  account_id = 1863749
  policy_id = 3408276
  type = "static"
  name = "RDS connections Usage"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT average(`aws.rds.DatabaseConnections`) as 'connections in use' FROM Metric WHERE newrelic.cloudIntegrations.providerAccountId = '126529' FACET entity.name"
  }

  critical {
    operator = "above_or_equals"
    threshold = 2500
    threshold_duration = 120
    threshold_occurrences = "all"
  }

  warning {
    operator = "above_or_equals"
    threshold = 2000
    threshold_duration = 120
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "rds_cpu_usage" {
  account_id = 1863749
  policy_id = 4607579
  type = "static"
  name = "RDS CPU usage "
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.rds.CPUUtilization) facet aws.rds.DBInstanceIdentifier"
  }

  critical {
    operator = "above"
    threshold = 89
    threshold_duration = 180
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 180
  aggregation_method = "event_flow"
  aggregation_delay = 300
  slide_by = 30
}

resource "newrelic_nrql_alert_condition" "rds_cpu_usage_microservice" {
  account_id = 1863749
  policy_id = 3955468
  type = "static"
  name = "RDS CPU Usage - Microservice"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT max(`aws.rds.CPUUtilization`) as 'CPU Utilization' FROM Metric WHERE  aws.rds.endpoint like '%micro%' facet entity.name "
  }

  critical {
    operator = "above"
    threshold = 50
    threshold_duration = 60
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 40
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "rds_cpu_utilization" {
  account_id = 1863749
  policy_id = 4389061
  type = "static"
  name = "RDS CPU Utilization"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.rds.CPUUtilization) facet aws.rds.DBInstanceIdentifier"
  }

  critical {
    operator = "above"
    threshold = 85
    threshold_duration = 180
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator = "above"
    threshold = 75
    threshold_duration = 180
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 300
}

resource "newrelic_nrql_alert_condition" "rds_deadlocks" {
  account_id = 1863749
  policy_id = 4389061
  type = "static"
  name = "RDS Deadlocks"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.rds.Deadlocks) facet aws.rds.DBInstanceIdentifier"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "rds_disk_queue_depth" {
  account_id = 1863749
  policy_id = 4389061
  type = "static"
  name = "RDS Disk Queue Depth"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.rds.DiskQueueDepth) facet aws.rds.DBInstanceIdentifier"
  }

  critical {
    operator = "above"
    threshold = 10
    threshold_duration = 180
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 5
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "rds_read_latency" {
  account_id = 1863749
  policy_id = 4389061
  type = "static"
  name = "RDS Read Latency"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.rds.ReadLatency) facet aws.rds.DBInstanceIdentifier"
  }

  critical {
    operator = "above"
    threshold = 50
    threshold_duration = 120
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 20
    threshold_duration = 120
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "rds_write_latency" {
  account_id = 1863749
  policy_id = 4389061
  type = "static"
  name = "RDS Write Latency"
  enabled = false
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.rds.WriteLatency) facet aws.rds.DBInstanceIdentifier"
  }

  critical {
    operator = "above"
    threshold = 25
    threshold_duration = 120
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 10
    threshold_duration = 120
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "redis_engine_cpu_utilization" {
  account_id = 1863749
  policy_id = 4363581
  type = "static"
  name = "Redis - Engine CPU Utilization"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT max(`aws.elasticache.EngineCPUUtilization.byRedisCluster`) FROM Metric WHERE newrelic.cloudIntegrations.providerAccountId = '126529' FACET `aws.elasticache.CacheClusterId`"
  }

  critical {
    operator = "above"
    threshold = 79
    threshold_duration = 60
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 48
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "redis_evictions" {
  account_id = 1863749
  policy_id = 4363581
  type = "static"
  name = "Redis - Evictions"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.elasticache.Evictions.byRedisNode) WHERE newrelic.cloudIntegrations.providerAccountId = '126529' FACET aws.elasticache.CacheClusterId"
  }

  critical {
    operator = "above_or_equals"
    threshold = 1
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "redis_memory_utilization" {
  account_id = 1863749
  policy_id = 4363581
  type = "static"
  name = "Redis - Memory Utilization"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.elasticache.DatabaseMemoryUsagePercentage.byRedisCluster) WHERE newrelic.cloudIntegrations.providerAccountId = '126529' FACET aws.elasticache.CacheClusterId"
  }

  critical {
    operator = "above"
    threshold = 79
    threshold_duration = 60
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 48
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "redis_networkbytesin" {
  account_id = 1863749
  policy_id = 4363581
  type = "static"
  name = "Redis - NetworkBytesIn"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.elasticache.NetworkBytesIn.byRedisCluster) WHERE newrelic.cloudIntegrations.providerAccountId = '126529' FACET aws.elasticache.CacheClusterId"
  }

  warning {
    operator = "above"
    threshold = 3000000000
    threshold_duration = 60
    threshold_occurrences = "all"
  }

  critical {
    operator = "above"
    threshold = 4000000000
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "redis_networkbytesout" {
  account_id = 1863749
  policy_id = 4363581
  type = "static"
  name = "Redis - NetworkBytesOut"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.elasticache.NetworkBytesOut.byRedisCluster) WHERE newrelic.cloudIntegrations.providerAccountId = '126529' FACET aws.elasticache.CacheClusterId"
  }

  critical {
    operator = "above"
    threshold = 4000000000
    threshold_duration = 60
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 3000000000
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "redis_replication_lag" {
  account_id = 1863749
  policy_id = 4363581
  type = "static"
  name = "Redis - Replication Lag"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.elasticache.ReplicationLag) WHERE newrelic.cloudIntegrations.providerAccountId = '126529' FACET aws.elasticache.CacheClusterId"
  }

  critical {
    operator = "above"
    threshold = 0.2
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "redis_cluster_cpu_utilization" {
  account_id = 1863749
  policy_id = 4363086
  type = "static"
  name = "Redis Cluster - CPU Utilization"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.elasticache.CPUUtilization.byRedisCluster) WHERE newrelic.cloudIntegrations.providerAccountId = '126529' FACET aws.elasticache.CacheClusterId"
  }

  critical {
    operator = "above"
    threshold = 90
    threshold_duration = 60
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 75
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "redis_cpu_usage" {
  account_id = 1863749
  policy_id = 3859803
  type = "static"
  name = "Redis CPU Usage"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT  max(aws.elasticache.CPUUtilization.byRedisCluster) WHERE entity.name LIKE '%ap%' FACET entity.name"
  }

  warning {
    operator = "above"
    threshold = 25
    threshold_duration = 300
    threshold_occurrences = "all"
  }

  critical {
    operator = "above"
    threshold = 40
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "redis_cpu_utilization" {
  account_id = 1863749
  policy_id = 4363581
  type = "static"
  name = "Redis CPU Utilization"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM Metric SELECT max(aws.elasticache.CPUUtilization.byRedisCluster) WHERE newrelic.cloudIntegrations.providerAccountId = '126529' FACET aws.elasticache.CacheClusterId"
  }

  critical {
    operator = "above"
    threshold = 75
    threshold_duration = 60
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 45
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "replicaset_doesnt_have_desired_amount_of_pods" {
  account_id = 1863749
  policy_id = 4577551
  type = "static"
  name = "ReplicaSet doesn't have desired amount of pods"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT `average`(`k8s.replicaset.podsMissing`) FROM Metric WHERE metricName IN ('k8s.replicaset.podsMissing') FACET entity.guid"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 60
}

resource "newrelic_nrql_alert_condition" "response_time_web_high" {
  account_id = 1863749
  policy_id = 3859803
  type = "static"
  name = "Response time (web) (High)"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appId IN (530079645) AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appId"
  }

  warning {
    operator = "above"
    threshold = 0.75
    threshold_duration = 300
    threshold_occurrences = "all"
  }

  critical {
    operator = "above"
    threshold = 1
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "static"
  fill_value = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "response_time_web_is_above_500ms" {
  account_id = 1863749
  policy_id = 358672
  type = "static"
  name = "Response time (web) is above 500ms"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appId IN (41990667) AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appId"
  }

  warning {
    operator = "above"
    threshold = 0.75
    threshold_duration = 300
    threshold_occurrences = "all"
  }

  critical {
    operator = "above"
    threshold = 1
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "static"
  fill_value = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}


resource "newrelic_nrql_alert_condition" "service_levels_default_alert_condition" {
  account_id = 1863749
  policy_id = 4537320
  type = "static"
  name = "Service Levels default alert condition"
  enabled = true
  violation_time_limit_seconds = 2592000

  nrql {
    query = "FROM ServiceLevelSnapshot SELECT latest(remainingErrorBudget) as 'Remaining error budget' FACET entity.guid"
  }

  warning {
    operator = "below"
    threshold = 25
    threshold_duration = 240
    threshold_occurrences = "at_least_once"
  }

  critical {
    operator = "below_or_equals"
    threshold = 0
    threshold_duration = 240
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 480
  aggregation_method = "event_flow"
  aggregation_delay = 120
  slide_by = 240
  expiration_duration = 1800
  open_violation_on_expiration = false
  close_violations_on_expiration = true
}

resource "newrelic_nrql_alert_condition" "shield_pod_count_alert" {
  account_id = 1863749
  policy_id = 4354236
  type = "static"
  name = "Shield Pod count alert"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT count(newrelic.timeslice.value) AS `Instance/Reporting` FROM Metric WHERE metricTimesliceName = 'Instance/Reporting' AND `entity.guid` = 'MTg2Mzc0OXxBUE18QVBQTElDQVRJT058NTkwODk4NTk5'"
  }

  critical {
    operator = "above"
    threshold = 8
    threshold_duration = 60
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 6
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 30
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "shield_throttle_response_time_alert" {
  account_id = 1863749
  policy_id = 4354079
  type = "static"
  name = "Shield throttle response time alert"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT average(apm.service.transaction.duration * 1000)  as 'Response time' FROM Metric WHERE (entity.guid = 'MTg2Mzc0OXxBUE18QVBQTElDQVRJT058NTkwODk4NTk5') AND (transactionName = 'WebTransaction/Go/throttler.v1.Throttler/Throttle')"
  }

  critical {
    operator = "above"
    threshold = 8
    threshold_duration = 60
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 5
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 30
  aggregation_method = "event_flow"
  aggregation_delay = 120
  expiration_duration = 600
  open_violation_on_expiration = false
  close_violations_on_expiration = true
}

resource "newrelic_nrql_alert_condition" "shiled_cpu_usage_alert" {
  account_id = 1863749
  policy_id = 4354184
  type = "static"
  name = "Shiled CPU usage alert"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT average(newrelic.timeslice.value) * 1000 AS `CPU/System/Utilization` FROM Metric WHERE metricTimesliceName = 'CPU/System/Utilization' AND `entity.guid` = 'MTg2Mzc0OXxBUE18QVBQTElDQVRJT058NTkwODk4NTk5'"
  }

  critical {
    operator = "above"
    threshold = 80
    threshold_duration = 60
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 60
    threshold_duration = 60
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 30
  aggregation_method = "event_flow"
  aggregation_delay = 60
}


resource "newrelic_nrql_alert_condition" "ss_email_queue_errors" {
  account_id = 1863749
  policy_id = 5086064
  type = "static"
  name = "SS email Queue Errors"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT count(*) FROM EmailQueueFailedEvent FACET errorMessage"
  }

  critical {
    operator = "above"
    threshold = 10
    threshold_duration = 600
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 600
  aggregation_method = "event_flow"
  aggregation_delay = 2
}



resource "newrelic_nrql_alert_condition" "ss_email_share_queue_failed_job_alert" {
  account_id = 1863749
  policy_id = 5086064
  type = "static"
  name = "SS email share queue failed job alert"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT count(*) FROM EmailShareQueueFailedEvent FACET errorMessage"
  }

  critical {
    operator = "above"
    threshold = 10
    threshold_duration = 600
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 600
  aggregation_method = "event_flow"
  aggregation_delay = 2
}

resource "newrelic_nrql_alert_condition" "ssloadtestuptime2" {
  account_id = 1863749
  policy_id = 4906015
  type = "static"
  name = "SS-Loadtest-Uptime-2"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT latest(result) FROM SyntheticCheck WHERE monitorId IN ('98dc4d11-a057-4fbd-99e6-d97d028e8243') FACET entityGuid, location, locationLabel"
  }

  critical {
    operator = "above_or_equals"
    threshold = 1
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 30
  aggregation_method = "event_timer"
  aggregation_timer = 5
}

resource "newrelic_nrql_alert_condition" "ssuptimeapalert" {
  account_id = 1863749
  policy_id = 4844808
  type = "static"
  name = "SS-Uptime-AP-Alert"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(count(*), WHERE result = 'FAILED') AS 'Failures' FROM SyntheticCheck WHERE entityGuid IN ('MTg2Mzc0OXxTWU5USHxNT05JVE9SfDE3NmNhYzgxLTQ2M2MtNGFmZS1hNDM2LWUyYjYzMWRmMjYzZA') FACET monitorName, locationLabel, location, result, error"
  }

  critical {
    operator = "above_or_equals"
    threshold = 1
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 0
}

resource "newrelic_nrql_alert_condition" "ssuptimeeu" {
  account_id = 1863749
  policy_id = 4844808
  type = "static"
  name = "SS-Uptime-EU"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(count(*), WHERE result = 'FAILED') AS 'Failures' FROM SyntheticCheck WHERE entityGuid IN ('MTg2Mzc0OXxTWU5USHxNT05JVE9SfDk4Y2NlMWNmLWQ2YWUtNGUxZi1iMzdiLTNlMzI4ZDU0MzIwNg') FACET monitorName, locationLabel, location, result, error"
  }

  critical {
    operator = "above_or_equals"
    threshold = 1
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 0
}

resource "newrelic_nrql_alert_condition" "ssuptimeln" {
  account_id = 1863749
  policy_id = 4844808
  type = "static"
  name = "SS-Uptime-LN"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(count(*), WHERE result = 'FAILED') AS 'Failures' FROM SyntheticCheck WHERE entityGuid IN ('MTg2Mzc0OXxTWU5USHxNT05JVE9SfDlhNTdkMDYwLWU2ZWQtNGQ3Mi1iOWY1LTE3MmYwZTZiNThjMQ') FACET monitorName, locationLabel, location, result, error"
  }

  critical {
    operator = "above_or_equals"
    threshold = 1
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 0
}

resource "newrelic_nrql_alert_condition" "ssuptimeme" {
  account_id = 1863749
  policy_id = 4844808
  type = "static"
  name = "SS-Uptime-ME"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(count(*), WHERE result = 'FAILED') AS 'Failures' FROM SyntheticCheck WHERE entityGuid IN ('MTg2Mzc0OXxTWU5USHxNT05JVE9SfGM4ZTYzZjFmLTk3NDMtNGNkOC05OGFkLWYyODVkNDJlZGI5OQ') FACET monitorName, locationLabel, location, result, error"
  }

  critical {
    operator = "above_or_equals"
    threshold = 1
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 0
}



resource "newrelic_nrql_alert_condition" "survey_share_url_anamoly" {
  account_id = 1863749
  policy_id = 4598170
  type = "baseline"
  name = "Survey share URL - anamoly"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT max(duration) from Transaction where request.uri like '/s/%'"
  }

  warning {
    operator = "above"
    threshold = 1
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
  baseline_direction = "upper_only"
}

resource "newrelic_nrql_alert_condition" "testcondition" {
  account_id = 1863749
  policy_id = 4604946
  type = "static"
  name = "test-condition"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(count(*), WHERE result = 'FAILED') FROM SyntheticCheck WHERE NOT isMuted AND entityGuid IN ('MTg2Mzc0OXxTWU5USHxNT05JVE9SfDBlOGI0MjA0LWJlZGItNDY4NC1iNzUwLTJiNzQyMDZjMTU3YQ') FACET entityGuid, location"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer = 5
}

resource "newrelic_nrql_alert_condition" "throughput_background_high" {
  account_id = 1863749
  policy_id = 3859803
  type = "static"
  name = "Throughput (background) (High)"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(count(newrelic.timeslice.value), WHERE metricTimesliceName = 'OtherTransaction/all') OR 0 FROM Metric WHERE appId IN (530079645) AND metricTimesliceName IN ('OtherTransaction/all', 'Agent/MetricsReported/count') FACET appId"
  }

  critical {
    operator = "above"
    threshold = 50000
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator = "above"
    threshold = 20000
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }
  fill_option = "static"
  fill_value = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "throughput_web_high" {
  account_id = 1863749
  policy_id = 3859803
  type = "static"
  name = "Throughput (web) (High)"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(count(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appId IN (530079645) AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appId"
  }

  critical {
    operator = "above"
    threshold = 50000
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator = "above"
    threshold = 20000
    threshold_duration = 300
    threshold_occurrences = "at_least_once"
  }
  fill_option = "static"
  fill_value = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "timerelic_eu_dataaccessresourcefailureexception" {
  account_id = 1863749
  policy_id = 3955468
  type = "static"
  name = "TimeRelic EU - DataAccessResourceFailureException"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT count(*) FROM TransactionError WHERE (entityGuid = 'MTg2Mzc0OXxBUE18QVBQTElDQVRJT058NTM2NTg2Nzg5') AND (`error.class` = 'org.springframework.dao.DataAccessResourceFailureException' AND `error.expected` IS FALSE OR `error.expected` IS NULL) FACET `error.class`, `transactionUiName`, `error.message`"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "timerelic_eu_jobrunr_db_storageexception" {
  account_id = 1863749
  policy_id = 3955468
  type = "static"
  name = "TimeRelic EU - JobRunr DB StorageException"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT count(*) FROM TransactionError WHERE (entityGuid = 'MTg2Mzc0OXxBUE18QVBQTElDQVRJT058NTM2NTg2Nzg5') AND (`error.class` = 'org.jobrunr.storage.StorageException' AND `error.expected` IS FALSE OR `error.expected` IS NULL) FACET `error.class`, `transactionUiName`, `error.message`"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "timerelic_eu_errors_alert" {
  account_id = 1863749
  policy_id = 3955468
  type = "static"
  name = "TimeRelic EU Errors Alert"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT count(*) FROM TransactionError WHERE (entityGuid = 'MTg2Mzc0OXxBUE18QVBQTElDQVRJT058NTM2NTg2Nzg5') AND (`error.expected` IS FALSE OR `error.expected` IS NULL) FACET `error.class`, `transactionUiName`, `error.message`"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 1800
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "timerelic_us_dataaccessresourcefailureexception" {
  account_id = 1863749
  policy_id = 3955468
  type = "static"
  name = "TimeRelic US - DataAccessResourceFailureException"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT count(*) FROM TransactionError WHERE (entityGuid = 'MTg2Mzc0OXxBUE18QVBQTElDQVRJT058NTM2OTc3NTM5') AND (`error.class` = 'org.springframework.dao.DataAccessResourceFailureException' AND `error.expected` IS FALSE OR `error.expected` IS NULL) FACET `error.class`, `transactionUiName`, `error.message`"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "timerelic_us_jobrunr_db_storageexception" {
  account_id = 1863749
  policy_id = 3955468
  type = "static"
  name = "TimeRelic US - JobRunr DB StorageException"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT count(*) FROM TransactionError WHERE (entityGuid = 'MTg2Mzc0OXxBUE18QVBQTElDQVRJT058NTM2OTc3NTM5') AND (`error.class` = 'org.jobrunr.storage.StorageException' AND `error.expected` IS FALSE OR `error.expected` IS NULL) FACET `error.class`, `transactionUiName`, `error.message`"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "timerelic_us_errors_alert" {
  account_id = 1863749
  policy_id = 3955468
  type = "static"
  name = "TimeRelic US Errors Alert"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT count(*) FROM TransactionError WHERE (entityGuid = 'MTg2Mzc0OXxBUE18QVBQTElDQVRJT058NTM2OTc3NTM5') AND (`error.expected` IS FALSE OR `error.expected` IS NULL) FACET `error.class`, `transactionUiName`, `error.message`"
  }

  critical {
    operator = "above"
    threshold = 0
    threshold_duration = 1800
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
}

resource "newrelic_nrql_alert_condition" "twillio_verify_api_calls_deviation" {
  account_id = 1863749
  policy_id = 3673766
  type = "baseline"
  name = "Twillio Verify API calls deviation"
  enabled = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT rate(count(apm.service.external.host.duration), 1 minute) FROM Metric WHERE (entity.guid = 'MTg2Mzc0OXxBUE18QVBQTElDQVRJT058NDE5OTA2Njc') AND (`external.host` = 'verify.twilio.com:443') FACET `external.host`"
  }

  critical {
    operator = "above"
    threshold = 15
    threshold_duration = 120
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 120
  baseline_direction = "upper_and_lower"
}



resource "newrelic_nrql_alert_condition" "uslong_running_queries" {
  account_id = 1863749
  policy_id = 3856359
  type = "static"
  name = "US-Long Running Queries"
  enabled = true
  violation_time_limit_seconds = 300

  nrql {
    query = "FROM  SqlTrace SELECT  max(maxCallTime) WHERE  applicationIds = ':543278964:' AND path NOT LIKE '%superadmin%' FACET databaseMetricName, path, uri, sql"
  }

  critical {
    operator = "above_or_equals"
    threshold = 60
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator = "above_or_equals"
    threshold = 30
    threshold_duration = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option = "none"
  aggregation_window = 30
  aggregation_method = "event_timer"
  aggregation_timer = 300
}
