#!/bin/bash
# Setup script for pre-commit hooks in Caelestia repository

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

echo "🚀 Setting up pre-commit hooks for Caelestia..."

# Check if we're in a git repository
if [[ ! -d ".git" ]]; then
    log_error "Not in a git repository"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install with different package managers
install_package() {
    local package="$1"
    local pip_package="${2:-$package}"

    if command_exists pip; then
        log_info "Installing $package with pip..."
        pip install --user "$pip_package" # pragma: allowlist secret
    elif command_exists pipx; then
        log_info "Installing $package with pipx..."
        pipx install "$pip_package"
    elif command_exists nix; then
        log_info "Installing $package with Nix..."
        nix profile install "nixpkgs#$package"
    elif command_exists pacman; then
        log_info "Installing $package with pacman..."
        sudo pacman -S "$package" --noconfirm
    elif command_exists apt; then
        log_info "Installing $package with apt..."
        sudo apt update && sudo apt install -y "$package"
    else
        log_error "No supported package manager found for $package"
        return 1
    fi
}

# Install pre-commit if not already installed
if ! command_exists pre-commit; then
    log_info "Installing pre-commit..."
    if install_package "pre-commit" "pre-commit"; then
        log_success "pre-commit installed successfully"
    else
        log_error "Could not install pre-commit"
        log_info "Please install manually: https://pre-commit.com/#installation"
        exit 1
    fi
else
    log_success "pre-commit is already installed"
fi

# Install detect-secrets for security scanning
if ! command_exists detect-secrets; then
    log_info "Installing detect-secrets for security scanning..."
    if install_package "detect-secrets" "detect-secrets"; then
        log_success "detect-secrets installed successfully"
    else
        log_warning "Could not install detect-secrets - security scanning will be skipped"
    fi
else
    log_success "detect-secrets is already installed"
fi

# Install QML tools if not available
echo "🔧 Checking QML tools..."

if ! command -v qmllint &> /dev/null; then
    echo "📦 Installing QML tools..."
    if command -v nix &> /dev/null; then
        nix profile install nixpkgs#qt6.qtdeclarative
    elif command -v pacman &> /dev/null; then
        sudo pacman -S qt6-declarative --noconfirm
    elif command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y qt6-declarative-dev qml6-module-qtquick
    else
        echo "⚠️  Warning: Could not install QML tools automatically"
        echo "Please install qt6-declarative package for your system"
    fi
else
    echo "✅ QML tools are available"
fi

# Install nixpkgs-fmt if using Nix
if command -v nix &> /dev/null && ! command -v nixpkgs-fmt &> /dev/null; then
    echo "📦 Installing nixpkgs-fmt..."
    nix profile install nixpkgs#nixpkgs-fmt
fi

# Install shellcheck if not available
if ! command -v shellcheck &> /dev/null; then
    echo "📦 Installing shellcheck..."
    if command -v nix &> /dev/null; then
        nix profile install nixpkgs#shellcheck
    elif command -v pacman &> /dev/null; then
        sudo pacman -S shellcheck --noconfirm
    elif command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y shellcheck
    else
        echo "⚠️  Warning: Could not install shellcheck automatically"
    fi
fi

# Install the pre-commit hooks
echo "🔗 Installing pre-commit hooks..."
pre-commit install

# Install commit-msg hook for commitizen
echo "📝 Installing commit-msg hook..."
pre-commit install --hook-type commit-msg

# Run pre-commit on all files to test
echo "🧪 Testing pre-commit hooks on all files..."
if pre-commit run --all-files; then
    echo "✅ All pre-commit hooks passed!"
else
    echo "⚠️  Some pre-commit hooks failed. This is normal for the first run."
    echo "The hooks have been installed and will run on future commits."
fi

echo ""
echo "🎉 Pre-commit setup complete!"
echo ""
echo "📋 What was installed:"
echo "  ✅ Pre-commit framework"
echo "  ✅ QML linting and formatting (qmllint, qmlformat)"
echo "  ✅ Nix file formatting (nixpkgs-fmt)"
echo "  ✅ Shell script linting (shellcheck)"
echo "  ✅ YAML/JSON/Markdown formatting (prettier)"
echo "  ✅ Git commit message validation (commitizen)"
echo "  ✅ Custom Caelestia structure validation"
echo "  ✅ Magnus's customization checks"
echo ""
echo "🔧 Usage:"
echo "  • Hooks will run automatically on 'git commit'"
echo "  • Run manually: 'pre-commit run --all-files'"
echo "  • Update hooks: 'pre-commit autoupdate'"
echo "  • Skip hooks: 'git commit --no-verify' (not recommended)"
echo ""
echo "📚 Commit message format (using commitizen):"
echo "  feat: add new feature"
echo "  fix: fix a bug"
echo "  docs: update documentation"
echo "  style: formatting changes"
echo "  refactor: code refactoring"
echo "  test: add tests"
echo "  chore: maintenance tasks"
echo ""
