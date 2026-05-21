[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Application

Generic Helm chart for deploying stateless applications on Kubernetes. Supports Deployments, Jobs, and CronJobs along with common companion resources (Services, Ingress, RBAC, autoscaling, monitoring, certificates, and more).

## Installing the Chart

### From the OCI registry

```shell
helm install my-application oci://ghcr.io/stakater/charts/application --namespace test
# or, to install a specific version
helm install my-application oci://ghcr.io/stakater/charts/application --version <version> --namespace test
```

### From the Helm repository (deprecated)

> **Note:** The Helm repository is deprecated in favor of the OCI registry above.

```shell
helm repo add stakater https://stakater.github.io/stakater-charts
helm repo update
helm install my-application stakater/application --namespace test
# or, to install a specific version
helm install my-application stakater/application --version <version> --namespace test
```

## Uninstall the Chart

To uninstall the chart:

```shell
helm delete --namespace test my-application
```

## CI scope

The CI validates the chart against upstream Kubernetes using Helm and Kind. These jobs should be configured as required status checks in branch protection rules.

Server-side API validation runs against Kubernetes v1.31, v1.33, and v1.35. The chart uses `Capabilities.APIVersions` fallbacks for legacy APIs (`batch/v1beta1`, `policy/v1beta1`, `autoscaling/v2beta2`), but these were removed from Kubernetes before v1.25. Only the stable API paths are exercised in CI.

Kind validation uses a Kubernetes-compatible values profile that excludes non-standard resources (CRDs, OpenShift routes, etc.). Resources that depend on CRDs or platform-specific APIs are only validated as template rendering (no server-side check).

## Values Schema

The chart ships with a [JSON Schema](application/values.schema.json) for `values.yaml` validation. When using an editor that supports JSON Schema (e.g. VS Code with the YAML extension), you get autocompletion and inline validation out of the box.

## Contributing

Please refer to the [Contributing Guide](CONTRIBUTING.md) for details on how to set up your local environment and submit changes.

## Values

### Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| namespaceOverride | string, null | `""` | Override the namespace for all resources. |
| componentOverride | string, null | `""` | Override the component label for all resources. |
| partOfOverride | string, null | `""` | Override the partOf label for all resources. |
| applicationName | string, null | `{{ .Release.Name }}` | Application name. Used as a prefix for all resource names. |
| additionalLabels | object, null | `nil` | Additional labels for all resources. Keys and values are evaluated as templates. |
| extraObjects | list, object, null | `nil` | Extra K8s manifests to deploy. Can be of type list or object. If object, keys are ignored and only values are used. The used values can be defined as object or string and are evaluated as templates. |

### CronJob Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cronJob.enabled | bool | `false` | Deploy CronJob resources. |
| cronJob.jobs | object, null | `nil` | Map of CronJob resources. Key will be used as a name suffix for the CronJob. Value is the CronJob configuration. See values for more details. |

### Job Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| job.enabled | bool | `false` | Deploy Job resources. |
| job.jobs | object, null | `nil` | Map of Job resources. Key will be used as a name suffix for the Job. Value is the Job configuration. See values for more details. |

### Deployment Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| deployment.enabled | bool | `true` | Enable Deployment. |
| deployment.additionalLabels | object, null | `nil` | Additional labels for Deployment. |
| deployment.podLabels | object, null | `nil` | Additional pod labels which are used in Service's Label Selector. |
| deployment.annotations | object, null | `nil` | Annotations for Deployment. |
| deployment.additionalPodAnnotations | object, null | `nil` | Additional pod annotations. |
| deployment.strategy.type | string | `"RollingUpdate"` | Type of deployment strategy. |
| deployment.reloadOnChange | bool | `true` | Reload deployment if attached Secret/ConfigMap changes. |
| deployment.nodeSelector | object, null | `nil` | Select the node where the pods should be scheduled. |
| deployment.hostAliases | list | `nil` | Mapping between IP and hostnames that will be injected as entries in the pod's hosts files. |
| deployment.initContainers | object, null | `nil` | Add init containers to the pods. |
| deployment.fluentdConfigAnnotations | object, null | `nil` | Configuration details for fluentdConfigurations. Only works for specific setup, see <https://medium.com/stakater/dynamic-log-processing-with-fluentd-konfigurator-and-slack-935a5de4eddb>. |
| deployment.replicas | int | `nil` | Number of replicas. |
| deployment.imagePullSecrets | list | `[]` | List of secrets to be used for pulling the images. |
| deployment.envFrom | object, null | `nil` | Mount environment variables from ConfigMap or Secret to the pod. Use `nameSuffix` for resources managed by this chart (name will be prefixed with application name), or `name` to reference an existing external ConfigMap or Secret not managed by this chart. See the README "Consuming environment variable in application chart" section for more details. |
| deployment.env | object, null | `nil` | Environment variables to be added to the pod. See the README "Consuming environment variable in application chart" section for more details. |
| deployment.volumes | object, null | `nil` | Volumes to be added to the pod. Key is the name of the volume. Value is the volume definition. |
| deployment.volumeMounts | object, null | `nil` | Mount path for Volumes. Key is the name of the volume. Value is the volume mount definition. |
| deployment.priorityClassName | string, null | `""` | Define the priority class for the pod. |
| deployment.runtimeClassName | string, null | `""` | Set the runtimeClassName for the deployment's pods. |
| deployment.tolerations | list | `nil` | Taint tolerations for the pods. |
| deployment.affinity | object, null | `nil` | Affinity for the pods. |
| deployment.topologySpreadConstraints | list | `nil` | Topology spread constraints for the pods. |
| deployment.revisionHistoryLimit | int | `2` | Number of ReplicaSet revisions to retain. |
| deployment.image.repository | tpl | `""` | Repository. |
| deployment.image.tag | tpl | `""` | Tag. |
| deployment.image.digest | tpl | `""` | Image digest. If resolved to a non-empty value, digest takes precedence on the tag. |
| deployment.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| deployment.dnsConfig | object, null | `nil` | DNS config for the pods. |
| deployment.dnsPolicy | string, null | `""` | DNS Policy. |
| deployment.enableServiceLinks | bool | `true` | Enable Kubernetes service links. |
| deployment.startupProbe | object, null | See below | Startup probe. Must specify either one of the following field when enabled: httpGet, exec, tcpSocket, grpc |
| deployment.startupProbe.enabled | bool | `false` | Enable Startup probe. |
| deployment.startupProbe.failureThreshold | int | `30` | Number of retries before marking the pod as failed. |
| deployment.startupProbe.periodSeconds | int | `10` | Time between retries. |
| deployment.startupProbe.successThreshold | int | `1` | Number of successful probes before marking the pod as ready. |
| deployment.startupProbe.timeoutSeconds | int | `1` | Time before the probe times out. |
| deployment.startupProbe.httpGet | object | `{}` | HTTP Get probe. |
| deployment.startupProbe.exec | object | `{}` | Exec probe. |
| deployment.startupProbe.tcpSocket | object | `{}` | TCP Socket probe. |
| deployment.startupProbe.grpc | object | `{}` | gRPC probe. |
| deployment.readinessProbe | object, null | See below | Readiness probe. Must specify either one of the following field when enabled: httpGet, exec, tcpSocket, grpc |
| deployment.readinessProbe.enabled | bool | `false` | Enable Readiness probe. |
| deployment.readinessProbe.failureThreshold | int | `30` | Number of retries before marking the pod as failed. |
| deployment.readinessProbe.periodSeconds | int | `10` | Time between retries. |
| deployment.readinessProbe.successThreshold | int | `1` | Number of successful probes before marking the pod as ready. |
| deployment.readinessProbe.timeoutSeconds | int | `1` | Time before the probe times out. |
| deployment.readinessProbe.httpGet | object | `{}` | HTTP Get probe. |
| deployment.readinessProbe.exec | object | `{}` | Exec probe. |
| deployment.readinessProbe.tcpSocket | object | `{}` | TCP Socket probe. |
| deployment.readinessProbe.grpc | object | `{}` | gRPC probe. |
| deployment.livenessProbe | object, null | See below | Liveness probe. Must specify either one of the following field when enabled: httpGet, exec, tcpSocket, grpc |
| deployment.livenessProbe.enabled | bool | `false` | Enable Liveness probe. |
| deployment.livenessProbe.failureThreshold | int | `30` | Number of retries before marking the pod as failed. |
| deployment.livenessProbe.periodSeconds | int | `10` | Time between retries. |
| deployment.livenessProbe.successThreshold | int | `1` | Number of successful probes before marking the pod as ready. |
| deployment.livenessProbe.timeoutSeconds | int | `1` | Time before the probe times out. |
| deployment.livenessProbe.httpGet | object | `{}` | HTTP Get probe. |
| deployment.livenessProbe.exec | object | `{}` | Exec probe. |
| deployment.livenessProbe.tcpSocket | object | `{}` | TCP Socket probe. |
| deployment.livenessProbe.grpc | object | `{}` | gRPC probe. |
| deployment.resources | object | `{}` | Resource limits and requests for the pod. |
| deployment.containerSecurityContext | object, null | `{"readOnlyRootFilesystem":true,"runAsNonRoot":true}` | Security Context at Container Level. |
| deployment.openshiftOAuthProxy.enabled | bool | `false` | Enable [OpenShift OAuth Proxy](https://github.com/openshift/oauth-proxy). |
| deployment.openshiftOAuthProxy.port | int | `8080` | Port on which application is running inside container. |
| deployment.openshiftOAuthProxy.secretName | string | `"openshift-oauth-proxy-tls"` | Secret name for the OAuth Proxy TLS certificate. |
| deployment.openshiftOAuthProxy.image | string | `"openshift/oauth-proxy:latest"` | Image for the OAuth Proxy. |
| deployment.openshiftOAuthProxy.disableTLSArg | bool | `false` | If disabled `--http-address=:8081` will be used instead of `--https-address=:8443`. It can be useful when an ingress is enabled for the application. |
| deployment.securityContext | object, null | `nil` | Security Context for the pod. |
| deployment.command | list | `[]` | Command for the app container. |
| deployment.args | list | `[]` | Args for the app container. |
| deployment.automountServiceAccountToken | bool | `false` | Mount Service Account token. |
| deployment.ports | list | `nil` | List of ports for the app container. |
| deployment.hostNetwork | bool | `nil` | Host network connectivity. |
| deployment.terminationGracePeriodSeconds | int | `nil` | Gracefull termination period. |
| deployment.minReadySeconds | int | `nil` | Minimum number of seconds for which a newly created Pod should be ready without any of its containers crashing. |
| deployment.lifecycle | object | `{}` | Lifecycle configuration for the pod. |
| deployment.additionalContainers | list | `nil` | Additional containers besides init and app containers (without templating). |
| persistence.enabled | bool | `false` | Enable persistence. |
| persistence.mountPVC | bool | `false` | Whether to mount the created PVC to the deployment. |
| persistence.mountPath | string | `"/"` | If `persistence.mountPVC` is enabled, where to mount the volume in the containers. |
| persistence.name | string, null | `{{ include "application.name" $ }}-data` | Name of the PVC. |
| persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for volume. |
| persistence.storageClass | string | `nil` | Storage class for volume. If defined, use that value If set to "-" or "", disable dynamic provisioning If undefined or set to null (the default), no storageClass spec is   set, choosing the default provisioner. |
| persistence.additionalLabels | object, null | `nil` | Additional labels for persistent volume. |
| persistence.annotations | object, null | `nil` | Annotations for persistent volume. |
| persistence.storageSize | string | `"8Gi"` | Size of the persistent volume. |
| persistence.volumeMode | string, null | `""` | PVC Volume Mode. |
| persistence.volumeName | string, null | `""` | Name of the volume. |

### Service Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| service.enabled | bool | `true` | Enable Service. |
| service.additionalLabels | object, null | `nil` | Additional labels for service. |
| service.annotations | object, null | `nil` | Annotations for service. |
| service.ports | list | `[{"name":"http","port":8080,"protocol":"TCP","targetPort":8080}]` | Ports for applications service. |
| service.ports[0].targetPort | int, string, null | `8080` | Target port on pods. Accepts port number or port name (IANA_SVC_NAME). |
| service.type | string | `"ClusterIP"` | Type of service. |
| service.clusterIP | string, null | `nil` | Fixed IP for a ClusterIP service. Set to `None` for an headless service |
| service.loadBalancerClass | string, null | `nil` | LoadBalancer class name for LoadBalancer type services. |

### Ingress Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.enabled | bool | `false` | Enable Ingress. |
| ingress.ingressClassName | string, null | `""` | Name of the ingress class. |
| ingress.hosts[0].host | tpl | `"chart-example.local"` | Hostname. |
| ingress.hosts[0].paths[0].path | string | `"/"` | Path. |
| ingress.hosts[0].paths[0].pathType | string, null | `ImplementationSpecific` | Path type. |
| ingress.hosts[0].paths[0].serviceName | string, null | `{{ include "application.name" $ }}` | Service name. |
| ingress.hosts[0].paths[0].servicePort | string, null | `http` | Service port. |
| ingress.additionalLabels | object, null | `nil` | Additional labels for ingress. |
| ingress.annotations | object, null | `nil` | Annotations for ingress. |
| ingress.tls | list | `nil` | TLS configuration for ingress. Secrets must exist in the namespace. You may also configure Certificate resource to generate the secret. |

### HTTPRoute Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| httpRoute.enabled | bool | `false` | Enable HTTPRoute (Gateway API). |
| httpRoute.parentRefs | list | `nil` | Parent references for the HTTPRoute. Keys and values are evaluated as templates. |
| httpRoute.useDefaultGateways | string, null | `nil` | The default Gateway scope to use for this Route. If unset (the default) or set to None, the Route will not be attached to any default Gateway; if set, it will be attached to any default Gateway supporting the named scope, subject to the usual rules about which Routes a Gateway is allowed to claim. |
| httpRoute.gatewayNamespace | string, null | `""` | Namespace of the Gateway to attach this HTTPRoute to. If not set, the HTTPRoute will be attached to the Gateway in the same namespace as the HTTPRoute. |
| httpRoute.hostnames | list | `nil` | Hostnames for the HTTPRoute. Values are evaluated as templates. |
| httpRoute.additionalLabels | object | `{}` | Additional labels for HTTPRoute. |
| httpRoute.annotations | object | `{}` | Annotations for HTTPRoute. |
| httpRoute.rules | list | `[{"backendRefs":[{"name":"{{ include \"application.name\" $ }}","port":"{{ (first $.Values.service.ports).port }}"}],"matches":[{"path":{"type":"PathPrefix","value":"/"}}]}]` | Rules for HTTPRoute. Keys and values are evaluated as templates. |
| httpRoute.rules[0].backendRefs[0].port | int, tpl, null | `"{{ (first $.Values.service.ports).port }}"` | Port number or template expression for the backend service. |

### Route Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| route.enabled | bool | `false` | Deploy a Route (OpenShift) resource. |
| route.additionalLabels | object, null | `nil` | Additional labels for Route. |
| route.annotations | object, null | `nil` | Annotations for Route. |
| route.host | string, null | `nil` | Explicit host. If no host is added then openshift inserts the default hostname. |
| route.path | string, null | `nil` | Path. |
| route.port | object, null | `{"targetPort":"http"}` | Service port. |
| route.to.weight | int | `100` | Service weight. |
| route.wildcardPolicy | string | `"None"` | Wildcard policy. |
| route.tls.termination | string | `"edge"` | TLS termination strategy. |
| route.tls.insecureEdgeTerminationPolicy | string | `"Redirect"` | TLS insecure termination policy. |
| route.alternateBackends | object, null | `nil` | Alternate backend with it's weight. |

### SecretProviderClass Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secretProviderClass.enabled | bool | `false` | Deploy a [Secrets Store CSI Driver SecretProviderClass](https://secrets-store-csi-driver.sigs.k8s.io/) resource. |
| secretProviderClass.name | string, null | `""` | Name of the SecretProviderClass. Required if `secretProviderClass.enabled` is set to `true`. |
| secretProviderClass.provider | string, null | `""` | Name of the provider. Required if `secretProviderClass.enabled` is set to `true`. |
| secretProviderClass.vaultAddress | string, null | `""` | Vault Address. Required if `secretProviderClass.provider` is set to `vault`. |
| secretProviderClass.roleName | tpl | `""` | Vault Role Name. Required if `secretProviderClass.provider` is set to `vault`. |
| secretProviderClass.objects | string, null | `nil` | Objects definitions. |
| secretProviderClass.secretObjects | list | `nil` | Objects mapping. |

### ForecastleApp Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| forecastle.enabled | bool | `false` | Deploy a [ForecastleApp](https://github.com/stakater/Forecastle) resource. |
| forecastle.additionalLabels | object, null | `nil` | Additional labels for ForecastleApp. |
| forecastle.icon | string | `"https://raw.githubusercontent.com/stakater/ForecastleIcons/master/stakater-big.png"` | Icon URL. |
| forecastle.displayName | string, null | `""` | Application Name. Required if `forecastle.enabled` is set to `true`. |
| forecastle.group | string, null | `{{ .Release.Namespace }}` | Application Group. |
| forecastle.properties | object, null | `nil` | Custom properties. |
| forecastle.networkRestricted | bool | `false` | Is application network restricted?. |

### RBAC Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| rbac.enabled | bool | `true` | Enable RBAC. |
| rbac.serviceAccount.create | bool | `false` | Specifies whether to create a dedicated service account. If set to `true`, a new service account will be created. |
| rbac.serviceAccount.name | string, null | `""` | The name of the service account. Behavior based on its value and `rbac.serviceAccount.create`: If `rbac.serviceAccount.create` is `false` and `name` is empty, the default service account ("default") is used. If `rbac.serviceAccount.create` is `false` and `name` is set, the provided name is used. If `rbac.serviceAccount.create` is `true` and `name` is empty, a name is auto-generated using the fullname template. If `rbac.serviceAccount.create` is `true` and `name` is set, the provided name is used for creation. |
| rbac.serviceAccount.additionalLabels | object, null | `nil` | Additional labels for Service Account. If `rbac.serviceAccount.create` is set to true, these labels are appended to the service account. |
| rbac.serviceAccount.annotations | object, null | `nil` | Annotations for Service Account. If `rbac.serviceAccount.create` is set to true, these annotations are appended to the service account. |
| rbac.roles | list | `nil` | Role definitions scoped to a single namespace. |
| rbac.clusterRoles | list | `nil` | ClusterRole definitions with cluster-wide permissions. |
| rbac.additionalLabels | object, null | `nil` | Additional labels for the Role, RoleBinding, ClusterRole, and ClusterRoleBinding resources. |
| rbac.annotations | object, null | `nil` | Annotations for the Role, RoleBinding, ClusterRole, and ClusterRoleBinding resources. |

### ConfigMap Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMap.enabled | bool | `false` | Deploy additional ConfigMaps. |
| configMap.additionalLabels | object, null | `nil` | Additional labels for ConfigMaps. |
| configMap.annotations | object, null | `nil` | Annotations for ConfigMaps. |
| configMap.files | object, null | `nil` | List of ConfigMap entries. Key will be used as a name suffix for the ConfigMap. Value is the ConfigMap content. |

### SealedSecret Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sealedSecret.enabled | bool | `false` | Deploy [SealedSecret](https://github.com/bitnami-labs/sealed-secrets) resources. |
| sealedSecret.additionalLabels | object, null | `nil` | Additional labels for SealedSecret. |
| sealedSecret.annotations | object, null | `nil` | Annotations for SealedSecret. |
| sealedSecret.files | object, null | `nil` | List of SealedSecret entries. Key will be used as a name suffix for the SealedSecret. Value is the SealedSecret content. |

### Secret Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secret.enabled | bool | `false` | Deploy additional Secret resources. |
| secret.additionalLabels | object, null | `nil` | Additional labels for Secret. |
| secret.annotations | object, null | `nil` | Annotations for Secret. |
| secret.files | object, null | `nil` | List of Secrets entries. Key will be used as a name suffix for the Secret. There a three allowed modes: - `data`: Data is base64 encoded by the chart - `encodedData`: Use raw values (already base64ed) inside the data map - `stringData`: Use raw values inside the stringData map |

### ServiceMonitor Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| serviceMonitor.enabled | bool | `false` | Deploy a ServiceMonitor (Prometheus Operator) resource. |
| serviceMonitor.additionalLabels | object, null | `nil` | Additional labels for ServiceMonitor. |
| serviceMonitor.annotations | object, null | `nil` | Annotations for ServiceMonitor. |
| serviceMonitor.endpoints | list | `[{"interval":"5s","path":"/actuator/prometheus","port":"http"}]` | Service endpoints from which prometheus will scrape data. |

### Autoscaling - Horizontal Pod Autoscaling Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscaling.enabled | bool | `false` | Enable Horizontal Pod Autoscaling. |
| autoscaling.additionalLabels | object, null | `nil` | Additional labels for HPA. |
| autoscaling.annotations | object, null | `nil` | Annotations for HPA. |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas. |
| autoscaling.maxReplicas | int | `10` | Maximum number of replicas. |
| autoscaling.metrics | list | `[{"resource":{"name":"cpu","target":{"averageUtilization":60,"type":"Utilization"}},"type":"Resource"},{"resource":{"name":"memory","target":{"averageUtilization":60,"type":"Utilization"}},"type":"Resource"}]` | Metrics used for autoscaling. |

### VPA - Vertical Pod Autoscaler Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| vpa.enabled | bool | `false` | Enable Vertical Pod Autoscaling. |
| vpa.additionalLabels | object, null | `nil` | Additional labels for VPA. |
| vpa.annotations | object, null | `nil` | Annotations for VPA. |
| vpa.containerPolicies | list | `[]` | Container policies for individual containers. |
| vpa.updatePolicy | object, null | `{"updateMode":"Auto"}` | Update policy. |

### EndpointMonitor Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| endpointMonitor.enabled | bool | `false` | Deploy an [IMC EndpointMonitor](https://github.com/stakater/IngressMonitorController) resource. |
| endpointMonitor.additionalLabels | object, null | `nil` | Additional labels for EndpointMonitor. |
| endpointMonitor.annotations | object, null | `nil` | Annotations for EndpointMonitor. |

### cert-manager Certificate Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certificate.enabled | bool | `false` | Deploy a [cert-manager Certificate](https://cert-manager.io) resource. |
| certificate.additionalLabels | object, null | `nil` | Additional labels for Certificate. |
| certificate.annotations | object, null | `nil` | Annotations for Certificate. |
| certificate.secretName | tpl | `"tls-cert"` | Name of the secret resource that will be automatically created and managed by this Certificate resource. |
| certificate.duration | string | `"8760h0m0s"` | The requested "duration" (i.e. lifetime) of the Certificate. |
| certificate.renewBefore | string | `"720h0m0s"` | The amount of time before the currently issued certificate's notAfter time that cert-manager will begin to attempt to renew the certificate. |
| certificate.subject | object, null | `nil` | Full X509 name specification for certificate. Keys and values are evaluated as templates. |
| certificate.commonName | tpl | `nil` | Common name as specified on the DER encoded CSR. This field is not recommended in cases when this certificate is an end-entity certificate. More information can be found in the [cert-manager documentation](https://cert-manager.io/docs/usage/certificate/#:~:text=%23%20Avoid%20using%20commonName,%3A%20example.com). |
| certificate.keyAlgorithm | string | `"RSA"` | Private key algorithm of the corresponding private key for this certificate. |
| certificate.keyEncoding | string | `"PKCS1"` | Private key cryptography standards (PKCS) for this certificate's private key to be encoded in. |
| certificate.keySize | int | `2048` | Key bit size of the corresponding private key for this certificate. |
| certificate.isCA | bool | `false` | Mark this Certificate as valid for certificate signing. |
| certificate.usages | list | `nil` | Set of x509 usages that are requested for the certificate. |
| certificate.dnsNames | list | `nil` | List of DNS subjectAltNames to be set on the certificate. Keys and values are evaluated as templates. |
| certificate.ipAddresses | list | `nil` | List of IP address subjectAltNames to be set on the certificate. |
| certificate.uriSANs | list | `nil` | List of URI subjectAltNames to be set on the certificate. |
| certificate.emailSANs | list | `nil` | List of email subjectAltNames to be set on the Certificate. |
| certificate.privateKey.enabled | bool | `false` | Enable Private Key for the certificate. |
| certificate.privateKey.rotationPolicy | string | `"Always"` | Denotes how private keys should be generated or sourced when a certificate is being issued. |
| certificate.issuerRef.name | string | `"ca-issuer"` | Reference to the issuer for this certificate. |
| certificate.issuerRef.kind | string | `"ClusterIssuer"` | Kind of the issuer being referred to. |
| certificate.issuerRef.group | string | `"cert-manager.io"` | Group of the issuer resource being refered to. |
| certificate.keystores.enabled | bool | `false` | Enables keystore configuration. Keystores configures additional keystore output formats stored in the spec.secretName Secret resource. |
| certificate.keystores.pkcs12.create | bool | `true` | Enables PKCS12 keystore creation for the Certificate. PKCS12 configures options for storing a PKCS12 keystore in the spec.secretName Secret resource. |
| certificate.keystores.pkcs12.key | string | `"test_key"` | Key of the entry in the Secret resource's data field to be used. |
| certificate.keystores.pkcs12.name | string | `"test-creds"` | Name of the Secret resource being referred to. |
| certificate.keystores.jks.create | bool | `false` | Enables jks keystore creation for the Certificate. JKS configures options for storing a JKS keystore in the spec.secretName Secret resource. |
| certificate.keystores.jks.key | tpl | `"test_key"` | Key of the entry in the Secret resource's data field to be used. |
| certificate.keystores.jks.name | string | `"test-creds"` | Name of the Secret resource being referred to. |

### AlertmanagerConfig Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| alertmanagerConfig.enabled | bool | `false` | Deploy an AlertmanagerConfig (Prometheus Operator) resource. |
| alertmanagerConfig.selectionLabels | object, null | `{"alertmanagerConfig":"workload"}` | Labels to be picked up by Alertmanager to add it to base config. Read more about it at [https://docs.openshift.com/container-platform/4.7/rest_api/monitoring_apis/alertmanager-monitoring-coreos-com-v1.html](OpenShift's AlermanagerConfig documentation) under .spec.alertmanagerConfigSelector. |
| alertmanagerConfig.spec | object, null | `{"inhibitRules":[],"receivers":[],"route":null}` | AlertmanagerConfig spec. Read more about it at [https://docs.openshift.com/container-platform/4.7/rest_api/monitoring_apis/alertmanagerconfig-monitoring-coreos-com-v1alpha1.html](OpenShift's AlermanagerConfig documentation). |
| alertmanagerConfig.spec.route | object, null | `nil` | Route definition for alerts matching the resource’s namespace. It will be added to the generated Alertmanager configuration as a first-level route. |
| alertmanagerConfig.spec.receivers | list | `[]` | List of receivers. |
| alertmanagerConfig.spec.inhibitRules | list | `[]` | Inhibition rules that allows to mute alerts when other alerts are already firing. |

### PrometheusRule Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| prometheusRule.enabled | bool | `false` | Deploy a PrometheusRule (Prometheus Operator) resource. |
| prometheusRule.additionalLabels | object, null | `nil` | Additional labels for PrometheusRule. |
| prometheusRule.groups | list | `[]` | Groups with alerting rules. Read more about it at [https://docs.openshift.com/container-platform/4.7/rest_api/monitoring_apis/prometheusrule-monitoring-coreos-com-v1.html](OpenShift's PrometheusRule documentation). |

### ExternalSecret Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| externalSecret.enabled | bool | `false` | Deploy [ExternalSecret](https://external-secrets.io/latest/) resources. |
| externalSecret.additionalLabels | object, null | `nil` | Additional labels for ExternalSecret. |
| externalSecret.annotations | object, null | `nil` | Annotations for ExternalSecret. |
| externalSecret.secretStore | object, null | `{"kind":"SecretStore","name":"tenant-vault-secret-store"}` | Default values for the SecretStore. Can be overriden per ExternalSecret in the `externalSecret.files` object. |
| externalSecret.secretStore.name | string | `"tenant-vault-secret-store"` | Name of the SecretStore to use. |
| externalSecret.secretStore.kind | string | `"SecretStore"` | Kind of the SecretStore being refered to. |
| externalSecret.refreshInterval | string | `"1m"` | RefreshInterval is the amount of time before the values are read again from the SecretStore provider. |
| externalSecret.files | object, null | `nil` | List of ExternalSecret entries. Key will be used as a name suffix for the ExternalSecret. There a two allowed modes: - `data`: Data defines the connection between the Kubernetes Secret keys and the Provider data - `dataFrom`: Used to fetch all properties from the Provider key |

### NetworkPolicy Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| networkPolicy.enabled | bool | `false` | Enable Network Policy. |
| networkPolicy.additionalLabels | object, null | `nil` | Additional labels for Network Policy. |
| networkPolicy.annotations | object, null | `nil` | Annotations for Network Policy. |
| networkPolicy.ingress | list | `nil` | Ingress rules for Network Policy. |
| networkPolicy.egress | list | `nil` | Egress rules for Network Policy. |

### PodDisruptionBudget Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| pdb.enabled | bool | `false` | Enable Pod Disruption Budget. |
| pdb.minAvailable | int, string, null | `1` | Minimum number of pods that must be available after eviction. Accepts both integers and percentage strings (e.g. "25%"). |
| pdb.maxUnavailable | int, string, null | `nil` | Maximum number of unavailable pods during voluntary disruptions. Accepts both integers and percentage strings (e.g. "25%"). |

### GrafanaDashboard Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| grafanaDashboard.enabled | bool | `false` | Deploy [GrafanaDashboard](https://github.com/grafana/grafana-operator) resources. |
| grafanaDashboard.additionalLabels | object, null | `nil` | Additional labels for GrafanaDashboard. |
| grafanaDashboard.annotations | object, null | `nil` | Annotations for GrafanaDashboard. |
| grafanaDashboard.contents | object, null | `nil` | List of GrafanaDashboard entries. Key will be used as a name suffix for the GrafanaDashboard. Value is the GrafanaDashboard content. According to GrafanaDashboard behavior, `url` field takes precedence on the `json` field. |

### Backup Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backup.enabled | bool | `false` | Deploy a [Velero/OADP Backup](https://velero.io/docs/main/api-types/backup/) resource. |
| backup.namespace | string, null | `{{ .Release.Namespace }}` | Namespace for Backup. |
| backup.additionalLabels | object, null | `nil` | Additional labels for Backup. |
| backup.annotations | object, null | `nil` | Annotations for Backup. |
| backup.defaultVolumesToRestic | bool | `true` | Whether to use Restic to take snapshots of all pod volumes by default. |
| backup.snapshotVolumes | bool | `true` | Whether to take snapshots of persistent volumes as part of the backup. |
| backup.storageLocation | string, null | `nil` | Name of the backup storage location where the backup should be stored. |
| backup.ttl | string | `"1h0m0s"` | How long the Backup should be retained for. |
| backup.includedNamespaces | list | `[ {{ include "application.namespace" $ }} ]` | List of namespaces to include objects from. Keys and values are evaluated as templates. |
| backup.includedResources | list | `nil` | List of resource types to include in the backup. |
| backup.excludedResources | list | `nil` | List of resource types to exclude from the backup. |

## Naming convention for ConfigMap, Secret, SealedSecret and ExternalSecret

Name format of ConfigMap, Secret, SealedSecret and ExternalSecret is `{{ template "application.name" $ }}-{{ $nameSuffix }}` then:

- `{{ template "application.name" }}` is a helper function that outputs `.Values.applicationName` if exist else return chart name as output
- `nameSuffix` is the each key in `secret.files`, `configMap.files`, `sealedSecret.files` and `externalSecret.files`

For example if we have following values file:

```yaml
applicationName: helloworld # {{ template "application.name" $ }}

configMap:
  files:
    config: # {{ $nameSuffix }}
      key: value
```

then the configmap name will be named `helloworld-config`.

## Consuming environment variable in application chart

In order to use environment variable in deployment or cronjob, you will have to provide environment variable in *key/value* pair in `env` value. where key being environment variable key and value varies in different scenarios

- For simple key/value environment variable, just provide `value: <value>`

  ```yaml
  env:
    KEY:
      value: MY_VALUE
  ```

- To get environement variable value from **ConfigMap**

  Suppose we have a configmap created from application chart

  ```yaml
  applicationName: my-application
  configMap:
    enabled: true
    files:
      application-config:
        LOG: DEBUG
        VERBOSE: v1
  ```

  To get environment variable value from above created configmap, we will need to add following

  ```yaml
  env:
   APP_LOG_LEVEL:
    valueFrom:
      configMapKeyRef:
        name: my-application-application-config
        key: LOG
  ```

  To get all environment variables key/values from **ConfigMap**, where configmap key being key of environment variable and value being value

  ```yaml
  envFrom:
    application-config-env:
      type: configmap
      nameSuffix: application-config
  ```

  You can either provide `nameSuffix` which means name added after prefix `<applicationName>-` or static name with `name` of configmap.

  You can specify whether the configmap is mandatory or optional for the pod to start with the `optional: true/false` value.

  **Note:** first key after `envFrom` is just used to uniquely identify different objects in `envFrom` block. Make sure to keep it unique and relevant.

  To reference an **existing external ConfigMap** not managed by this chart, use `name` instead of `nameSuffix`:

  ```yaml
  envFrom:
    external-configmap:
      type: configmap
      name: my-existing-configmap
  ```

- To get environment variable value from **Secret**

  Suppose we have secret created from application chart

  ```yaml
  applicationName: my-application
  secret:
   enabled: true
   files:
      db-credentials:
        PASSWORD: skljd#2Qer!!
        USER: postgres
  ```

  To get environment variable value from above created secret, we will need to add following

  ```yaml
  env:
   KEY:
     valueFrom:
     secretKeyRef:
       name: my-application-db-credentials
       key: USER
  ```

  To get environement variable value from **Secret**, where secret key being key of environment variable and value being value

  ```yaml
  envFrom:
   database-credentials:
      type: secret
      nameSuffix: db-credentials
  ```

  You can either provide `nameSuffix` which means name added after prefix `<applicationName>-` or static name with `name` of secret.

  You can specify whether the secret is mandatory or optional for the pod to start with the `optional: true/false` value.

  **Note:** first key after `envFrom` is just used to uniquely identify different objects in `envFrom` block. Make sure to keep it unique and relevant.

  To reference an **existing external Secret** not managed by this chart, use `name` instead of `nameSuffix`:

  ```yaml
  envFrom:
    external-secret:
      type: secret
      name: my-existing-secret
  ```

## Configuring probes

To disable liveness or readiness probe, set value of `enabled` to `false`.

```yaml
livenessProbe:
  enabled: false
```

By default probe handler type is `httpGet`. You just need to override `port` and `path` as per your need.

```yaml
livenessProbe:
  enabled: true
  httpGet:
    path: '/path'
    port: 8080
```

In order to use `exec` handler, you can define field `livenessProbe.exec` in your values.yaml.

```yaml
livenessProbe:
  enabled: true
  exec:
    command:
      - cat
      - /tmp/healthy
```
