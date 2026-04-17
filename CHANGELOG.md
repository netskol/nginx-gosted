# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Health check to verify GOST engine and Nginx configuration at container startup
- Docker Compose build context for local development builds
- Security hardening: read-only filesystem, capability dropping, no-new-privileges
- Logging configuration with JSON driver and rotation (10MB max, 3 file limit)
- Layer caching optimization in GitHub Actions for faster builds
- Automated version extraction in CI/CD pipeline
- Nginx performance tuning: auto worker processes, gzip compression, HTTP/2 support
- Security headers: HSTS, X-Frame-Options, X-Content-Type-Options, X-XSS-Protection
- Version update automation script (`scripts/update-nginx-version.sh`)

### Changed
- Upgraded GitHub Actions to latest versions (checkout@v4, build-push-action@v5, etc.)
- Refactored Dockerfile: moved GOST config to separate file for better maintainability
- Docker Compose: removed redundant `expose` directive, added `read_only` volumes with tmpfs
- Nginx: enabled TLSv1.3, increased worker connections from 1024 to 4096
- Nginx: added `tcp_nopush`, `tcp_nodelay`, improved buffer management

### Fixed
- Duplicate `engines = engine_section` line in Dockerfile
- Missing `--no-install-recommends` flag reducing layer size

### Security
- Enforced non-root capabilities with CAP_NET_BIND_SERVICE only
- Read-only root filesystem with tmpfs for writable directories
- Set `no-new-privileges` to prevent privilege escalation

## [1.29.1] - 2025-04-17

### Added
- Initial release with Nginx 1.29.1 and GOST engine support
- Multi-architecture builds (linux/amd64, linux/arm64)
- OpenSSL GOST engine for Russian cryptographic standards
- Docker Compose configuration
- Comprehensive README with usage examples
- GitHub Actions workflow for automated builds

[Unreleased]: https://github.com/netskol/nginx-gosted/compare/1.29.1...HEAD
[1.29.1]: https://github.com/netskol/nginx-gosted/releases/tag/1.29.1
