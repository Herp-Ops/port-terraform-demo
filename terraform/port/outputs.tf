output "openapi_spec_blueprint_id" {
  description = "Identifier of the openapi-spec blueprint"
  value       = port_blueprint.openapi_spec.identifier
}

output "service_blueprint_id" {
  description = "Identifier of the service blueprint"
  value       = port_blueprint.service.identifier
}

output "environment_blueprint_id" {
  description = "Identifier of the environment blueprint"
  value       = port_blueprint.environment.identifier
}

output "production_readiness_scorecard_id" {
  description = "Identifier of the production readiness scorecard"
  value       = port_scorecard.production_readiness.identifier
}

output "service_entity_ids" {
  description = "Identifiers of all managed service entities"
  value = {
    api      = port_entity.api.identifier
    frontend = port_entity.frontend.identifier
    landing  = port_entity.landing.identifier
    infra    = port_entity.acme_infra.identifier
  }
}
