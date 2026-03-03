# ---------------------------------------------------------------------------
# Import blocks — adopt entities that were created/mutated directly via API.
# These tell Terraform to take ownership rather than recreate.
# ---------------------------------------------------------------------------
import {
  to = port_entity.api
  id = "service:api"
}

import {
  to = port_entity.frontend
  id = "service:frontend"
}

import {
  to = port_entity.acme_ai_agent
  id = "_ai_agent:acme-assistant"
}

# ---------------------------------------------------------------------------
# Service entities
#
# Seed the Port catalog with core services. These are
# static/stable facts about each service — dynamic properties (test coverage,
# deployment URLs, etc.) are updated by CI/CD via the Port API.
# ---------------------------------------------------------------------------

resource "port_entity" "api" {
  blueprint  = port_blueprint.service.identifier
  identifier = "api"
  title      = "API"

  properties = {
    string_props = {
      language        = "Python"
      repo_url        = "https://github.com/${var.github_org}/api"
      docs_url        = var.api_docs_url
      railway_url     = var.api_railway_url
      sentry_project  = var.api_sentry_project
      on_call_runbook = "https://github.com/${var.github_org}/acme-infra/blob/main/docs/troubleshooting.md"
    }
    number_props = {
      test_coverage = 85
    }
    boolean_props = {
      has_ci_cd  = true
      has_sentry = true
    }
  }

  relations = {
    openapi_spec = {
      value = "openapi-spec"
    }
    railway_service = {
      value = var.api_railway_service_id != "" ? var.api_railway_service_id : null
    }
  }
}

resource "port_entity" "frontend" {
  blueprint  = port_blueprint.service.identifier
  identifier = "frontend"
  title      = "Frontend"

  properties = {
    string_props = {
      language       = "TypeScript"
      repo_url       = "https://github.com/${var.github_org}/frontend"
      vercel_url     = var.frontend_vercel_url
      sentry_project = var.frontend_sentry_project
    }
    number_props = {
      test_coverage = 75
    }
    boolean_props = {
      has_ci_cd  = true
      has_sentry = true
    }
  }

  relations = {
    vercel_project = {
      value = var.frontend_vercel_project_id != "" ? var.frontend_vercel_project_id : null
    }
  }
}

resource "port_entity" "landing" {
  blueprint  = port_blueprint.service.identifier
  identifier = "landing"
  title      = "Landing Page"

  properties = {
    string_props = {
      language   = "TypeScript"
      repo_url   = "https://github.com/${var.github_org}/landing"
      vercel_url = var.landing_vercel_url
    }
    boolean_props = {
      has_ci_cd  = true
      has_sentry = false
    }
  }

  relations = {
    vercel_project = {
      value = var.landing_vercel_project_id != "" ? var.landing_vercel_project_id : null
    }
  }
}

resource "port_entity" "acme_infra" {
  blueprint  = port_blueprint.service.identifier
  identifier = "acme-infra"
  title      = "Infrastructure"

  properties = {
    string_props = {
      language = "HCL"
      repo_url = "https://github.com/${var.github_org}/acme-infra"
    }
    boolean_props = {
      has_ci_cd  = true
      has_sentry = false
    }
  }

  relations = {}
}

# ---------------------------------------------------------------------------
# Environment entities
#
# One entity per deployed environment. Relations link back to the parent
# service so Port can surface all environments from the service detail view.
# ---------------------------------------------------------------------------

resource "port_entity" "api_production" {
  blueprint  = port_blueprint.environment.identifier
  identifier = "api-production"
  title      = "API — Production"

  properties = {
    string_props = {
      url      = "https://api.example.com"
      env_type = "production"
    }
  }

  relations = {
    service = {
      value = port_entity.api.identifier
    }
  }
}

resource "port_entity" "api_staging" {
  blueprint  = port_blueprint.environment.identifier
  identifier = "api-staging"
  title      = "API — Staging"

  properties = {
    string_props = {
      url      = var.api_staging_url
      env_type = "staging"
    }
  }

  relations = {
    service = {
      value = port_entity.api.identifier
    }
  }
}

resource "port_entity" "frontend_production" {
  blueprint  = port_blueprint.environment.identifier
  identifier = "frontend-production"
  title      = "Frontend — Production"

  properties = {
    string_props = {
      url      = var.frontend_vercel_url
      env_type = "production"
    }
  }

  relations = {
    service = {
      value = port_entity.frontend.identifier
    }
  }
}

resource "port_entity" "landing_production" {
  blueprint  = port_blueprint.environment.identifier
  identifier = "landing-production"
  title      = "Landing Page — Production"

  properties = {
    string_props = {
      url      = var.landing_vercel_url
      env_type = "production"
    }
  }

  relations = {
    service = {
      value = port_entity.landing.identifier
    }
  }
}

# ---------------------------------------------------------------------------
# Port AI Agent
# Context-aware assistant that knows about your services, quality, and users.
# ---------------------------------------------------------------------------
resource "port_entity" "acme_ai_agent" {
  blueprint  = "_ai_agent"
  identifier = "acme-assistant"
  title      = "Acme Assistant"

  properties = {
    string_props = {
      description = "AI assistant for the Acme platform — knows your services, code quality, deployments, and roadmap."
      status      = "active"
      prompt      = <<-PROMPT
        You are an expert assistant for Acme Corp, a SaaS platform.

        ## About Acme
        - **Product**: SaaS application with FastAPI backend and Next.js frontend
        - **Tech stack**: FastAPI (Python) backend on Railway, Next.js/TypeScript frontend on Vercel, PostgreSQL, Auth0, Stripe
        - **GitHub org**: Acme-Corp

        ## Services
        - **api**: Python/FastAPI REST API — deployed at api.example.com, 85% coverage
        - **frontend**: Next.js/TypeScript — deployed at app.example.com, 75% coverage
        - **landing**: Marketing landing page at www.example.com
        - **acme-infra**: Terraform + Port config, Railway/Vercel integrations

        ## What you can help with
        - Answer questions about service health, deployments, code quality
        - Explain what beta signups and users are in the catalog
        - Summarize recent pull requests and deployments
        - Explain the product roadmap and upcoming features
        - Help interpret SonarCloud metrics and scorecard status
      PROMPT
      execution_mode = "Automatic"
      provider       = "openai"
      model          = "gpt-4o"
    }
    array_props = {
      conversation_starters = {
        string_items = {}
      }
    }
  }
}
