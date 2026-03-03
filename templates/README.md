# Service Templates

This directory contains [Cookiecutter](https://cookiecutter.readthedocs.io/) templates for scaffolding new microservices. These templates are used by the Port.io self-service action "Scaffold New Service" but can also be used standalone.

## Available Templates

### Python FastAPI

**Path**: `python-fastapi/`

A production-ready FastAPI microservice template with:

- FastAPI + uvicorn
- SQLAlchemy database setup
- Rate limiting (slowapi)
- Sentry error tracking
- pytest test suite
- CI/CD pipeline (GitHub Actions)
- Automatic Port coverage updates
- uv for fast dependency management
- Production-optimized Dockerfile

## Using Templates Manually

### Install Cookiecutter

```bash
pip install cookiecutter
```

### Generate a Service

```bash
cookiecutter templates/python-fastapi/
```

You'll be prompted for:

- `service_name`: Repository name (e.g., `acme-notifications`)
- `service_description`: Short description (e.g., `Email notification service`)

### Generated Structure

```
acme-notifications/
├── app/
│   ├── main.py             # FastAPI app
│   ├── database.py         # SQLAlchemy setup
│   ├── rate_limit.py       # Rate limiting config
│   └── routers/            # Add feature routers here
├── tests/
│   └── test_main.py        # Smoke tests
├── .github/
│   └── workflows/
│       └── ci.yml          # CI pipeline
├── Dockerfile
├── pyproject.toml          # Dependencies
├── .env.example
└── README.md
```

### Next Steps After Generation

1. **Create GitHub repository**:

   ```bash
   cd acme-notifications
   git init
   git add .
   git commit -m "Initial commit"
   gh repo create Acme-Corp/acme-notifications --private --push --source=.
   ```

2. **Set up environment variables**:

   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

3. **Install dependencies**:

   ```bash
   uv sync
   ```

4. **Run locally**:

   ```bash
   uv run uvicorn app.main:app --reload
   ```

5. **Run tests**:

   ```bash
   uv run pytest
   ```

6. **Register in Port** (optional):
   ```bash
   curl -X POST "https://api.getport.io/v1/blueprints/service/entities" \
     -H "Authorization: Bearer $PORT_TOKEN" \
     -d '{
       "identifier": "acme-notifications",
       "title": "Notifications Service",
       "properties": {
         "language": "Python",
         "repo_url": "https://github.com/Acme-Corp/acme-notifications",
         "has_ci_cd": true
       }
     }'
   ```

## Adding New Templates

1. Create `templates/<language-framework>/cookiecutter.json`
2. Add template files in `templates/<language-framework>/{{cookiecutter.service_name}}/`
3. Include README with setup instructions
4. Add CI/CD workflow that updates Port coverage
5. Update Port action in `terraform/port/actions.tf` to include new option

## Port Integration

All templates include a GitHub Actions workflow that:

- Runs tests on every push
- Lints code
- Reports coverage to Port (on main branch)

This keeps the Port catalog synchronized with actual code metrics.
