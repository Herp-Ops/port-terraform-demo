# ---------------------------------------------------------------------------
# openapi_spec
# Replaces the blueprint currently auto-created by the sync-openapi-to-port
# GitHub Actions workflow. Once this is applied, remove the "Ensure Port
# blueprint exists" step from .github/workflows/sync-openapi-to-port.yml
# in the api repo — Terraform owns the lifecycle from here.
# ---------------------------------------------------------------------------
resource "port_blueprint" "openapi_spec" {
  identifier  = "openapi-spec"
  title       = "OpenAPI Spec"
  icon        = "RestAPI"
  description = "OpenAPI / Swagger specification for a service, synced automatically on every main branch build."

  # NOTE: v2 provider requires typed sub-maps (string_props, number_props,
  # object_props, etc.) instead of a flat map with a `type = "..."` key.
  properties = {
    string_props = {
      swagger_url = {
        title    = "Swagger URL"
        format   = "url"
        spec     = "open-api"
        required = false
      }
      version = {
        title    = "Version"
        required = false
      }
      last_synced = {
        title    = "Last Synced"
        required = false
      }
    }
    number_props = {
      path_count = {
        title    = "Path Count"
        required = false
      }
    }
    object_props = {
      spec = {
        title    = "OpenAPI Spec"
        required = false
      }
    }
  }
}

# ---------------------------------------------------------------------------
# service
# Core blueprint representing a deployable service in your organization.
# Relations link to the Railway, OpenAPI, and Environment blueprints so one
# entity surfaces everything about the service in a single Port view.
# ---------------------------------------------------------------------------
resource "port_blueprint" "service" {
  identifier  = "service"
  title       = "Service"
  icon        = "Service"
  description = "A deployable service with all of its integrations linked."

  properties = {
    string_props = {
      language = {
        title    = "Language"
        required = false
      }
      description = {
        title    = "Description"
        required = false
      }
      repo_url = {
        title    = "Repo URL"
        format   = "url"
        required = false
      }
      docs_url = {
        title    = "Docs URL"
        format   = "url"
        required = false
      }
      railway_url = {
        title    = "Railway URL"
        format   = "url"
        required = false
      }
      vercel_url = {
        title    = "Vercel URL"
        format   = "url"
        required = false
      }
      sentry_project = {
        title    = "Sentry Project"
        required = false
      }
      on_call_runbook = {
        title    = "On-Call Runbook"
        format   = "url"
        required = false
      }
    }
    number_props = {
      test_coverage = {
        title    = "Test Coverage %"
        required = false
      }
    }
    boolean_props = {
      has_sentry = {
        title    = "Has Sentry"
        required = false
      }
      has_ci_cd = {
        title    = "Has CI/CD"
        required = false
      }
    }
  }

  relations = {
    openapi_spec = {
      title    = "OpenAPI Spec"
      target   = port_blueprint.openapi_spec.identifier
      required = false
      many     = false
    }
    railway_service = {
      title    = "Railway Service"
      target   = "railwayService"
      required = false
      many     = false
    }
    vercel_project = {
      title    = "Vercel Project"
      target   = "vercelProject"
      required = false
      many     = false
    }
  }
}

# ---------------------------------------------------------------------------
# environment
# Represents a deployed environment (dev / staging / production).
# Linked back to the service it belongs to and its Railway environment.
# ---------------------------------------------------------------------------
resource "port_blueprint" "environment" {
  identifier  = "environment"
  title       = "Environment"
  icon        = "Environment"
  description = "A deployed environment for a service."

  properties = {
    string_props = {
      url = {
        title    = "URL"
        format   = "url"
        required = false
      }
      env_type = {
        title    = "Type"
        required = false
        enum     = ["development", "staging", "production"]
        enum_colors = {
          development = "blue"
          staging     = "yellow"
          production  = "green"
        }
      }
    }
  }

  relations = {
    service = {
      title    = "Service"
      target   = port_blueprint.service.identifier
      required = false
      many     = false
    }
    railway_environment = {
      title    = "Railway Environment"
      target   = "railwayEnvironment"
      required = false
      many     = false
    }
  }
}

# ---------------------------------------------------------------------------
# githubRepository
# Managed by GitHub Ocean integration but defined here to add service relation.
# Import existing blueprint: terraform import port_blueprint.github_repository githubRepository
# ---------------------------------------------------------------------------
resource "port_blueprint" "github_repository" {
  identifier  = "githubRepository"
  title       = "Repository"
  icon        = "Github"
  description = "GitHub repository synced via Ocean integration"

  properties = {
    string_props = {
      description = {
        title    = "Description"
        required = false
      }
      visibility = {
        title    = "Visibility"
        required = false
        enum     = ["public", "private"]
      }
      defaultBranch = {
        title    = "Default branch"
        required = false
      }
      readme = {
        title    = "README"
        required = false
        format   = "markdown"
      }
      codeowners = {
        title    = "CODEOWNERS"
        required = false
        format   = "markdown"
      }
      url = {
        title    = "Repository URL"
        format   = "url"
        required = false
        icon     = "DefaultProperty"
      }
      language = {
        title    = "Language"
        required = false
      }
      last_contributor = {
        title    = "Last contributor"
        format   = "user"
        required = false
        icon     = "TwoUsers"
      }
      last_push = {
        title       = "Last push"
        description = "Last commit to the main branch"
        format      = "date-time"
        required    = false
        icon        = "GitPullRequest"
      }
    }
    number_props = {
      require_approval_count = {
        title       = "Require approvals"
        description = "The number of approvals required before merging a pull request"
        required    = false
        icon        = "DefaultProperty"
      }
    }
    boolean_props = {
      require_code_owner_review = {
        title       = "Require code owner review"
        description = "Requires review from code owners before a pull request can be merged"
        required    = false
        icon        = "DefaultProperty"
      }
    }
  }

  relations = {
    organization = {
      title    = "Organization"
      target   = "githubOrganization"
      required = false
      many     = false
    }
    githubTeams = {
      title    = "GitHub Teams"
      target   = "githubTeam"
      required = false
      many     = true
    }
    service = {
      title    = "Service"
      target   = port_blueprint.service.identifier
      required = false
      many     = false
    }
  }
}

# ---------------------------------------------------------------------------
# githubPullRequest
# Managed by GitHub Ocean integration but defined here to add service relation.
# Import existing blueprint: terraform import port_blueprint.github_pull_request githubPullRequest
# ---------------------------------------------------------------------------
resource "port_blueprint" "github_pull_request" {
  identifier  = "githubPullRequest"
  title       = "Pull Request"
  icon        = "Github"
  description = "GitHub pull request synced via Ocean integration"

  properties = {
    string_props = {
      status = {
        title    = "Status"
        required = false
        enum     = ["merged", "open", "closed"]
        enum_colors = {
          merged = "purple"
          open   = "green"
          closed = "red"
        }
      }
      closedAt = {
        title    = "Closed at"
        required = false
        format   = "date-time"
      }
      updatedAt = {
        title    = "Updated at"
        required = false
        format   = "date-time"
      }
      mergedAt = {
        title    = "Merged at"
        required = false
        format   = "date-time"
      }
      createdAt = {
        title    = "Created at"
        required = false
        format   = "date-time"
      }
      link = {
        title    = "Link"
        format   = "url"
        required = false
      }
      branch = {
        title    = "Branch"
        required = false
      }
    }
    number_props = {
      prNumber = {
        title    = "PR number"
        required = false
      }
      leadTimeHours = {
        title    = "Lead time in hours"
        required = false
      }
    }
  }

  calculation_properties = {
    days_old = {
      title       = "Days Old"
      icon        = "DefaultProperty"
      calculation = "(now / 86400) - (.properties.createdAt | capture(\"(?<date>\\\\d{4}-\\\\d{2}-\\\\d{2})\") | .date | strptime(\"%Y-%m-%d\") | mktime / 86400) | floor"
      type        = "number"
    }
  }

  mirror_properties = {
    reviewer_teams = {
      title = "Reviewer Teams"
      path  = "reviewers.$team"
    }
  }

  relations = {
    repository = {
      title    = "Repository"
      target   = port_blueprint.github_repository.identifier
      required = false
      many     = false
    }
    organization = {
      title    = "Organization"
      target   = "githubOrganization"
      required = false
      many     = false
    }
    creator = {
      title    = "Creator"
      target   = "_user"
      required = false
      many     = false
    }
    assignees = {
      title    = "Assignees"
      target   = "_user"
      required = false
      many     = true
    }
    reviewers = {
      title    = "Reviewers"
      target   = "_user"
      required = false
      many     = true
    }
    git_hub_creator = {
      title    = "GitHub Creator"
      target   = "githubUser"
      required = false
      many     = false
    }
    git_hub_assignees = {
      title    = "GitHub Assignees"
      target   = "githubUser"
      required = false
      many     = true
    }
    git_hub_reviewers = {
      title    = "GitHub Reviewers"
      target   = "githubUser"
      required = false
      many     = true
    }
    service = {
      title    = "Service"
      target   = port_blueprint.service.identifier
      required = false
      many     = false
    }
  }
}

# ---------------------------------------------------------------------------
# betaSignup
# Tracks beta waitlist signups from your landing page form or marketing site.
# Form fields: email, name, company_size, use_case, current_solution
# Can be populated via Google Apps Script, Zapier, or Port webhook
# ---------------------------------------------------------------------------
resource "port_blueprint" "beta_signup" {
  identifier  = "betaSignup"
  title       = "Beta Signup"
  icon        = "Users"
  description = "Beta waitlist signup from landing page"

  properties = {
    string_props = {
      email = {
        title    = "Email"
        format   = "email"
        required = true
      }
      name = {
        title    = "Name"
        required = true
      }
      company_size = {
        title    = "Company Size"
        required = false
        enum     = ["1-10", "11-50", "51-200", "201-500", "500+"]
        enum_colors = {
          "1-10"    = "lightGray"
          "11-50"   = "blue"
          "51-200"  = "turquoise"
          "201-500" = "orange"
          "500+"    = "purple"
        }
      }
      use_case = {
        title    = "Primary Use Case"
        required = false
      }
      current_solution = {
        title    = "Current Solution"
        required = false
        enum     = ["Spreadsheets", "In-house tool", "Competitor product", "Nothing yet"]
        enum_colors = {
          "Spreadsheets"       = "lightGray"
          "In-house tool"      = "blue"
          "Competitor product" = "orange"
          "Nothing yet"        = "darkGray"
        }
      }
      signup_date = {
        title    = "Signup Date"
        format   = "date-time"
        required = false
      }
      status = {
        title    = "Status"
        required = false
        enum     = ["pending", "invited", "active", "declined"]
        enum_colors = {
          pending  = "yellow"
          invited  = "blue"
          active   = "green"
          declined = "red"
        }
      }
      notes = {
        title    = "Notes"
        required = false
      }
    }
  }
}

# ---------------------------------------------------------------------------
# user
# Tracks authenticated users in your application
# Created automatically when users first authenticate via Auth0 (or other IdP)
# Can be linked back to betaSignup to track conversion funnel
# ---------------------------------------------------------------------------
resource "port_blueprint" "user" {
  identifier  = "user"
  title       = "User"
  icon        = "User"
  description = "Authenticated user in the application"

  properties = {
    string_props = {
      email = {
        title    = "Email"
        format   = "email"
        required = true
      }
      auth0_id = {
        title    = "Auth0 ID"
        required = false
      }
      subscription_tier = {
        title    = "Subscription Tier"
        required = false
        enum     = ["free", "starter", "pro"]
        enum_colors = {
          free    = "lightGray"
          starter = "blue"
          pro     = "purple"
        }
      }
      role = {
        title    = "Role"
        required = false
        enum     = ["user", "admin"]
        enum_colors = {
          user  = "blue"
          admin = "red"
        }
      }
      created_at = {
        title    = "Created At"
        format   = "date-time"
        required = false
      }
      last_login = {
        title    = "Last Login"
        format   = "date-time"
        required = false
      }
    }
    number_props = {
      usage_count = {
        title       = "Usage Count"
        description = "Total number of actions performed"
        required    = false
      }
    }
    boolean_props = {
      terms_accepted = {
        title    = "Terms Accepted"
        required = false
      }
      email_verified = {
        title    = "Email Verified"
        required = false
      }
    }
  }

  relations = {
    beta_signup = {
      title       = "Beta Signup"
      description = "Original beta signup if they came from the waitlist"
      target      = port_blueprint.beta_signup.identifier
      required    = false
      many        = false
    }
  }
}

# ---------------------------------------------------------------------------
# sonarQubeProject
# Managed by the SonarQube Ocean integration. Defined here so we can:
#   1. Add a relation back to our service blueprint
#   2. Control schema via Terraform rather than auto-generated defaults
# Blueprint already exists (created by Ocean integration) — import block
# tells Terraform to adopt it rather than create it.
# ---------------------------------------------------------------------------
import {
  to = port_blueprint.sonar_qube_project
  id = "sonarQubeProject"
}

resource "port_blueprint" "sonar_qube_project" {
  identifier  = "sonarQubeProject"
  title       = "SonarQube Project"
  icon        = "sonarqube"
  description = "SonarCloud / SonarQube project synced via Ocean integration"

  properties = {
    string_props = {
      organization = {
        title    = "Organization"
        required = false
      }
      link = {
        title    = "SonarCloud Link"
        format   = "url"
        required = false
      }
      qualityGateStatus = {
        title    = "Quality Gate Status"
        required = false
        enum     = ["OK", "WARN", "ERROR"]
        enum_colors = {
          OK    = "green"
          WARN  = "yellow"
          ERROR = "red"
        }
      }
      mainBranch = {
        title    = "Main Branch"
        required = false
      }
      lastAnalysisDate = {
        title    = "Last Analysis Date"
        format   = "date-time"
        required = false
      }
    }
    number_props = {
      coverage = {
        title    = "Coverage %"
        required = false
      }
      numberOfBugs = {
        title    = "Bugs"
        required = false
      }
      numberOfCodeSmells = {
        title    = "Code Smells"
        required = false
      }
      numberOfVulnerabilities = {
        title    = "Vulnerabilities"
        required = false
      }
      numberOfHotSpots = {
        title    = "Security Hotspots"
        required = false
      }
      numberOfDuplications = {
        title    = "Duplicated Files"
        required = false
      }
    }
  }

  relations = {
    service = {
      title    = "Service"
      target   = port_blueprint.service.identifier
      required = false
      many     = false
    }
  }
}
