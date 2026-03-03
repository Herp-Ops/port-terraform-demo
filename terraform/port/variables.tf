variable "port_client_id" {
  description = "Port API client ID — set as a sensitive variable in the acme-port TF Cloud workspace"
  type        = string
  sensitive   = true
}

variable "port_client_secret" {
  description = "Port API client secret — set as a sensitive variable in the acme-port TF Cloud workspace"
  type        = string
  sensitive   = true
}

variable "github_org" {
  description = "GitHub organization name used for self-service action invocations"
  type        = string
  default     = "Acme-Corp"
}

variable "api_repo" {
  description = "GitHub repository name for the API service"
  type        = string
  default     = "api"
}

variable "infra_repo" {
  description = "GitHub repository name for the infrastructure repo (where scaffold workflow lives)"
  type        = string
  default     = "acme-infra"
}

variable "api_docs_url" {
  description = "Public URL for the API Swagger docs"
  type        = string
  default     = "https://api.example.com/docs"
}

variable "api_railway_url" {
  description = "Railway project URL for the API service"
  type        = string
  default     = ""
}

variable "api_staging_url" {
  description = "Public URL for the API staging environment"
  type        = string
  default     = ""
}

variable "api_sentry_project" {
  description = "Sentry project slug for the API"
  type        = string
  default     = "acme-api"
}

variable "frontend_vercel_url" {
  description = "Vercel production URL for the frontend app"
  type        = string
  default     = "https://app.example.com"
}

variable "frontend_sentry_project" {
  description = "Sentry project slug for the frontend"
  type        = string
  default     = "acme-frontend"
}

variable "landing_vercel_url" {
  description = "Vercel production URL for the landing page"
  type        = string
  default     = "https://www.example.com"
}

# ---------------------------------------------------------------------------
# Integration entity identifiers
#
# These are the identifiers Port assigns to entities auto-created by the
# Railway and Vercel integrations. Find them in Port under the respective
# blueprint's catalog page, or via: GET /v1/blueprints/<blueprint>/entities
# ---------------------------------------------------------------------------

variable "api_railway_service_id" {
  description = "Port entity identifier for the API's railwayService (from Railway integration)"
  type        = string
  default     = ""
}

variable "frontend_vercel_project_id" {
  description = "Port entity identifier for the frontend's vercelProject (from Vercel integration)"
  type        = string
  default     = ""
}

variable "landing_vercel_project_id" {
  description = "Port entity identifier for the landing page's vercelProject (from Vercel integration)"
  type        = string
  default     = ""
}
