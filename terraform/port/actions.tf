# ---------------------------------------------------------------------------
# Reset Demo Data
# ---------------------------------------------------------------------------
resource "port_action" "reset_demo_data" {
  identifier = "reset_demo_data"
  title      = "Reset Demo Data"
  icon       = "Refresh"

  self_service_trigger = {
    operation = "CREATE"
  }

  integration_method = {
    type                        = "INTEGRATION_ACTION"
    installation_id             = "github-ocean"
    integration_action_type     = "dispatch_workflow"
    integration_invocation_type = "dispatch_workflow"

    integration_action_execution_properties = {
      org                    = var.github_org
      repo                   = var.api_repo
      workflow               = "reset-demo-data.yml"
      report_workflow_status = true
      workflow_inputs = jsonencode({
        "{{ spreadValue() }}" = "{{ .inputs }}"
        port_run_id           = "{{ .run.id }}"
      })
    }
  }
}

# ---------------------------------------------------------------------------
# Trigger Deployment
# ---------------------------------------------------------------------------
resource "port_action" "trigger_deployment" {
  identifier = "trigger_deployment"
  title      = "Trigger Deployment"
  icon       = "DeployedAt"

  self_service_trigger = {
    operation            = "DAY-2"
    blueprint_identifier = port_blueprint.service.identifier
    user_properties = {
      string_props = {
        environment = {
          title    = "Environment"
          required = true
          default  = "staging"
          enum     = ["production", "staging"]
          enum_colors = {
            production = "green"
            staging    = "yellow"
          }
        }
      }
    }
  }

  integration_method = {
    type                        = "INTEGRATION_ACTION"
    installation_id             = "github-ocean"
    integration_action_type     = "dispatch_workflow"
    integration_invocation_type = "dispatch_workflow"

    integration_action_execution_properties = {
      org                    = var.github_org
      repo                   = var.api_repo
      workflow               = "deploy-production.yml"
      report_workflow_status = true
      workflow_inputs = jsonencode({
        "{{ spreadValue() }}" = "{{ .inputs }}"
        port_run_id           = "{{ .run.id }}"
      })
    }
  }
}

# ---------------------------------------------------------------------------
# Sync OpenAPI Spec
# ---------------------------------------------------------------------------
resource "port_action" "sync_openapi_spec" {
  identifier = "sync_openapi_spec"
  title      = "Sync OpenAPI Spec"
  icon       = "RestAPI"

  self_service_trigger = {
    operation = "CREATE"
  }

  integration_method = {
    type                        = "INTEGRATION_ACTION"
    installation_id             = "github-ocean"
    integration_action_type     = "dispatch_workflow"
    integration_invocation_type = "dispatch_workflow"

    integration_action_execution_properties = {
      org                    = var.github_org
      repo                   = var.api_repo
      workflow               = "sync-openapi-to-port.yml"
      report_workflow_status = true
      workflow_inputs = jsonencode({
        "{{ spreadValue() }}" = "{{ .inputs }}"
        port_run_id           = "{{ .run.id }}"
      })
    }
  }
}

# ---------------------------------------------------------------------------
# Scaffold New Service
# Self-service action that creates a new repo from a template and registers
# the service in Port catalog. Triggered from the Service catalog page.
# ---------------------------------------------------------------------------
resource "port_action" "scaffold_service" {
  identifier = "scaffold_service"
  title      = "Scaffold New Service"
  icon       = "Github"

  self_service_trigger = {
    operation            = "CREATE"
    blueprint_identifier = port_blueprint.service.identifier
    user_properties = {
      string_props = {
        service_name = {
          title       = "Service Name"
          description = "Repository name (lowercase, hyphens only — e.g. acme-notifications)"
          required    = true
          pattern     = "^[a-z0-9-]+$"
        }
        service_description = {
          title       = "Description"
          description = "What does this service do?"
          required    = true
          default     = "A new Acme Corp microservice"
        }
        language = {
          title    = "Language / Stack"
          required = true
          default  = "python-fastapi"
          enum     = ["python-fastapi", "typescript-nextjs", "go-fiber"]
          enum_colors = {
            "python-fastapi"    = "blue"
            "typescript-nextjs" = "turquoise"
            "go-fiber"          = "cyan"
          }
        }
      }
    }
  }

  integration_method = {
    type                        = "INTEGRATION_ACTION"
    installation_id             = "github-ocean"
    integration_action_type     = "dispatch_workflow"
    integration_invocation_type = "dispatch_workflow"

    integration_action_execution_properties = {
      org                    = var.github_org
      repo                   = var.infra_repo
      workflow               = "scaffold-service.yml"
      report_workflow_status = true
      workflow_inputs = jsonencode({
        service_name        = "{{ .inputs.service_name }}"
        service_description = "{{ .inputs.service_description }}"
        language            = "{{ .inputs.language }}"
        port_context        = "{ \"runId\": \"{{ .run.id }}\" }"
      })
    }
  }
}

# ---------------------------------------------------------------------------
# Send Beta Invite Email
# Sends onboarding email to beta signup and updates status to "invited"
# ---------------------------------------------------------------------------
resource "port_action" "send_beta_invite" {
  identifier = "send_beta_invite"
  title      = "Send Beta Invite"
  icon       = "Email"

  self_service_trigger = {
    operation            = "DAY-2"
    blueprint_identifier = port_blueprint.beta_signup.identifier
  }

  integration_method = {
    type                        = "INTEGRATION_ACTION"
    installation_id             = "github-ocean"
    integration_action_type     = "dispatch_workflow"
    integration_invocation_type = "dispatch_workflow"

    integration_action_execution_properties = {
      org                    = var.github_org
      repo                   = var.api_repo
      workflow               = "send-beta-invite.yml"
      report_workflow_status = true
      workflow_inputs = jsonencode({
        port_run_id           = "{{ .run.id }}"
        entity_identifier     = "{{ .entity.identifier }}"
        email                 = "{{ .entity.properties.email }}"
        name                  = "{{ .entity.properties.name }}"
        "{{ spreadValue() }}" = "{{ .inputs }}"
      })
    }
  }
}
