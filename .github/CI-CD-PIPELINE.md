# CI/CD Pipeline Documentation

## Overview

The Open Compliance Network project now includes a comprehensive CI/CD pipeline powered by GitHub Actions. This pipeline automates building, testing, linting, and deploying all components of the project.

## Pipeline Architecture

### Components

The pipeline is organized into multiple workflow files, each handling specific aspects of the development lifecycle:

1. **Main CI/CD** (`main-ci.yml`) - Full stack build and integration
2. **Contracts CI** (`contracts-ci.yml`) - Solidity smart contract workflows
3. **Frontend CI** (`frontend-ci.yml`) - React/Vite application workflows
4. **Backend CI** (`backend-ci.yml`) - Bun/Hono API workflows
5. **PR Checks** (`pr-checks.yml`) - Automated pull request validation
6. **Security Scan** (`security-scan.yml`) - Dependency vulnerability scanning
7. **Documentation** (`deploy-docs.yml`) - Documentation validation and deployment

## Workflow Details

### 1. Main CI/CD Pipeline

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches

**Jobs:**
- `full-build`: Builds all project components (contracts, frontend, backend)
- `docker-build`: Tests Docker images and docker-compose configuration

**What it does:**
- Sets up Foundry for smart contracts
- Installs Node.js dependencies
- Builds and tests all components
- Validates Docker configuration
- Creates build summary in GitHub Actions UI

### 2. Contracts CI

**Triggers:**
- Changes to `contracts/**` directory
- Changes to workflow file itself

**Jobs:**
- `build-and-test`: Compiles contracts, runs tests, checks formatting
- `coverage`: Generates test coverage reports
- `security`: Runs static analysis (when available)

**What it does:**
- Installs Foundry toolchain
- Compiles Solidity contracts with optimization
- Runs comprehensive test suite with verbose output
- Checks contract size limits
- Validates code formatting with `forge fmt`
- Generates coverage reports

**Requirements:**
- Foundry installed (automated)
- Node.js 20.x for npm dependencies
- `@chainlink/ace` and other contract dependencies

### 3. Frontend CI

**Triggers:**
- Changes to `frontend/**` directory
- Changes to workflow file itself

**Jobs:**
- `build-and-test`: Builds production bundle, checks types
- `lint`: Runs ESLint (if configured)

**What it does:**
- Installs npm dependencies
- Type checks with TypeScript compiler
- Builds production bundle with Vite
- Analyzes bundle size
- Runs linting (if configured in package.json)

**Requirements:**
- Node.js 20.x
- Vite, React, TypeScript dependencies

### 4. Backend CI

**Triggers:**
- Changes to `backend/**` directory
- Changes to workflow file itself

**Jobs:**
- `build-and-test`: Type checks, validates server entry point
- `lint`: Runs linter (if configured)

**What it does:**
- Installs Bun runtime
- Installs backend dependencies with Bun
- Type checks TypeScript code
- Validates server.ts entry point exists
- Runs tests (if configured)

**Requirements:**
- Bun runtime (latest)
- Hono framework dependencies

### 5. Pull Request Checks

**Triggers:**
- Any pull request to `main` or `develop`

**Jobs:**
- `pr-info`: Displays PR metadata
- `detect-changes`: Identifies which components changed
- `contracts-check`: Runs if contracts changed
- `frontend-check`: Runs if frontend changed
- `backend-check`: Runs if backend changed
- `workflows-check`: Validates CRE workflow structure
- `pr-summary`: Generates comprehensive summary

**What it does:**
- Uses path filtering to determine what changed
- Only runs relevant checks for modified components
- Validates CRE workflow structure (workflow.yaml, main.ts, config.json)
- Creates detailed summary in GitHub Actions UI
- Optimizes CI time by skipping unchanged components

### 6. Security Scanning

**Triggers:**
- Push to `main` or `develop`
- Pull requests
- Weekly schedule (Mondays at 00:00 UTC)

**Jobs:**
- `dependency-scan`: Audits all npm dependencies

**What it does:**
- Runs `npm audit` for all components
- Uses GitHub's dependency review for PRs
- Flags moderate and higher severity vulnerabilities
- Runs weekly to catch new vulnerabilities

### 7. Documentation Pipeline

**Triggers:**
- Changes to `documentation/**` or markdown files
- Push to `main` branch
- Manual workflow dispatch

**Jobs:**
- `deploy-docs`: Validates and archives documentation

**What it does:**
- Validates all markdown files
- Generates documentation index
- Creates artifact with all docs
- Prepares for potential docs site deployment

## Environment Setup

### Local Development

To ensure your local environment matches CI:

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install Bun
curl -fsSL https://bun.sh/install | bash

# Install Node.js 20.x
# Use nvm, brew, or your package manager

# Install all dependencies
cd contracts && npm ci
cd ../frontend && npm ci
cd ../backend && bun install
```

### Required Secrets

Currently, no secrets are required for CI to run. Future integrations may need:

- `NPM_TOKEN` - For publishing packages
- `DOCKER_HUB_TOKEN` - For pushing Docker images
- `ARC_RPC_URL` - For deployment to Arc testnet
- `PRIVATE_KEY` - For contract deployments (use GitHub secrets)

## Running Workflows Locally

### Contracts
```bash
cd contracts
forge build
forge test
forge fmt --check
```

### Frontend
```bash
cd frontend
npm ci
npm run build
```

### Backend
```bash
cd backend
bun install
bun run --bun tsc --noEmit
```

### Docker
```bash
docker-compose config
docker-compose build
```

## Best Practices

### For Contributors

1. **Run local tests before pushing**
   - Ensures CI won't fail on obvious issues
   - Saves CI minutes and review time

2. **Keep changes focused**
   - Modify only what's necessary
   - CI path filtering optimizes when scoped properly

3. **Check CI results**
   - Review the Summary tab in GitHub Actions
   - Fix any warnings or errors promptly

4. **Update documentation**
   - If adding new CI features, update this doc
   - Keep workflow comments up to date

### For Maintainers

1. **Monitor CI performance**
   - Check workflow run times
   - Optimize slow jobs
   - Use caching effectively

2. **Keep dependencies updated**
   - Update GitHub Actions versions
   - Update toolchain versions (Foundry, Node.js, Bun)

3. **Review security scans**
   - Weekly scans run automatically
   - Address moderate+ vulnerabilities promptly

4. **Maintain workflow files**
   - Test changes in feature branches first
   - Document any new workflows

## Continuous Deployment

### Current State
- ✅ Continuous Integration (CI) for all components
- ✅ Automated testing and validation
- ⏳ Continuous Deployment (CD) - Not yet implemented

### Future CD Plans

1. **Staging Deployment**
   - Auto-deploy `develop` branch to staging
   - Deploy to Arc testnet
   - Update contract addresses in README

2. **Production Deployment**
   - Deploy `main` branch after manual approval
   - Tag releases with semantic versioning
   - Publish npm packages
   - Deploy frontend to Vercel/Netlify

3. **Docker Registry**
   - Push images to GitHub Container Registry
   - Tag with commit SHA and branch name
   - Enable deployment to Kubernetes/ECS

## Troubleshooting

### Common Issues

**Issue: Forge not found**
```
Solution: Foundry installation step may have failed
- Check foundry-toolchain action version
- Verify network connectivity
```

**Issue: npm ci fails**
```
Solution: package-lock.json out of sync
- Run `npm install` locally and commit lock file
- Ensure Node.js version matches CI (20.x)
```

**Issue: Bun installation fails**
```
Solution: Check Bun setup action
- Verify oven-sh/setup-bun@v2 is latest
- Check if Bun version specified is valid
```

**Issue: Docker build fails**
```
Solution: Check Dockerfile and dependencies
- Test docker-compose locally
- Verify all COPY paths exist
- Check for missing environment variables
```

## Monitoring & Alerts

### GitHub Actions Dashboard
- View all workflow runs: `Actions` tab in repository
- Filter by workflow, branch, status
- Download logs for debugging

### Status Badges
Add to README.md:
```markdown
![CI Status](https://github.com/ctfbindsec/open-compliance-network/workflows/Main%20CI%2FCD/badge.svg)
![Contracts](https://github.com/ctfbindsec/open-compliance-network/workflows/Contracts%20CI/badge.svg)
![Frontend](https://github.com/ctfbindsec/open-compliance-network/workflows/Frontend%20CI/badge.svg)
![Backend](https://github.com/ctfbindsec/open-compliance-network/workflows/Backend%20CI/badge.svg)
```

## Performance Metrics

### Typical Run Times
- Main CI: ~5-8 minutes
- Contracts CI: ~3-5 minutes
- Frontend CI: ~2-3 minutes
- Backend CI: ~1-2 minutes
- PR Checks: ~5-10 minutes (depends on changes)
- Security Scan: ~3-5 minutes

### Optimization Strategies
1. **Caching**
   - npm packages cached by default
   - Bun modules cached
   - Docker layers cached with buildx

2. **Parallel Jobs**
   - Independent jobs run in parallel
   - Multiple test suites can run concurrently

3. **Path Filtering**
   - Only affected components tested
   - Reduces unnecessary CI runs

## Contributing to CI/CD

### Adding New Workflows

1. Create workflow file in `.github/workflows/`
2. Follow naming convention: `component-purpose.yml`
3. Add appropriate triggers (push, pull_request, schedule)
4. Include summary generation with `$GITHUB_STEP_SUMMARY`
5. Test in feature branch before merging
6. Document in this file

### Workflow Template

```yaml
name: New Workflow

on:
  push:
    branches: [main, develop]
    paths:
      - 'relevant/**'

jobs:
  job-name:
    name: Human Readable Name
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Your Step
        run: |
          echo "Do something"
          echo "✅ Step completed" >> $GITHUB_STEP_SUMMARY
```

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Foundry Book](https://book.getfoundry.sh/)
- [Bun Documentation](https://bun.sh/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Chainlink CRE Docs](https://docs.chain.link/cre)

## Support

For CI/CD issues:
1. Check workflow logs in GitHub Actions
2. Consult this documentation
3. Open an issue with `ci/cd` label
4. Tag maintainers for urgent issues
