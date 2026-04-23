# Contributing to Open Compliance Network

Thank you for your interest in contributing to the Open Compliance Network! This guide will help you get started and ensure your contributions align with our development practices.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [CI/CD Pipeline](#cicd-pipeline)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)

## Code of Conduct

We are committed to providing a welcoming and inclusive environment. Please be respectful and considerate in all interactions.

## Getting Started

### 1. Fork and Clone

```bash
# Fork the repository on GitHub, then clone your fork
git clone https://github.com/YOUR-USERNAME/open-compliance-network.git
cd open-compliance-network
```

### 2. Verify Your Environment

Run our environment verification script to ensure you have all required tools:

```bash
./verify-env.sh
```

This checks for:
- Foundry (forge) for smart contracts
- Bun runtime for backend
- Node.js 18+ for frontend
- Git for version control
- Docker (optional) for containerization

### 3. Install Dependencies

```bash
# Contracts
cd contracts && npm install && cd ..

# Frontend
cd frontend && npm install && cd ..

# Backend
cd backend && bun install && cd ..
```

### 4. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-description
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Test additions or updates
- `ci/` - CI/CD improvements

## Development Workflow

### Local Development

```bash
# Start the full stack locally
./start.sh

# Or start components individually:
cd backend && bun run dev
cd frontend && npm run dev
```

### Before Committing

Always run these checks locally to catch issues before CI:

```bash
# Contracts
cd contracts
forge build              # Build contracts
forge test               # Run tests
forge fmt --check        # Check formatting
cd ..

# Frontend
cd frontend
npm run build            # Build production bundle
# npm run lint           # If linter is configured
cd ..

# Backend
cd backend
bun install              # Verify dependencies
bun run --bun tsc --noEmit  # Type check
cd ..
```

## CI/CD Pipeline

Our CI/CD pipeline automatically validates your changes. Understanding it helps you avoid common issues.

### Automated Checks

When you push or open a PR, GitHub Actions will automatically:

1. **Build Validation**
   - Compile smart contracts with Foundry
   - Build frontend with Vite
   - Validate backend with Bun

2. **Testing**
   - Run contract test suite (37 tests)
   - Type checking for TypeScript code

3. **Code Quality**
   - Format checking with `forge fmt`
   - Contract size validation
   - Build size analysis

4. **Security**
   - Dependency vulnerability scanning
   - npm audit for all components

5. **Docker**
   - Validate docker-compose configuration
   - Test Docker image builds

### Workflow Optimization

The pipeline uses **path filtering** to run only relevant checks:

- Changes to `contracts/**` trigger contract workflows
- Changes to `frontend/**` trigger frontend workflows
- Changes to `backend/**` trigger backend workflows
- Changes to `workflows/**` validate CRE workflow structure

This means faster CI times when you're working on a specific component!

### Viewing CI Results

1. Go to your PR on GitHub
2. Scroll to the bottom to see check statuses
3. Click "Details" on any check to see logs
4. Check the "Summary" tab for a quick overview

### CI Failure Troubleshooting

**Contract build fails:**
```bash
# Run locally to see the error
cd contracts && forge build
```

**Frontend build fails:**
```bash
# Type errors or build issues
cd frontend && npm run build
```

**Format check fails:**
```bash
# Auto-fix formatting
cd contracts && forge fmt
```

**Test failures:**
```bash
# Run tests with verbose output
cd contracts && forge test -vvv
```

## Pull Request Process

### 1. Ensure CI Passes

Before requesting review:
- ✅ All CI checks are green
- ✅ No merge conflicts with base branch
- ✅ Code is formatted and linted

### 2. Write a Clear Description

Include:
- **What** you changed
- **Why** you made the change
- **How** to test it
- **Related issues** (if any)

Use the PR template if available.

### 3. Keep Changes Focused

- One feature/fix per PR
- Avoid mixing refactoring with new features
- Keep PRs reasonably sized for review

### 4. Respond to Feedback

- Address review comments promptly
- Ask questions if feedback is unclear
- Update your branch with requested changes

### 5. Merge

Once approved and CI passes:
- Maintainers will merge your PR
- Your changes will be included in the next release

## Coding Standards

### Smart Contracts (Solidity)

```solidity
// Follow existing code style
// Use forge fmt for auto-formatting
// Add NatSpec comments for public functions

/**
 * @notice Brief description
 * @param wallet User wallet address
 * @return isVerified True if wallet is compliant
 */
function isVerified(address wallet) external view returns (bool isVerified);
```

**Best Practices:**
- Use latest Solidity 0.8.26 features
- Follow checks-effects-interactions pattern
- Add comprehensive tests for new functions
- Keep contract sizes within limits

### Frontend (React/TypeScript)

```typescript
// Use TypeScript for type safety
// Follow existing component structure
// Keep components small and focused

interface Props {
  onSubmit: (data: FormData) => void;
}

export const MyComponent: React.FC<Props> = ({ onSubmit }) => {
  // Component implementation
};
```

**Best Practices:**
- Use functional components with hooks
- Extract complex logic to custom hooks
- Type all props and state
- Use Tailwind for styling

### Backend (TypeScript/Bun)

```typescript
// Use Hono framework patterns
// Type all endpoints
// Keep routes modular

app.get('/api/status', (c) => {
  return c.json({ status: 'ok' });
});
```

**Best Practices:**
- Type request/response objects
- Use middleware for auth/validation
- Keep route handlers focused
- Add error handling

### CRE Workflows (TypeScript)

```typescript
// Follow Chainlink CRE patterns
// Use Confidential HTTP for external APIs
// Validate all inputs

export const workflow = {
  name: 'my-workflow',
  triggers: [/* ... */],
  actions: [/* ... */]
};
```

## Testing Guidelines

### Contract Tests

Add tests for all new functionality:

```solidity
function testNewFeature() public {
    // Arrange
    uint256 initialValue = 100;

    // Act
    myContract.doSomething(initialValue);

    // Assert
    assertEq(myContract.getValue(), expectedValue);
}
```

Run with:
```bash
forge test -vvv                    # Verbose output
forge test --match-test testName   # Run specific test
forge coverage                     # Coverage report
```

### Frontend Tests

(Add when test framework is configured)

### Backend Tests

(Add when test framework is configured)

## Additional Resources

- [CI/CD Documentation](.github/CI-CD-PIPELINE.md)
- [Workflow Reference](.github/workflows/README.md)
- [Architecture Docs](./documentation/)
- [Foundry Book](https://book.getfoundry.sh/)
- [Chainlink CRE Docs](https://docs.chain.link/cre)
- [Arc Network Docs](https://docs.arc.network/)

## Getting Help

- **Issues**: Browse or create [GitHub Issues](https://github.com/ctfbindsec/open-compliance-network/issues)
- **Discussions**: Use [GitHub Discussions](https://github.com/ctfbindsec/open-compliance-network/discussions)
- **CI/CD Problems**: Check [CI/CD troubleshooting](.github/CI-CD-PIPELINE.md#troubleshooting)

## Recognition

Contributors will be recognized in:
- Git commit history
- GitHub contributors page
- Release notes (for significant contributions)

Thank you for contributing to Open Compliance Network! 🚀
