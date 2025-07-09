[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Application

Generic helm chart for applications which:

- are stateless
- creates only namespace scoped resources (e.g. it doesn't need CRB - Cluster Role Bindings)
- don't need privileged containers
- don't call the underlying Kubernetes API or use the underlying etcd as a database by defining custom resources
- run either as deployment, job or cronjob

## Installing the Chart

To install the chart with the release name `my-application` in namespace `test`:

```shell
helm repo add stakater https://stakater.github.io/stakater-charts
helm repo update
helm install my-application stakater/application --namespace test
```

## Uninstall the Chart

To uninstall the chart:

```shell
helm delete --namespace test my-application
```

## Values

### Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| namespaceOverride | string | `""` | Override the namespace for all resources. |
| componentOverride | string | `""` | Override the component label for all resources. |
| partOfOverride | string | `""` | Override the partOf label for all resources. |
| applicationName | string | `{{ .Chart.Name }}` | Application name. |
| extraObjects | [list or object] of [tpl/object or tpl/string] | `nil` | Extra K8s manifests to deploy. Can be of type list or object. If object, keys are ignored and only values are used. The used values can be defined as object or string and are passed through tpl to render. |

### CronJob Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cronJob.enabled | bool | `false` | Deploy CronJob resources. |
| cronJob.jobs | object | `nil` | Map of CronJob resources. Key will be used as a name suffix for the CronJob. Value is the CronJob configuration. See values for more details. |

### Job Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| job.enabled | bool | `false` | Deploy Job resources. |
| job.jobs | object | `nil` | Map of Job resources. Key will be used as a name suffix for the Job. Value is the Job configuration. See values for more details. |

### Deployment Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| deployment.enabled | bool | `true` | Enable Deployment. |
| deployment.additionalLabels | object | `nil` | Additional labels for Deployment. |
| deployment.podLabels | object | `nil` | Additional pod labels which are used in Service's Label Selector. |
| deployment.annotations | object | `nil` | Annotations for Deployment. |
| deployment.additionalPodAnnotations | object | `nil` | Additional pod annotations. |
| deployment.strategy.type | string | `"RollingUpdate"` | Type of deployment strategy. |
| deployment.reloadOnChange | bool | `true` | Reload deployment if attached Secret/ConfigMap changes. |
| deployment.nodeSelector | object | `nil` | Select the node where the pods should be scheduled. |
| deployment.hostAliases | list | `nil` | Mapping between IP and hostnames that will be injected as entries in the pod's hosts files. |
| deployment.initContainers | object | `nil` | Add init containers to the pods. |
| deployment.fluentdConfigAnnotations | object | `nil` | Configuration details for fluentdConfigurations. Only works for specific setup, see <https://medium.com/stakater/dynamic-log-processing-with-fluentd-konfigurator-and-slack-935a5de4eddb>. |
| deployment.replicas | int | `nil` | Number of replicas. |
| deployment.imagePullSecrets | list | `[]` | List of secrets to be used for pulling the images. |
| deployment.envFrom | object | `nil` | Mount environment variables from ConfigMap or Secret to the pod. See the README "Consuming environment variable in application chart" section for more details. |
| deployment.env | object | `nil` | Environment variables to be added to the pod. See the README "Consuming environment variable in application chart" section for more details. |
| deployment.volumes | object | `nil` | Volumes to be added to the pod. Key is the name of the volume. Value is the volume definition. |
| deployment.volumeMounts | object | `nil` | Mount path for Volumes. Key is the name of the volume. Value is the volume mount definition. |
| deployment.priorityClassName | string | `""` | Define the priority class for the pod. |
| deployment.tolerations | list | `nil` | Taint tolerations for the pods. |
| deployment.affinity | object | `nil` | Affinity for the pods. |
| deployment.topologySpreadConstraints | list | `nil` | Topology spread constraints for the pods. |
| deployment.revisionHistoryLimit | int | `2` | Number of ReplicaSet revisions to retain. |
| deployment.image.repository | string | `""` | Repository. |
| deployment.image.tag | string | `""` | Tag. |
| deployment.image.digest | string | `""` | Image digest. If set to a non-empty value, digest takes precedence on the tag. |
| deployment.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| deployment.dnsConfig | object | `nil` | DNS config for the pods. |
| deployment.dnsPolicy | string | `""` | DNS Policy. |
| deployment.startupProbe | object | See below | Startup probe. Must specify either one of the following field when enabled: httpGet, exec, tcpSocket, grpc |
| deployment.startupProbe.enabled | bool | `false` | Enable Startup probe. |
| deployment.startupProbe.failureThreshold | int | `30` | Number of retries before marking the pod as failed. |
| deployment.startupProbe.periodSeconds | int | `10` | Time between retries. |
| deployment.startupProbe.successThreshold | int | `1` | Number of successful probes before marking the pod as ready. |
| deployment.startupProbe.timeoutSeconds | int | `1` | Time before the probe times out. |
| deployment.startupProbe.httpGet | object | `{}` | HTTP Get probe. |
| deployment.startupProbe.exec | object | `{}` | Exec probe. |
| deployment.startupProbe.tcpSocket | object | `{}` | TCP Socket probe. |
| deployment.startupProbe.grpc | object | `{}` | gRPC probe. |
| deployment.readinessProbe | object | See below | Readiness probe. Must specify either one of the following field when enabled: httpGet, exec, tcpSocket, grpc |
| deployment.readinessProbe.enabled | bool | `false` | Enable Readiness probe. |
| deployment.readinessProbe.failureThreshold | int | `30` | Number of retries before marking the pod as failed. |
| deployment.readinessProbe.periodSeconds | int | `10` | Time between retries. |
| deployment.readinessProbe.successThreshold | int | `1` | Number of successful probes before marking the pod as ready. |
| deployment.readinessProbe.timeoutSeconds | int | `1` | Time before the probe times out. |
| deployment.readinessProbe.httpGet | object | `{}` | HTTP Get probe. |
| deployment.readinessProbe.exec | object | `{}` | Exec probe. |
| deployment.readinessProbe.tcpSocket | object | `{}` | TCP Socket probe. |
| deployment.readinessProbe.grpc | object | `{}` | gRPC probe. |
| deployment.livenessProbe | object | See below | Liveness probe. Must specify either one of the following field when enabled: httpGet, exec, tcpSocket, grpc |
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
| deployment.containerSecurityContext | object | `{"readOnlyRootFilesystem":true,"runAsNonRoot":true}` | Security Context at Container Level. |
| deployment.openshiftOAuthProxy.enabled | bool | `false` | Enable [OpenShift OAuth Proxy](https://github.com/openshift/oauth-proxy). |
| deployment.openshiftOAuthProxy.port | int | `8080` | Port on which application is running inside container. |
| deployment.openshiftOAuthProxy.secretName | string | `"openshift-oauth-proxy-tls"` | Secret name for the OAuth Proxy TLS certificate. |
| deployment.openshiftOAuthProxy.image | string | `"openshift/oauth-proxy:latest"` | Image for the OAuth Proxy. |
| deployment.openshiftOAuthProxy.disableTLSArg | bool | `false` | If disabled `--http-address=:8081` will be used instead of `--https-address=:8443`. It can be useful when an ingress is enabled for the application. |
| deployment.securityContext | object | `nil` | Security Context for the pod. |
| deployment.command | list | `[]` | Command for the app container. |
| deployment.args | list | `[]` | Args for the app container. |
| deployment.ports | list | `nil` | List of ports for the app container. |
| deployment.hostNetwork | bool | `nil` | Host network connectivity. |
| deployment.terminationGracePeriodSeconds | int | `nil` | Gracefull termination period. |
| deployment.lifecycle | object | `{}` | Lifecycle configuration for the pod. |
| deployment.additionalContainers | list | `nil` | Additional containers besides init and app containers (without templating). |
| persistence.enabled | bool | `false` | Enable persistence. |
| persistence.mountPVC | bool | `false` | Whether to mount the created PVC to the deployment. |
| persistence.mountPath | string | `"/"` | If `persistence.mountPVC` is enabled, where to mount the volume in the containers. |
| persistence.name | string | `{{ include "application.name" $ }}-data` | Name of the PVC. |
| persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for volume. |
| persistence.storageClass | string | `nil` | Storage class for volume. If defined, use that value If set to "-" or "", disable dynamic provisioning If undefined or set to null (the default), no storageClass spec is   set, choosing the default provisioner. |
| persistence.additionalLabels | object | `nil` | Additional labels for persistent volume. |
| persistence.annotations | object | `nil` | Annotations for persistent volume. |
| persistence.storageSize | string | `"8Gi"` | Size of the persistent volume. |
| persistence.volumeMode | string | `""` | PVC Volume Mode. |
| persistence.volumeName | string | `""` | Name of the volume. |

### Service Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| service.enabled | bool | `true` | Enable Service. |
| service.additionalLabels | object | `nil` | Additional labels for service. |
| service.annotations | object | `nil` | Annotations for service. |
| service.ports | list | `[{"name":"http","port":8080,"protocol":"TCP","targetPort":8080}]` | Ports for applications service. |
| service.type | string | `"ClusterIP"` | Type of service. |
| service.clusterIP | string | `nil` | Fixed IP for a ClusterIP service. Set to `None` for an headless service |

### Ingress Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.enabled | bool | `false` | Enable Ingress. |
| ingress.ingressClassName | string | `""` | Name of the ingress class. |
| ingress.hosts[0].host | tpl/string | `"chart-example.local"` | Hostname. |
| ingress.hosts[0].paths[0].path | string | `"/"` | Path. |
| ingress.hosts[0].paths[0].pathType | string | `ImplementationSpecific` | Path type. |
| ingress.hosts[0].paths[0].serviceName | string | `{{ include "application.name" $ }}` | Service name. |
| ingress.hosts[0].paths[0].servicePort | string | `http` | Service port. |
| ingress.additionalLabels | object | `nil` | Additional labels for ingress. |
| ingress.annotations | object | `nil` | Annotations for ingress. |
| ingress.tls | list | `nil` | TLS configuration for ingress. Secrets must exist in the namespace. You may also configure Certificate resource to generate the secret. |

### Route Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| route.enabled | bool | `false` | Deploy a Route (OpenShift) resource. |
| route.additionalLabels | object | `nil` | Additional labels for Route. |
| route.annotations | object | `nil` | Annotations for Route. |
| route.host | string | `nil` | Explicit host. If no host is added then openshift inserts the default hostname. |
| route.path | string | `nil` | Path. |
| route.port | object | `{"targetPort":"http"}` | Service port. |
| route.to.weight | int | `100` | Service weight. |
| route.wildcardPolicy | string | `"None"` | Wildcard policy. |
| route.tls.termination | string | `"edge"` | TLS termination strategy. |
| route.tls.insecureEdgeTerminationPolicy | string | `"Redirect"` | TLS insecure termination policy. |
| route.alternateBackends | list | `nil` | Alternate backend with it's weight. |

### SecretProviderClass Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secretProviderClass.enabled | bool | `false` | Deploy a [Secrets Store CSI Driver SecretProviderClass](https://secrets-store-csi-driver.sigs.k8s.io/) resource. |
| secretProviderClass.name | string | `""` | Name of the SecretProviderClass. Required if `secretProviderClass.enabled` is set to `true`. |
| secretProviderClass.provider | string | `""` | Name of the provider. Required if `secretProviderClass.enabled` is set to `true`. |
| secretProviderClass.vaultAddress | string | `""` | Vault Address. Required if `secretProviderClass.provider` is set to `vault`. |
| secretProviderClass.roleName | tpl/string | `""` | Vault Role Name. Required if `secretProviderClass.provider` is set to `vault`. |
| secretProviderClass.objects | list | `nil` | Objects definitions. |
| secretProviderClass.secretObjects | list | `nil` | Objects mapping. |

### ForecastleApp Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| forecastle.enabled | bool | `false` | Deploy a [ForecastleApp](https://github.com/stakater/Forecastle) resource. |
| forecastle.additionalLabels | object | `nil` | Additional labels for ForecastleApp. |
| forecastle.icon | string | `"https://raw.githubusercontent.com/stakater/ForecastleIcons/master/stakater-big.png"` | Icon URL. |
| forecastle.displayName | string | `""` | Application Name. Required if `forecastle.enabled` is set to `true`. |
| forecastle.group | string | `{{ .Release.Namespace }}` | Application Group. |
| forecastle.properties | object | `nil` | Custom properties. |
| forecastle.networkRestricted | bool | `false` | Is application network restricted?. |

### RBAC Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| rbac.enabled | bool | `true` | Enable RBAC. |
| rbac.serviceAccount.enabled | bool | `false` | Deploy Service Account. |
| rbac.serviceAccount.name | string | `{{ include "application.name" $ }}` | Service Account Name. |
| rbac.serviceAccount.additionalLabels | object | `nil` | Additional labels for Service Account. |
| rbac.serviceAccount.annotations | object | `nil` | Annotations for Service Account. |
| rbac.roles | list | `nil` | Namespaced Roles. |

### ConfigMap Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMap.enabled | bool | `false` | Deploy additional ConfigMaps. |
| configMap.additionalLabels | object | `nil` | Additional labels for ConfigMaps. |
| configMap.annotations | object | `nil` | Annotations for ConfigMaps. |
| configMap.files | object | `nil` | List of ConfigMap entries. Key will be used as a name suffix for the ConfigMap. Value is the ConfigMap content. |

### SealedSecret Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sealedSecret.enabled | bool | `false` | Deploy [SealedSecret](https://github.com/bitnami-labs/sealed-secrets) resources. |
| sealedSecret.additionalLabels | object | `nil` | Additional labels for SealedSecret. |
| sealedSecret.annotations | object | `nil` | Annotations for SealedSecret. |
| sealedSecret.files | object | `nil` | List of SealedSecret entries. Key will be used as a name suffix for the SealedSecret. Value is the SealedSecret content. |

### Secret Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secret.enabled | bool | `false` | Deploy additional Secret resources. |
| secret.additionalLabels | object | `nil` | Additional labels for Secret. |
| secret.annotations | object | `nil` | Annotations for Secret. |
| secret.files | object | `nil` | List of Secrets entries. Key will be used as a name suffix for the Secret. There a three allowed modes: - `data`: Data is base64 encoded by the chart - `encodedData`: Use raw values (already base64ed) inside the data map - `stringData`: Use raw values inside the stringData map |

### ServiceMonitor Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| serviceMonitor.enabled | bool | `false` | Deploy a ServiceMonitor (Prometheus Operator) resource. |
| serviceMonitor.additionalLabels | object | `nil` | Additional labels for ServiceMonitor. |
| serviceMonitor.annotations | object | `nil` | Annotations for ServiceMonitor. |
| serviceMonitor.endpoints | list | `[{"interval":"5s","path":"/actuator/prometheus","port":"http"}]` | Service endpoints from which prometheus will scrape data. |

### Autoscaling - Horizontal Pod Autoscaling Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscaling.enabled | bool | `false` | Enable Horizontal Pod Autoscaling. |
| autoscaling.additionalLabels | object | `nil` | Additional labels for HPA. |
| autoscaling.annotations | object | `nil` | Annotations for HPA. |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas. |
| autoscaling.maxReplicas | int | `10` | Maximum number of replicas. |
| autoscaling.metrics | list | `[{"resource":{"name":"cpu","target":{"averageUtilization":60,"type":"Utilization"}},"type":"Resource"},{"resource":{"name":"memory","target":{"averageUtilization":60,"type":"Utilization"}},"type":"Resource"}]` | Metrics used for autoscaling. |

### VPA - Vertical Pod Autoscaler Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| vpa.enabled | bool | `false` | Enable Vertical Pod Autoscaling. |
| vpa.additionalLabels | object | `nil` | Additional labels for VPA. |
| vpa.annotations | object | `nil` | Annotations for VPA. |
| vpa.containerPolicies | list | `[]` | Container policies for individual containers. |
| vpa.updatePolicy | object | `{"updateMode":"Auto"}` | Update policy. |

### EndpointMonitor Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| endpointMonitor.enabled | bool | `false` | Deploy an [IMC EndpointMonitor](https://github.com/stakater/IngressMonitorController) resource. |
| endpointMonitor.additionalLabels | object | `nil` | Additional labels for EndpointMonitor. |
| endpointMonitor.annotations | object | `nil` | Annotations for EndpointMonitor. |

### cert-manager Certificate Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certificate.enabled | bool | `false` | Deploy a [cert-manager Certificate](https://cert-manager.io) resource. |
| certificate.additionalLabels | object | `nil` | Additional labels for Certificate. |
| certificate.annotations | object | `nil` | Annotations for Certificate. |
| certificate.secretName | tpl/string | `"tls-cert"` | Name of the secret resource that will be automatically created and managed by this Certificate resource. |
| certificate.duration | string | `"8760h0m0s"` | The requested "duration" (i.e. lifetime) of the Certificate. |
| certificate.renewBefore | string | `"720h0m0s"` | The amount of time before the currently issued certificate's notAfter time that cert-manager will begin to attempt to renew the certificate. |
| certificate.subject | tpl/object | `nil` | Full X509 name specification for certificate. |
| certificate.commonName | tpl/string | `nil` | Common name as specified on the DER encoded CSR. This field is not recommended in cases when this certificate is an end-entity certificate. More information can be found in the [cert-manager documentation](https://cert-manager.io/docs/usage/certificate/#:~:text=%23%20Avoid%20using%20commonName,%3A%20example.com). |
| certificate.keyAlgorithm | string | `"rsa"` | Private key algorithm of the corresponding private key for this certificate. |
| certificate.keyEncoding | string | `"pkcs1"` | Private key cryptography standards (PKCS) for this certificate's private key to be encoded in. |
| certificate.keySize | int | `2048` | Key bit size of the corresponding private key for this certificate. |
| certificate.isCA | bool | `false` | Mark this Certificate as valid for certificate signing. |
| certificate.usages | list | `nil` | Set of x509 usages that are requested for the certificate. |
| certificate.dnsNames | tpl/list | `nil` | List of DNS subjectAltNames to be set on the certificate. |
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
| certificate.keystores.jks.key | tpl/string | `"test_key"` | Key of the entry in the Secret resource's data field to be used. |
| certificate.keystores.jks.name | string | `"test-creds"` | Name of the Secret resource being referred to. |

### AlertmanagerConfig Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| alertmanagerConfig.enabled | bool | `false` | Deploy an AlertmanagerConfig (Prometheus Operator) resource. |
| alertmanagerConfig.selectionLabels | object | `{"alertmanagerConfig":"workload"}` | Labels to be picked up by Alertmanager to add it to base config. Read more about it at [https://docs.openshift.com/container-platform/4.7/rest_api/monitoring_apis/alertmanager-monitoring-coreos-com-v1.html](OpenShift's AlermanagerConfig documentation) under .spec.alertmanagerConfigSelector. |
| alertmanagerConfig.spec | object | `{"inhibitRules":[],"receivers":[],"route":null}` | AlertmanagerConfig spec. Read more about it at [https://docs.openshift.com/container-platform/4.7/rest_api/monitoring_apis/alertmanagerconfig-monitoring-coreos-com-v1alpha1.html](OpenShift's AlermanagerConfig documentation). |
| alertmanagerConfig.spec.route | object | `nil` | Route definition for alerts matching the resource’s namespace. It will be added to the generated Alertmanager configuration as a first-level route. |
| alertmanagerConfig.spec.receivers | list | `[]` | List of receivers. |
| alertmanagerConfig.spec.inhibitRules | list | `[]` | Inhibition rules that allows to mute alerts when other alerts are already firing. |

### PrometheusRule Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| prometheusRule.enabled | bool | `false` | Deploy a PrometheusRule (Prometheus Operator) resource. |
| prometheusRule.additionalLabels | object | `nil` | Additional labels for PrometheusRule. |
| prometheusRule.groups | list | `[]` | Groups with alerting rules. Read more about it at [https://docs.openshift.com/container-platform/4.7/rest_api/monitoring_apis/prometheusrule-monitoring-coreos-com-v1.html](OpenShift's PrometheusRule documentation). |

### ExternalSecret Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| externalSecret.enabled | bool | `false` | Deploy [ExternalSecret](https://external-secrets.io/latest/) resources. |
| externalSecret.additionalLabels | object | `nil` | Additional labels for ExternalSecret. |
| externalSecret.annotations | object | `nil` | Annotations for ExternalSecret. |
| externalSecret.secretStore | object | `{"kind":"SecretStore","name":"tenant-vault-secret-store"}` | Default values for the SecretStore. Can be overriden per ExternalSecret in the `externalSecret.files` object. |
| externalSecret.secretStore.name | string | `"tenant-vault-secret-store"` | Name of the SecretStore to use. |
| externalSecret.secretStore.kind | string | `"SecretStore"` | Kind of the SecretStore being refered to. |
| externalSecret.refreshInterval | string | `"1m"` | RefreshInterval is the amount of time before the values are read again from the SecretStore provider. |
| externalSecret.files | object | `nil` | List of ExternalSecret entries. Key will be used as a name suffix for the ExternalSecret. There a two allowed modes: - `data`: Data defines the connection between the Kubernetes Secret keys and the Provider data - `dataFrom`: Used to fetch all properties from the Provider key |

### NetworkPolicy Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| networkPolicy.enabled | bool | `false` | Enable Network Policy. |
| networkPolicy.additionalLabels | object | `nil` | Additional labels for Network Policy. |
| networkPolicy.annotations | object | `nil` | Annotations for Network Policy. |
| networkPolicy.ingress | list | `nil` | Ingress rules for Network Policy. |
| networkPolicy.egress | list | `nil` | Egress rules for Network Policy. |

### PodDisruptionBudget Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| pdb.enabled | bool | `false` | Enable Pod Disruption Budget. |
| pdb.minAvailable | int | `1` | Minimum number of pods that must be available after eviction. |
| pdb.maxUnavailable | int | `nil` | Maximum number of unavailable pods during voluntary disruptions. |

### GrafanaDashboard Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| grafanaDashboard.enabled | bool | `false` | Deploy [GrafanaDashboard](https://github.com/grafana/grafana-operator) resources. |
| grafanaDashboard.additionalLabels | object | `nil` | Additional labels for GrafanaDashboard. |
| grafanaDashboard.annotations | object | `nil` | Annotations for GrafanaDashboard. |
| grafanaDashboard.contents | object | `nil` | List of GrafanaDashboard entries. Key will be used as a name suffix for the GrafanaDashboard. Value is the GrafanaDashboard content. According to GrafanaDashboard behavior, `url` field takes precedence on the `json` field. |

### Backup Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backup.enabled | bool | `false` | Deploy a [Velero/OADP Backup](https://velero.io/docs/main/api-types/backup/) resource. |
| backup.namespace | string | `{{ .Release.Namespace }}` | Namespace for Backup. |
| backup.additionalLabels | object | `nil` | Additional labels for Backup. |
| backup.annotations | object | `nil` | Annotations for Backup. |
| backup.defaultVolumesToRestic | bool | `true` | Whether to use Restic to take snapshots of all pod volumes by default. |
| backup.snapshotVolumes | bool | `true` | Whether to take snapshots of persistent volumes as part of the backup. |
| backup.storageLocation | string | `nil` | Name of the backup storage location where the backup should be stored. |
| backup.ttl | string | `"1h0m0s"` | How long the Backup should be retained for. |
| backup.includedNamespaces | tpl/list | `[ {{ include "application.namespace" $ }} ]` | List of namespaces to include objects from. |
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
