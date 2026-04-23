#!/bin/bash
# =============================================================================
# Open Compliance Network - Environment Verification Script
# =============================================================================
# This script checks if your local environment matches CI/CD requirements
# Run before committing to ensure your changes will pass CI checks
# =============================================================================

set -e

FAILED=0
PASSED=0

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Open Compliance Network - Environment Check               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Helper functions
check_command() {
    local cmd=$1
    local name=$2
    local install_url=$3

    if command -v "$cmd" &> /dev/null; then
        local version=$($cmd --version 2>&1 | head -1 || echo "version unavailable")
        echo "✅ $name: $version"
        ((PASSED++))
        return 0
    else
        echo "❌ $name: Not found"
        echo "   Install: $install_url"
        ((FAILED++))
        return 1
    fi
}

check_node_version() {
    if command -v node &> /dev/null; then
        local version=$(node --version | sed 's/v//')
        local major=$(echo "$version" | cut -d. -f1)

        if [ "$major" -ge 18 ]; then
            echo "✅ Node.js: v$version (>= 18 required)"
            ((PASSED++))
            return 0
        else
            echo "⚠️  Node.js: v$version (>= 18 recommended, found v$major)"
            ((FAILED++))
            return 1
        fi
    else
        echo "❌ Node.js: Not found"
        echo "   Install: https://nodejs.org/"
        ((FAILED++))
        return 1
    fi
}

# Check required tools
echo "Checking Required Tools..."
echo "─────────────────────────────────────────────────────────────"
check_command forge "Foundry (forge)" "https://getfoundry.sh/"
check_command bun "Bun" "https://bun.sh/"
check_node_version
check_command git "Git" "https://git-scm.com/"
echo ""

# Check optional tools
echo "Checking Optional Tools..."
echo "─────────────────────────────────────────────────────────────"
check_command docker "Docker" "https://docs.docker.com/get-docker/" || true
check_command docker-compose "Docker Compose" "https://docs.docker.com/compose/install/" || true
check_command npm "npm" "https://nodejs.org/" || true
echo ""

# Check project dependencies
echo "Checking Project Dependencies..."
echo "─────────────────────────────────────────────────────────────"

# Contracts
if [ -d "contracts" ]; then
    cd contracts
    if [ -f "package-lock.json" ] && [ -d "node_modules" ]; then
        echo "✅ Contracts: Dependencies installed"
        ((PASSED++))
    else
        echo "⚠️  Contracts: Run 'cd contracts && npm install'"
        ((FAILED++))
    fi
    cd ..
fi

# Frontend
if [ -d "frontend" ]; then
    cd frontend
    if [ -f "package.json" ] && [ -d "node_modules" ]; then
        echo "✅ Frontend: Dependencies installed"
        ((PASSED++))
    else
        echo "⚠️  Frontend: Run 'cd frontend && npm install'"
        ((FAILED++))
    fi
    cd ..
fi

# Backend
if [ -d "backend" ]; then
    cd backend
    if [ -f "package.json" ] && [ -d "node_modules" ]; then
        echo "✅ Backend: Dependencies installed"
        ((PASSED++))
    else
        echo "⚠️  Backend: Run 'cd backend && bun install'"
        ((FAILED++))
    fi
    cd ..
fi

echo ""
echo "Testing Build Commands..."
echo "─────────────────────────────────────────────────────────────"

# Test contract build
if command -v forge &> /dev/null && [ -d "contracts" ]; then
    echo -n "Testing contract build... "
    if cd contracts && forge build --skip test &> /dev/null; then
        echo "✅ Success"
        ((PASSED++))
    else
        echo "❌ Failed"
        echo "   Try: cd contracts && forge build"
        ((FAILED++))
    fi
    cd ..
fi

# Test frontend build (quick type check)
if command -v npm &> /dev/null && [ -d "frontend" ]; then
    echo -n "Testing frontend type check... "
    if cd frontend && npm run build -- --mode development &> /dev/null; then
        echo "✅ Success"
        ((PASSED++))
    else
        echo "⚠️  Failed (may need dependencies)"
        echo "   Try: cd frontend && npm install && npm run build"
    fi
    cd ..
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Summary                                                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo ""

if [ $FAILED -gt 0 ]; then
    echo "⚠️  Some checks failed. Your environment may not match CI requirements."
    echo "   Review the failures above and install missing dependencies."
    echo ""
    echo "Quick Setup:"
    echo "  1. Install Foundry: curl -L https://foundry.paradigm.xyz | bash && foundryup"
    echo "  2. Install Bun: curl -fsSL https://bun.sh/install | bash"
    echo "  3. Install Node.js 18+: https://nodejs.org/"
    echo "  4. Install dependencies: ./start.sh or manually per component"
    echo ""
    exit 1
else
    echo "✅ All checks passed! Your environment matches CI requirements."
    echo ""
    echo "You're ready to contribute! Before committing, run:"
    echo "  • cd contracts && forge test && forge fmt --check"
    echo "  • cd frontend && npm run build"
    echo "  • cd backend && bun install"
    echo ""
    exit 0
fi
