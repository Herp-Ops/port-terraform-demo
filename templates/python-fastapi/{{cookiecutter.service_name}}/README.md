# {{cookiecutter.service_name}}

{{cookiecutter.service_description}}

## Getting Started

```bash
cp .env.example .env
# Edit .env with your values

uv sync
uv run uvicorn app.main:app --reload
```

## Testing

```bash
uv run pytest
```

## Structure

```
app/
  main.py        # FastAPI app entry point
  database.py    # SQLAlchemy engine + session
  rate_limit.py  # slowapi limiter
  routers/       # Add feature routers here
tests/
  test_main.py   # Smoke tests
```

## Deployment

Hosted on Railway. Push to `main` triggers CI → deploy.
