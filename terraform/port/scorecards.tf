# ---------------------------------------------------------------------------
# Production Readiness Scorecard
#
# Rules evaluate properties on the `service` blueprint. Bronze/Silver/Gold
# levels are unlocked progressively.
# ---------------------------------------------------------------------------
resource "port_scorecard" "production_readiness" {
  blueprint  = port_blueprint.service.identifier
  identifier = "production_readiness"
  title      = "Production Readiness"

  rules = [
    {
      identifier = "has_ci_cd"
      title      = "Has CI/CD pipeline"
      level      = "Bronze"
      query = {
        combinator = "and"
        conditions = [
          jsonencode({
            property = "has_ci_cd"
            operator = "="
            value    = true
          })
        ]
      }
    },
    {
      identifier = "has_sentry"
      title      = "Has error tracking (Sentry)"
      level      = "Silver"
      query = {
        combinator = "and"
        conditions = [
          jsonencode({
            property = "has_sentry"
            operator = "="
            value    = true
          })
        ]
      }
    },
    {
      identifier = "has_repo_url"
      title      = "Has repository URL"
      level      = "Silver"
      query = {
        combinator = "and"
        conditions = [
          jsonencode({
            property = "repo_url"
            operator = "isNotEmpty"
          })
        ]
      }
    },
    {
      identifier = "has_on_call_runbook"
      title      = "Has on-call runbook"
      level      = "Gold"
      query = {
        combinator = "and"
        conditions = [
          jsonencode({
            property = "on_call_runbook"
            operator = "isNotEmpty"
          })
        ]
      }
    },
    {
      identifier = "has_docs_url"
      title      = "Has documentation URL"
      level      = "Silver"
      query = {
        combinator = "and"
        conditions = [
          jsonencode({
            property = "docs_url"
            operator = "isNotEmpty"
          })
        ]
      }
    },
    {
      identifier = "has_test_coverage"
      title      = "Test coverage ≥ 80%"
      level      = "Gold"
      query = {
        combinator = "and"
        conditions = [
          jsonencode({
            property = "test_coverage"
            operator = ">="
            value    = 80
          })
        ]
      }
    },
  ]
}

# ---------------------------------------------------------------------------
# SonarQube Quality Scorecard
# Rules evaluate properties on the sonarQubeProject blueprint.
# ---------------------------------------------------------------------------
resource "port_scorecard" "sonar_quality" {
  blueprint  = port_blueprint.sonar_qube_project.identifier
  identifier = "sonar_quality"
  title      = "Code Quality"

  rules = [
    {
      identifier = "quality_gate_passing"
      title      = "Quality gate is passing"
      level      = "Bronze"
      query = {
        combinator = "and"
        conditions = [
          jsonencode({
            property = "qualityGateStatus"
            operator = "="
            value    = "OK"
          })
        ]
      }
    },
    {
      identifier = "coverage_70"
      title      = "Coverage ≥ 70%"
      level      = "Silver"
      query = {
        combinator = "and"
        conditions = [
          jsonencode({
            property = "coverage"
            operator = ">="
            value    = 70
          })
        ]
      }
    },
    {
      identifier = "coverage_90"
      title      = "Coverage ≥ 90%"
      level      = "Gold"
      query = {
        combinator = "and"
        conditions = [
          jsonencode({
            property = "coverage"
            operator = ">="
            value    = 90
          })
        ]
      }
    },
    {
      identifier = "zero_vulnerabilities"
      title      = "No open vulnerabilities"
      level      = "Silver"
      query = {
        combinator = "and"
        conditions = [
          jsonencode({
            property = "numberOfVulnerabilities"
            operator = "="
            value    = 0
          })
        ]
      }
    },
    {
      identifier = "zero_bugs"
      title      = "No open bugs"
      level      = "Gold"
      query = {
        combinator = "and"
        conditions = [
          jsonencode({
            property = "numberOfBugs"
            operator = "="
            value    = 0
          })
        ]
      }
    },
  ]
}
