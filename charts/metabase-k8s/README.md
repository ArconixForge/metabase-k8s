# Metabase Helm Chart

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/metabase-k8s)](https://artifacthub.io/packages/helm/arconixforge/metabase-k8s)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Releases downloads](https://img.shields.io/github/downloads/arconixforge/metabase-k8s/total.svg)](https://github.com/arconixforge/metabase-k8s/releases)

A production-ready Helm chart for deploying [Metabase](https://www.metabase.com/) on Kubernetes with focus on security, scalability, and ease of use.

## Overview

This Helm chart deploys Metabase, an open-source business intelligence tool that lets you create dashboards and visualizations from your company data. The chart includes:

- StatefulSet deployment with configurable persistence
- Support for both H2 (default) and external PostgreSQL databases
- RBAC resources for secure operation
- Security context configurations following best practices
- Istio VirtualService integration
- Comprehensive resource management

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (for persistence)
- Optional: Istio gateway configured for VirtualService support

## Installation

### Add the Helm repository

```bash
helm repo add arconixforge https://arconixforge.github.io/helm-charts
helm repo update
```

### Install the chart

```bash
# Quick start with default values
helm install metabase arconixforge/metabase-k8s

# Custom installation with a values file
helm install metabase arconixforge/metabase-k8s -f values.yaml

# Installation with explicit namespace
helm install metabase arconixforge/metabase-k8s --namespace analytics --create-namespace
```

## Uninstalling the Chart

To uninstall/delete the `metabase` deployment:

```bash
helm uninstall metabase -n analytics
```

## Parameters

### Global parameters

| Name        | Description                                | Value   |
|-------------|--------------------------------------------|---------|
| `enabled`   | Enable or disable the Metabase deployment  | `true`  |

### Image parameters

| Name                | Description                                      | Value             |
|---------------------|--------------------------------------------------|-------------------|
| `image.repository`  | Metabase image repository                        | `metabase/metabase` |
| `image.tag`         | Metabase image tag                               | `v0.53.4.1`       |
| `image.pullPolicy`  | Metabase image pull policy                       | `IfNotPresent`    |

### Deployment parameters

| Name                | Description                                      | Value             |
|---------------------|--------------------------------------------------|-------------------|
| `replicaCount`      | Number of Metabase replicas                      | `1`               |
| `rbac.create`       | Create and use RBAC resources                    | `true`            |

### Security context parameters

| Name                                             | Description                                         | Value       |
|--------------------------------------------------|-----------------------------------------------------|-------------|
| `securityContext.pod.runAsUser`                  | User ID for the pod                                 | `1000`      |
| `securityContext.pod.runAsGroup`                 | Group ID for the pod                                | `3000`      |
| `securityContext.pod.fsGroup`                    | Group ID for volume ownership                       | `2000`      |
| `securityContext.container.runAsNonRoot`         | Run container as non-root user                      | `true`      |
| `securityContext.container.allowPrivilegeEscalation` | Allow privilege escalation                      | `false`     |
| `securityContext.container.readOnlyRootFilesystem` | Mount root filesystem as read-only                | `true`      |

### Service parameters

| Name                | Description                                      | Value             |
|---------------------|--------------------------------------------------|-------------------|
| `service.type`      | Kubernetes service type                          | `ClusterIP`       |
| `service.port`      | Service HTTP port                                | `3000`            |

### Persistence parameters

| Name                       | Description                                      | Value           |
|----------------------------|--------------------------------------------------|-----------------|
| `persistence.enabled`      | Enable persistence storage for Metabase          | `true`          |
| `persistence.storageClass` | StorageClass for database persistence            | `standard-rwo`  |
| `persistence.accessMode`   | PVC access mode                                  | `ReadWriteOnce` |
| `persistence.size`         | PVC storage request size                         | `10Gi`          |

### Metabase database configuration

| Name                       | Description                                      | Value           |
|----------------------------|--------------------------------------------------|-----------------|
| `metabase.env`             | Environment variables for Metabase configuration | See values.yaml |

### Istio VirtualService configuration

| Name                | Description                                      | Value              |
|---------------------|--------------------------------------------------|-------------------|
| `istio.enabled`     | Enable Istio VirtualService                      | `true`            |
| `istio.host`        | Host for VirtualService                          | `istio-host`      |
| `istio.gateway`     | Gateway for VirtualService                       | `istio-gateway`   |
| `istio.prefix`      | URL prefix for Metabase                          | `/path/metabase`  |

### Resource management parameters

| Name                | Description                                      | Value              |
|---------------------|--------------------------------------------------|-------------------|
| `resources.limits`  | Resource limits for Metabase containers          | See values.yaml   |
| `resources.requests`| Resource requests for Metabase containers        | See values.yaml   |

## Database Configuration

The chart supports both the embedded H2 database (default) and external PostgreSQL:

### Using the embedded H2 database (default)

This is suitable for testing or small deployments:

```yaml
metabase:
  env:
    - name: MB_PLUGINS_DIR
      value: "/plugins"
    - name: MB_DB_FILE
      value: "/metabase-data/metabase.db"
```

### Using external PostgreSQL

For production deployments, configure external PostgreSQL:

```yaml
metabase:
  env:
    - name: MB_DB_TYPE
      value: "postgres"
    - name: MB_DB_HOST
      value: "postgres-host"
    - name: MB_DB_PORT
      value: "5432"
    - name: MB_DB_DBNAME
      value: "metabase_db"
    - name: MB_DB_USER
      value: "postgres-user"
    - name: MB_DB_PASS
      value: "postgres-password"
    - name: MB_DB_SCHEMA
      value: "metabase_schema"
```

## Security

This chart implements several security best practices:

1. Running as non-root user
2. Using a read-only root filesystem
3. Dropping all capabilities
4. Preventing privilege escalation
5. Setting proper RBAC permissions

## Istio Integration

The chart includes Istio VirtualService support for integration with Istio service mesh:

```yaml
istio:
  enabled: true
  host: "your-domain.com"
  gateway: "your-gateway"
  prefix: "/metabase"
```

## Persistence

Data persistence using PVCs is enabled by default. An appropriate storage class should be configured to match your environment.

## Upgrading

### To 1.0.0

This is the first stable release of the chart. Future releases will follow semantic versioning.

## License

Copyright &copy; 2025 ArconixForge

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.