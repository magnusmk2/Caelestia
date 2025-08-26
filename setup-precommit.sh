#!/bin/bash
# Setup script for pre-commit hooks in Caelestia repository

set -e

echo "🚀 Setting up pre-commit hooks for Caelestia..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Install pre-commit if not already installed
if ! command -v pre-commit &> /dev/null; then
    echo "📦 Installing pre-commit..."

    # Try different installation methods
    if command -v pip &> /dev/null; then
        pip install --user pre-commit
    elif command -v pipx &> /dev/null; then
        pipx install pre-commit
    elif command -v nix &> /dev/null; then
        echo "Using Nix to install pre-commit..."
        nix profile install nixpkgs#pre-commit
    else
        echo "❌ Error: Could not find pip, pipx, or nix to install pre-commit"
        echo "Please install pre-commit manually: https://pre-commit.com/#installation"
        exit 1
    fi
else
    echo "✅ pre-commit is already installed"
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
