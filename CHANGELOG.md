# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial template structure from marlow-product-template

### Changed

### Deprecated

### Removed

### Fixed

### Security

---

## [Template] - Initial Release

### Added
- Base template structure for Wolram, MSS, VotoData, ms-sousa projects
- `AGENTS.md` - Instructions for Claude and Codex
- `PROJECT_STATUS.md` - Project context and metadata
- `SECURITY.md` - Security guidelines and best practices
- `.github/workflows/ci.yml` - GitHub Actions CI setup
- `.github/workflows/security-check.yml` - Security scanning
- `.codex/` - Codex/Copilot-specific instructions and prompts
- `.claude/` - Claude-specific instructions and prompts
- `docs/` - Technical documentation templates
- `config/` - Configuration templates and examples
- `scripts/` - Automation scripts (setup, audit, deploy)
- `templates/` - Reusable templates for README, landing, pricing, etc
- `prompts/` - AI-friendly prompts organized by function
- `packages/` - Placeholder for shared packages
- `apps/` - Placeholder for applications
- `infra/` - Infrastructure as code placeholders
- `pnpm-workspace.yaml` - Monorepo workspace configuration
- `turbo.json` - Turborepo build configuration
- `package.json` - Root package configuration

### Notes

This is a template repository. When used to create a new project:
1. Clone/fork from this template
2. Run `bash scripts/setup.sh`
3. Run `bash scripts/bootstrap-product.sh "project-name"`
4. Update `PROJECT_STATUS.md` with your project context
5. Customize `.env.example` for your needs
6. Start building!

---

## Version History Format

Use this template for future releases:

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- Feature 1
- Feature 2

### Changed
- Modified behavior of X
- Updated documentation for Y

### Deprecated
- Old API endpoint (will be removed in X.Y+1)

### Removed
- Legacy feature Z

### Fixed
- Bug fix 1
- Bug fix 2

### Security
- Patched vulnerability in dependency X
- Updated security guidelines for Y
```

---

**Guidelines:**
- Add significant changes to `[Unreleased]` as you develop
- Move to version section when releasing
- One line per change
- Reference PRs/issues if relevant: `- Feature X (closes #123)`
- Security fixes should be prominent
- Document breaking changes clearly

---

**Template Created**: 2024
