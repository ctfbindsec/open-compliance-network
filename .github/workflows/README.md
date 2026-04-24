# GitHub Actions Workflows

This directory contains CI/CD workflows for the Open Compliance Network project.

## Available Workflows

### Core Workflows

- **`main-ci.yml`** - Main CI/CD pipeline for full stack builds
- **`contracts-ci.yml`** - Smart contract build, test, and analysis
- **`frontend-ci.yml`** - Frontend build and type checking
- **`backend-ci.yml`** - Backend build and validation

### Quality & Security

- **`pr-checks.yml`** - Automated pull request validation with path filtering
- **`security-scan.yml`** - Dependency vulnerability scanning
- **`deploy-docs.yml`** - Documentation validation and deployment

### Monitoring

- **`status.yml`** - Workflow status tracking and notifications

## Quick Reference

### Trigger Events

| Workflow | Push | PR | Schedule | Manual |
|----------|------|----|----|--------|
| Main CI/CD | ✓ | ✓ | - | - |
| Contracts CI | ✓ | ✓ | - | - |
| Frontend CI | ✓ | ✓ | - | - |
| Backend CI | ✓ | ✓ | - | - |
| PR Checks | - | ✓ | - | - |
| Security Scan | ✓ | ✓ | ✓ (weekly) | - |
| Deploy Docs | ✓ | - | - | ✓ |

### Path Filters

Workflows are optimized to run only when relevant files change:

- **Contracts**: `contracts/**`
- **Frontend**: `frontend/**`
- **Backend**: `backend/**`
- **Workflows**: `workflows/**` (CRE workflows)
- **Documentation**: `documentation/**`, `*.md`

## Development Guidelines

### Before Committing

Run these commands locally to catch issues early:

```bash
# Contracts
cd contracts && forge test && forge fmt --check

# Frontend
cd frontend && npm run build

# Backend
cd backend && bun install && bun run --bun tsc --noEmit
```

### Adding New Workflows

1. Create `.yml` file in this directory
2. Follow existing naming conventions
3. Include proper triggers and path filters
4. Add summary generation with `$GITHUB_STEP_SUMMARY`
5. Update this README
6. Test in a feature branch first

### Workflow Best Practices

- Use specific action versions (e.g., `@v4` not `@latest`)
- Cache dependencies when possible
- Add meaningful step names
- Generate summaries for visibility
- Use `continue-on-error` for non-critical steps
- Set appropriate timeouts
- Use path filters to optimize CI time

## Status Badges

Add these to your README.md:

```markdown
![Main CI](https://github.com/ctfbindsec/open-compliance-network/workflows/Main%20CI%2FCD/badge.svg)
![Contracts](https://github.com/ctfbindsec/open-compliance-network/workflows/Contracts%20CI/badge.svg)
![Frontend](https://github.com/ctfbindsec/open-compliance-network/workflows/Frontend%20CI/badge.svg)
![Backend](https://github.com/ctfbindsec/open-compliance-network/workflows/Backend%20CI/badge.svg)
![Security](https://github.com/ctfbindsec/open-compliance-network/workflows/Dependency%20Security%20Scan/badge.svg)
```

## Troubleshooting

### View Workflow Runs
1. Go to repository `Actions` tab
2. Select specific workflow from left sidebar
3. Click on a run to see details
4. Check job logs and summaries

### Common Issues

**Workflow not triggering:**
- Check path filters match your changes
- Verify branch names in trigger conditions
- Ensure workflow file syntax is valid

**Job failing:**
- Review job logs for error messages
- Check if dependencies are up to date
- Verify environment matches local setup
- Look for secret/environment variable issues

**Slow workflows:**
- Review caching configuration
- Check if unnecessary steps can be removed
- Consider path filtering to skip unchanged components

## Resources

- [Full CI/CD Documentation](../CI-CD-PIPELINE.md)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
