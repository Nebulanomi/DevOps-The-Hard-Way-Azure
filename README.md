# Changelog

All notable changes to this project will be documented in this file.

## [2025-07-28] - Major Update

### Added
- Kubernetes health checks and readiness probes to deployment manifest
- Auto-scaling configuration for AKS cluster (min: 1, max: 5 nodes)
- Azure availability zones support for improved resilience
- Network policy support for enhanced security
- Automatic upgrade channel for patch updates
- Enhanced resource limits for better performance

### Changed
- **Kubernetes version**: Updated from 1.32 to 1.33
- **Terraform version**: Updated from 1.11.0 to 1.9.8
- **Azure provider**: Updated from 4.27.0 to 4.28.0+
- **Python base image**: Updated from 3.12-slim to 3.13-slim
- **Flask**: Updated from 2.3.3 to 3.0.3
- **Werkzeug**: Updated from 2.3.8 to 3.0.4
- **ALB Controller**: Updated from 1.0.0 to 1.7.9
- **tfsec GitHub Action**: Updated from v1.2.0 to v1.3.0
- **terraform-docs GitHub Action**: Updated from @main to v1.3.0
- **Checkov**: Pinned to specific version 3.2.4 for consistency

### Enhanced
- **AKS Configuration**:
  - Enabled Azure RBAC for improved security
  - Added automatic scaling capabilities
  - Configured network policies for better security
  - Added availability zones for high availability
  - Improved network configuration with DNS and service CIDR

- **Container Configuration**:
  - Increased memory limits from 256Mi to 512Mi
  - Increased CPU limits from 250m to 500m
  - Added liveness and readiness probes
  - Updated container image tag from v1 to v2

- **CI/CD Pipeline**:
  - Enhanced GitHub Actions workflow with latest action versions
  - Added proper commit user email for auto-commit action
  - Updated Terraform version management

### Security Improvements
- Enabled Azure RBAC on AKS cluster for enhanced role-based access control
- Added network policies for better pod-to-pod communication security
- Updated all dependencies to latest secure versions
- Enhanced container security with health checks

### Documentation Updates
- Updated all version references throughout documentation
- Enhanced README with version information table
- Improved setup instructions with latest tool versions
- Added comprehensive changelog for tracking changes

## Previous Versions
- Initial release with Kubernetes 1.32, Terraform 1.11.0, and Python 3.12
