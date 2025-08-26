# Pre-commit Hooks for Caelestia

This repository uses [pre-commit](https://pre-commit.com/) to ensure code quality and consistency before commits reach the repository.

## 🎯 **Research-Based Best Practices**

This configuration follows modern pre-commit best practices based on:

- Official pre-commit documentation (2024)
- Real-world Qt/QML projects (e.g., Zrythm)
- Industry standards for code quality automation
- Performance optimization for development workflows

## 🚀 Quick Setup

Run the setup script to install and configure everything:

```bash
./setup-precommit.sh
```

## 🔧 Manual Setup

If you prefer manual setup:

```bash
# Install pre-commit
pip install pre-commit
# or
pipx install pre-commit
# or (with Nix)
nix profile install nixpkgs#pre-commit

# Install the hooks
pre-commit install
pre-commit install --hook-type commit-msg

# Test on all files
pre-commit run --all-files
```

## 📋 Configured Hooks

### General File Checks

- **Trailing whitespace removal**
- **End-of-file fixer**
- **YAML/JSON/TOML/XML validation**
- **Merge conflict detection**
- **Large file detection** (max 1MB)
- **Line ending normalization** (LF)

### QML & JavaScript

- **qmllint**: Syntax and style validation for QML files
- **qmlformat**: Consistent QML code formatting

### Nix Files

- **nixpkgs-fmt**: Nix file formatting
- **nix flake check**: Flake validation

### Shell Scripts

- **shellcheck**: Shell script linting and best practices

### Documentation

- **prettier**: YAML, JSON, and Markdown formatting

### Git Commits

- **commitizen**: Enforces conventional commit message format

### Custom Caelestia Validation

- **Project structure validation**: Ensures required directories exist
- **Magnus's customizations check**: Verifies custom enhancements are preserved
- **Nix flake validation**: Checks flake configuration

## 📝 Commit Message Format

This repository uses [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>: <description>

[optional body]

[optional footer]
```

### Types:

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

### Examples:

```bash
git commit -m "feat: add monitor bit depth switching"
git commit -m "fix: resolve network service ethernet detection"
git commit -m "docs: update installation instructions"
```

## 🛠️ Usage

### Automatic (Recommended)

Hooks run automatically on every commit:

```bash
git add .
git commit -m "feat: your changes"
# Hooks run automatically and may modify files
# If files are modified, you'll need to add and commit again
```

### Manual Execution

Run hooks manually on all files:

```bash
pre-commit run --all-files
```

Run specific hook:

```bash
pre-commit run qmllint
pre-commit run check-magnus-customizations
```

### Updating Hooks

Update to latest versions:

```bash
pre-commit autoupdate
```

### Bypassing Hooks (Not Recommended)

In emergencies only:

```bash
git commit --no-verify -m "emergency fix"
```

## 🔍 Hook Details

### QML Validation

- Validates QML syntax and imports
- Enforces consistent formatting
- Checks for common QML anti-patterns

### Caelestia Structure Validation

Ensures these directories exist:

- `modules/` - UI modules
- `services/` - Background services
- `components/` - Reusable components
- `config/` - Configuration files
- `utils/` - Utility functions

### Magnus's Customizations Check

Validates that custom enhancements are preserved:

- Network service ethernet connections
- VPN status detection (Mullvad)
- Monitor management UI
- BitDepth service functionality

### Nix Integration

- Validates flake.nix syntax
- Checks flake.lock consistency
- Formats Nix files consistently

## 🚨 Troubleshooting

### Hook Failures

If a hook fails:

1. Read the error message carefully
2. Fix the reported issues
3. Add the fixed files: `git add .`
4. Commit again: `git commit -m "your message"`

### Missing Dependencies

If you get "command not found" errors:

```bash
# Install QML tools
nix profile install nixpkgs#qt6.qtdeclarative

# Install other tools
nix profile install nixpkgs#shellcheck
nix profile install nixpkgs#nixpkgs-fmt
```

### Slow Hooks

Some hooks (especially Nix flake check) can be slow. This is normal and ensures quality.

### Disabling Specific Hooks

Edit `.pre-commit-config.yaml` and add to the hook:

```yaml
- id: hook-name
  stages: [manual] # Only run manually
```

## 📊 Integration with CI/CD

Pre-commit hooks complement the GitHub Actions workflows:

- **Pre-commit**: Catches issues locally before push
- **GitHub Actions**: Validates on the server and runs comprehensive tests

This creates a robust quality assurance pipeline:

1. Pre-commit hooks (local validation)
2. GitHub Actions PR validation (server-side testing)
3. Branch protection (prevents broken code in main)

## 🎯 Benefits

- **Faster feedback**: Catch issues before pushing
- **Consistent code style**: Automatic formatting
- **Reduced CI failures**: Many issues caught locally
- **Better commit history**: Enforced commit message format
- **Preserved customizations**: Validates Magnus's enhancements
- **Team collaboration**: Consistent development environment
