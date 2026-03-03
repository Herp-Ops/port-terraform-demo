# Example GitHub Actions Workflows

This directory contains example GitHub Actions workflows for Port.io integration.

## Workflows

### `port-tf-sync.yml`

Automatically applies Terraform changes to Port when you push to the main branch.

**Setup**:

1. Copy to `.github/workflows/`:
   ```bash
   mkdir -p .github/workflows
   cp examples/workflows/port-tf-sync.yml .github/workflows/
   ```
2. Add secrets to your GitHub repository:
   - `PORT_CLIENT_ID`
   - `PORT_CLIENT_SECRET`

### `scaffold-service.yml`

Handles the "Scaffold New Service" Port action. Creates a new GitHub repo from a template and registers it in Port.

**Setup**:

1. Copy to `.github/workflows/`:
   ```bash
   cp examples/workflows/scaffold-service.yml .github/workflows/
   ```
2. Add secrets to your GitHub repository:
   - `PORT_CLIENT_ID`
   - `PORT_CLIENT_SECRET`
   - `ORG_ADMIN_TOKEN` (GitHub personal access token with repo creation permissions)
3. Update the `GITHUB_ORG` environment variable in the workflow

## Required GitHub Secrets

All workflows require these secrets:

| Secret               | Description                  | Where to get it                                               |
| -------------------- | ---------------------------- | ------------------------------------------------------------- |
| `PORT_CLIENT_ID`     | Port API client ID           | Port Settings → API Credentials                               |
| `PORT_CLIENT_SECRET` | Port API client secret       | Port Settings → API Credentials                               |
| `ORG_ADMIN_TOKEN`    | GitHub PAT with `repo` scope | GitHub Settings → Developer Settings → Personal Access Tokens |

## Testing

After copying workflows to `.github/workflows/`:

1. Make a change in `terraform/port/`
2. Commit and push to main
3. Check the Actions tab in GitHub to see the workflow run
4. Verify changes appear in Port

## Customization

- Adjust the `on:` triggers to match your branching strategy
- Modify `paths:` filters to control when workflows run
- Add additional steps for notifications, approvals, etc.
