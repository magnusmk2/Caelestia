# Workflow Validation Test

This is a test file to validate that our GitHub Actions workflows are functioning correctly.

## Test Purpose

- Verify PR validation workflow runs on pull requests
- Test all workflow jobs: build-and-test, lint-qml, validate-structure, check-customizations
- Ensure branch protection rules are enforced
- Validate that status checks are required before merge

## Expected Workflow Behavior

1. **build-and-test**: Should build the Nix flake and test shell startup
2. **lint-qml**: Should lint all QML files in the repository
3. **validate-structure**: Should verify project structure integrity
4. **check-customizations**: Should verify Magnus's custom enhancements are present

## Test Results

This file will be removed after successful workflow validation.

---

_Test created on: 2025-08-26_
_Purpose: GitHub Actions workflow validation_
