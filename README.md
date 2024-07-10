[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Application

Generic helm chart for applications which are:

- stateless
- create only namespace scoped resources (e.g. it doesn't need CRB - cluster role bindings)
- don't need privileged containers
- don't call the underlying Kubernetes API or use the underlying etcd as a database by defining custom resources
- run either as deployment or cronjob

## Installing the Chart

To install the chart with the release name my-application in namespace test:

    helm repo add stakater https://stakater.github.io/stakater-charts
    helm repo update
    helm install my-application stakater/application --namespace test

## Uninstall the Chart

To uninstall the chart:

    helm delete <name-of-the-chart>

## Parameters

| Name                   | Description                                                              | Value                                       |
| -----------------------|--------------------------------------------------------------------------|---------------------------------------------|
| applicationName        | Name of the application                                                  | `application`                               |
| namespaceOverride      | Override default release namespace with a custom value                   | `application`                               |
| labels.group           | Label to define application group                                        | `com.stakater.platform`                     |
| labels.team            | Label to define team                                                     | `stakater`                                  |

### Deployment Paramaters

| Name                                     | Description                                                                                                                                | Value          |
|------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|----------------|
| deployment.enabled                       | Enable deployment on helm chart deployments                                                                                                | `true`         |
| deployment.strategy                      | Strategy for updating deployments                                                                                                          | `RollingUpdate`|
| deployment.reloadOnChange                | Reload deployment if configMap/secret mounted are updated                                                                                  | `true`         |
| deployment.nodeSelector                  | Select node to deploy this application                                                                                                     | `{}`           |
| deployment.hostAliases                   | Adding entries to a Pod's /etc/hosts file provides Pod-level override of hostname resolution when DNS and other options are not applicable | `[]`           |
| deployment.additionalLabels              | Additional labels for Deployment                                                                                                           | `{}`           |
| deployment.podLabels                     | Additional label added on pod which is used in Service's Label Selector                                                                    | `{}`           |
| deployment.annotations                   | Annotations on deployments                                                                                                                 | `{}`           |
| deployment.additionalPodAnnotations      | Additional Pod Annotations added on pod created by this Deployment                                                                         | `{}`           |
| deployment.replicas                      | Replicas to be created                                                                                                                     | ``             |
| deployment.imagePullSecrets              | Secrets used to pull image                                                                                                                 | `""`           |
| deployment.env                           | Environment variables to be passed to the app container                                                                                    | `{}`           |
| deployment.volumes                       | Volumes to be added to the pod                                                                                                             | `{}`           |
| deployment.volumeMounts                  | Mount path for Volumes                                                                                                                     | `{}`           |
| deployment.revisionHistoryLimit          | The number of old history to retain to allow rollback                                                                                      | `2`            |
| deployment.command                       | Command for primary container of deployment                                                                                                | `[]`           |
| deployment.args                          | Arg for primary container of deployment                                                                                                    | `[]`           |
| deployment.priorityClassName             | Defines the priority class for pod scheduling                                                                                              | `""`           |
| deployment.tolerations                   | Taint tolerations for nodes                                                                                                                | `[]`           |
| deployment.affinity                      | Affinity for pod/node                                                                                                                      | `[]`           |
| deployment.topologySpreadConstraints     | Topology spread constraints definitions                                                                                                    | `[]`           |
| deployment.ports                         | Ports for primary container                                                                                                                | `[]`           |
| deployment.securityContext               | Security Context for the pod                                                                                                               | `{}`           |
| deployment.additionalContainers          | Add additional containers besides init and app containers                                                                                  | `[]`           |
| deployment.containerSecurityContext      | Add security context at container level                                                                                                    | `{}`           |
| deployment.terminationGracePeriodSeconds | Graceful termination timeout                                                                                                               | ``             |
| deployment.lifecycle                     | Container lifecycle management for graceful startup and shutdown procedures                                                                | `{}`           |

#### Deployment Resources Parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| deployment.resources     | Application pod resource requests & limits                                                   | See below       |

##### Requests and Limits

```
  resources:
    limits:
      memory: 256Mi
      cpu: 0.5
    requests:
      memory: 128Mi
      cpu: 0.1
```

#### Deployment InitContainers Parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| deployment.initContainers | Init containers which runs before the app container                                         | `{}`            |


#### Deployment fluentd Parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| deployment.fluentdConfigAnnotations | Annotations for fluentd Configurations                                            | `{}`            |

#### Deployment Image Parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| deployment.image.repository | Image repository for the application                                                      | `repository/image-name`  |
| deployment.image.tag | Tag of the application image                                                                     | `null`          |
| deployment.image.digest | Digest of the application image                                                               | ``              |
| deployment.image.pullPolicy | Pull policy for the application image                                                     | `IfNotPresent`  |

#### Deployment envFrom Parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| deployment.envFrom | Environment variables to be picked from configmap or secret                                        | `{}`            |
| deployment.envFrom.type | Type of data i.e. Configmap or Secret                                                         | ``              |
| deployment.envFrom.name | Name of Configmap or Secret, if set empty, set to application name                            | ``              |
| deployment.envFrom.nameSuffix | Suffix Name of Configmap or Secret, applicationName is appended as prefix               | ``              |

#### Deployment Probes Paramaters

##### Startup Probe
StartupProbe indicates that the Pod has successfully initialized. If specified, no other probes are executed until this completes successfully.

| Name                     | Description                                                                                 | Value                  |
| ------------------------ |---------------------------------------------------------------------------------------------|------------------------|
| deployment.startupProbe.enabled | Enabled startup probe                                                                       | false                  |
| deployment.startupProbe.failureThreshold | When a probe fails, Kubernetes will try failureThreshold times before giving up.    | 30              |
| deployment.startupProbe.periodSeconds | Perform probe  everytime after specified periodSeconds                                | 10                     |
| deployment.startupProbe.successThreshold | Minimum consecutive successes for the probe to be considered successful after having failed. |                        |
| deployment.startupProbe.timeoutSeconds | Number of seconds after which the probe times out.                                    |                        |
| deployment.startupProbe.httpGet | Describes an action based on HTTP Get requests                                              | path: '/path' port: 8080 |
| deployment.startupProbe.exec | Kubelet executes the specified command to perform the probe                                 | {}          |


##### Readiness Probe
Periodic probe of container service readiness. Container will be removed from service endpoints if the probe fails.

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| deployment.readinessProbe.enabled | Enabled readiness probe                                                                  | true       |
| deployment.readinessProbe.failureThreshold | When a probe fails, Kubernetes will try failureThreshold times before giving up.                                                                  | 3      |
| deployment.readinessProbe.periodSeconds | Perform probe  everytime after specified periodSeconds                                                                  | 10       |
| deployment.readinessProbe.successThreshold | Minimum consecutive successes for the probe to be considered successful after having failed.                                                                  | 1       |
| deployment.readinessProbe.timeoutSeconds | Number of seconds after which the probe times out.                                                                  | 1       |
| deployment.readinessProbe.initialDelaySeconds | Number of seconds after the container has started before liveness or readiness probes are initiated.                                                                  | 10       |
| deployment.readinessProbe.httpGet | Describes an action based on HTTP Get requests                                                                  |   path: '/path' port: 8080     |
| deployment.readinessProbe.exec | Kubelet executes the specified command to perform the probe                                                                  |   {}   |

##### Liveness Probe
Periodic probe of container liveness. Container will be restarted if the probe fails.

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| deployment.livenessProbe.enabled | Enabled livenessProbe probe                                                                  | true       |
| deployment.livenessProbe.failureThreshold | When a probe fails, Kubernetes will try failureThreshold times before giving up.                                                                  | 3      |
| deployment.livenessProbe.periodSeconds | Perform probe  everytime after specified periodSeconds                                                                  | 10       |
| deployment.livenessProbe.successThreshold | Minimum consecutive successes for the probe to be considered successful after having failed.                                                                  | 1       |
| deployment.livenessProbe.timeoutSeconds | Number of seconds after which the probe times out.                                                                  | 1       |
| deployment.livenessProbe.initialDelaySeconds | Number of seconds after the container has started before liveness or readiness probes are initiated.                                                                  | 10       |
| deployment.livenessProbe.httpGet | Describes an action based on HTTP Get requests                                                                  |   path: '/path' port: 8080     |
| deployment.livenessProbe.exec | Kubelet executes the specified command to perform the probe                                                                  | {}      |

#### Deployment OpenshiftOAuthProxy Paramaters

| Name                                      | Description                                           | Value           |
|-------------------------------------------|-------------------------------------------------------| --------------- |
| deployment.openshiftOAuthProxy.enabled    | Add Openshift OAuth Proxy as SideCar Container        | `false`         |
| deployment.openshiftOAuthProxy.port       | Application port so proxy should forward to this port | `8080`          |
| deployment.openshiftOAuthProxy.secretName | Secret name containing the TLS cert                   | `openshift-oauth-proxy-tls`|
| deployment.openshiftOAuthProxy.image      | image for oauth sidecar container                     | `openshift/oauth-proxy:latest`|
| deployment.openshiftOAuthProxy.disableTLSArg      | If disabled --http-address=:8081 will be used instead of --https-address=:8443             | false           |

### Deployment Dns Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| deployment.dnsConfig | Enable pod disruption budget | `{}` |

### PodDisruptionBudget Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| pdb.enabled | Enable pod disruption budget | `false` |
| pdb.minAvailable | The number of pods that must be available after the eviction. If both minAvailable and maxUnavailable is set, minAvailable is preferred | `1`|
| pdb.maxUnavailable | The number of pods that can be unavailable after the eviction. Either minAvailable or maxUnavailable needs to be provided | `` |


### Persistence Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| persistence.enabled | Enable persistence                                                                                                                                                                               | `false`                                                                                                                                               |
| persistence.mountPVC | Whether to mount the created PVC to the deployment                                                                                                                                               | `false`                                                                                                                                               |
| persistence.mountPath | If `persistence.mountPVC` is set, so where to mount the volume in the deployment                                                                                                                 | `/`                                                                                                                                                   |
| persistence.name | Name of the PVC.                                                                                                                | ``                                                                                                                                                   |
| persistence.accessMode | Access mode for volume                                                                                                                                                                           | `ReadWriteOnce`                                                                                                                                       |
| persistence.storageClass | StorageClass of the volume                                                                                                                                                                       | `-`                                                                                                                                                   |
| persistence.additionalLabels | Additional labels for persistent volume                                                                                                                                                          | `{}`                                                                                                                                                  |
| persistence.annotations | Annotations for persistent volume                                                                                                                                                                | `{}`                                                                                                                                                  |
| persistence.storageSize | Size of the persistent volume                                                                                                                                                                    | `8Gi`   
| persistence.volumeName | Name of the volume                                                                                                                                                                     | ``   
| persistence.volumeMode | PVC volume mode                                                                                                                                                                    | ``   

### Service Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| service.enabled | Enable service in helm chart                                                                                                                                                                    | `true`                                                                                                                                           |
| service.additionalLabels | Additional labels for service                                                                                                                                                                    | `{}`                                                                                                                                                  |
| service.annotations | Annotations for service                                                                                                                                                                          | `{}`                                                                                                                                                  |
| service.ports | Ports for applications service                                                                                                                                                                   | - port: 8080<br>&nbsp;&nbsp;name: http<br>&nbsp;&nbsp;protocol: TCP<br>&nbsp;&nbsp;targetPort: 8080                                                   |
| service.type | Type of service                                                                                                                                                                          | `ClusterIP`                                                                                                                                                  |
| service.clusterIP | Fixed IP for a ClusterIP service. Set to `None` for an headless service.                                                                                                                                                                          | `null`                                                                                                                                                  |



### Ingress Paramaters

| Name | Description | Value |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| ingress.enabled | Enable ingress | `false` |
| ingress.hosts | Array of hosts to be served by this ingress. | `[]` |
| ingress.hosts[].host | Host to be served. [See example](application/values-test.yaml). | `[]` |
| ingress.hosts[].paths | Paths against the host. If not specified, default configuration is added, [See example](application/values-test.yaml). | `[]` |
| ingress.additionalLabels | Labels for ingress | `{}` |
| ingress.annotations | Annotations for ingress | `{}` |
| ingress.tls | TLS block for ingress | `[]` |
| ingress.ingressClassName | Name of the ingress class | '' |

### Route Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| route.enabled | Enable Route incase of Openshift                                                                                                                                                                 | `false`                                                                                                                                               |
| route.host | Host of route. If no host is added then openshift inserts the default hostname                                                                                                                   | nil                                                                                                                                                   |
| route.annotations | Annotations for route                                                                                                                                                                            | `{}`                                                                                                                                                  |
| route.additionalLables | Labels for route                                                                                                                                                                                 | `{}`                                                                                                                                                  |
| route.port.targetPort | Port of the service that serves pods                                                                                                                                                             | `http`                                                                                                                                                |
| route.wildcardPolicy | Route wildcard policy                                                                                                                                                                            | `None`                                                                                                                                                |
| route.tls.termination | TLS termination strategy                                                                                                                                                                         | `edge`                                                                                                                                                |
| route.tls.insecureEdgeTerminationPolicy | TLS termination policy for insecure traffic                                                                                                                                                      | `Redirect`                                                                                                                                            |
| route.path | path of route traffic                                                                                                                                                      |
| route.to.weight | portion of requests to be handled by the service                                                                                                                                                       | `100`
| route.alternateBackends | For the purpose of multiple services supporting a route                                                                                                                                                       |
| route.alternateBackends.kind | Kind of supporting resource                                                                                                                                                       | `Service`
| route.alternateBackends.name | Name of supporting service                                                                                                                                                       |
| route.alternateBackends.weight | portion of requests to be handled by supporting service                                                                                                                                                       |

### Forecastle Paramaters

Stakater [Forecastle](https://github.com/stakater/Forecastle) parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| forecastle.enabled | Enable Forecastle                                                                                                                                                                                | `false`                                                                                                                                               |
| forecastle.additionalLabels | Additional labels for Forecastle Custom Resource                                                                                                                                                 | `{}`                                                                                                                                                  |
| forecastle.icon | URL of application icon display on forecastle dashboard                                                                                                                                          | `https://raw.githubusercontent.com/stakater/ForecastleIcons/master/stakater-big.png`                                                                  |
| forecastle.displayName | Name of the application to be displayed on Forecastle dashboard                                                                                                                                  | `application`                                                                                                                                         |
| forecastle.group | Group application on Forecastle dashboard                                                                                                                                                        | if not defined Namespace name is used                                                                                                                 |
| forecastle.properties | Additional properties for Custom Resource                                                                                                                                                        | `{}`                                                                                                                                                  |
| forecastle.networkRestricted | Whether app is network restricted or not                                                                                                                                                         | `false`                                                                                                                                               |

### RBAC Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| rbac.enabled | Enable RBAC                                                                                                                                                                                      | `true`                                                                                                                                                |
| rbac.serviceAccount.enabled | Enable serviceAccount                                                                                                                                                                            | `false`                                                                                                                                               |
| rbac.serviceAccount.name | Name of the existing serviceAccount                                                                                                                                                              | `""`                                                                                                                                                  |
| rbac.serviceAccount.additionalLabels | Labels for serviceAccount                                                                                                                                                                        | `{}`                                                                                                                                                  |
| rbac.serviceAccount.annotations | Annotations for serviceAccount                                                                                                                                                                   | `{}`                                                                                                                                                  |
| rbac.roles | Array of roles                                                                                                                                                                                   | `[]`                                                                                                                                                  |

### ConfigMap Paramaters

| Name                       | Description                                                                        | Value          |
|----------------------------|------------------------------------------------------------------------------------|----------------|
| configMap.enabled          | Enable configMaps                                                                  | `false`        |
| configMap.additionalLabels | Labels for configMaps                                                              | `{}`           |
| configMap.annotations      | Annotations for configMaps                                                         | `{}`           |
| configMap.files            | Map of configMap files with suffixes and data contained in those files             | `{}`           |

### Secret Paramaters

| Name                            | Description                                                                     | Value                  |
|---------------------------------|---------------------------------------------------------------------------------|------------------------|
| secret.enabled                  | Enable secret                                                                   | `false`                |
| secret.additionalLabels         | Labels for secret                                                               | `{}`                   |
| secret.annotations              | Annotations for secret                                                          | `{}`                   |
| secret.files                    | Map of secret files with suffixes and data contained in those files             | `{}`                   |
| secret.files.[name].stringData  | Allow to provide the clear text content inside the secret                       | `{}`                   |
| secret.files.[name].data        | Allow to provide the text content inside the secret that will be base64 encoded | `{}`                   |
| secret.files.[name].encodedData | Allow to provide the text content inside the secret already base64 encoded      | `{}`                   |

### ServiceMonitor Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| serviceMonitor.enabled | Enable serviceMonitor                                                                                                                                                                            | `false`                                                                                                                                               |
| serviceMonitor.additionalLabels | Labels for serviceMonitor                                                                                                                                                                        | `{}`                                                                                                                                                  |
| serviceMonitor.annotations | Annotations for serviceMonitor                                                                                                                                                                   | `{}`                                                                                                                                                  |
| serviceMonitor.jobLabel | Job Label used for application selector                                                                                                                                                          | `k8s-app`                                                                                                                                             |
| serviceMonitor.endpoints | Array of endpoints to be scraped by prometheus                                                                                                                                                   | - interval: 5s<br>&nbsp;&nbsp;path: /actuator/prometheus<br>&nbsp;&nbsp;port: http                                                                    |

### Autoscaling Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| autoscaling.enabled | Enable horizontal pod autoscaler                                                                                                                                                                 | `false`                                                                                                                                               |
| autoscaling.additionalLabels | Labels for horizontal pod autoscaler                                                                                                                                                             | `{}`                                                                                                                                                  |
| autoscaling.annotations | Annotations for horizontal pod autoscaler                                                                                                                                                        | `{}`                                                                                                                                                  |
| autoscaling.minReplicas | Sets minimum replica count when autoscaling is enabled                                                                                                                                           | `1`                                                                                                                                                   |
| autoscaling.maxReplicas | Sets maximum replica count when autoscaling is enabled                                                                                                                                           | `10`                                                                                                                                                  |
| autoscaling.metrics | Configuration for hpa metrics, set when autoscaling is enabled                                                                                                                                   | `{}`                                                                                                                                                  |

### VPA - Vertical Pod Autoscaler Parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| vpa.enabled              | Enable vertical pod autoscaler                                                               | `false`         |
| vpa.additionalLabels     | Labels for vertical pod autoscaler                                                           | `{}`            |
| vpa.annotations          | Annotations for vertical pod autoscaler                                                      | `{}`            |
| vpa.containerPolicies    | container policies for individual containers.                                                | `[]`            |


### EndpointMonitor Paramaters

Stakater [IngressMonitorController](https://github.com/stakater/IngressMonitorController) EndpointMonitor parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| endpointMonitor.enabled | Enable endpointMonitor for IMC (https://github.com/stakater/IngressMonitorController)                                                                                                            | `false`                                                                                                                                               |
| endpointMonitor.additionalLabels | Labels for endpointMonitor                                                                                                                                                                       | `{}`                                                                                                                                                  |
| endpointMonitor.annotations | Annotations for endpointMonitor                                                                                                                                                                  | `{}`                                                                                                                                                  |
| endpointMonitor.additionalConfig | Additional Config for endpointMonitor                                                                                                                                                            | `{}`                                                                                                                                                  |

### SealedSecret Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| sealedSecret.enabled | Enable sealed secret                                                                                                                                                                             | `false`                                                                                                                                               |
| sealedSecret.additionalLabels | Labels for sealed secret                                                                                                                                                                         | `{}`                                                                                                                                                  |
| sealedSecret.annotations | Annotations that apply to all sealed secrets created under `files`                                                                                                                                                                    | `{}`                                                                                                                                                  |
| sealedSecret.files | Map of secret files with name and encrypted data contained in those files                                                                                                                        | `{}`                                                                                                                                                  |
| sealedSecret.files.[name].annotations | Annotations that apply to the secret created through sealed secret                                                                                                                        | `{}`                                                                                                                                                  |
| sealedSecret.files.[name].labels | Labels that apply to the secret created through sealed secret                                                                                                                        | `{}`                                                                                                                                                  |
| sealedSecret.files.[name].type | Type of secret created through sealed secret                                                                                                                        | `Opaque`                                                                                                                                                  |
| sealedSecret.files.[name].clusterWide | When set to true, adds annotation `sealedsecrets.bitnami.com/cluster-wide: true` to the secret created through sealed secret, setting the scope of the secret to cluster wide.                                                                                                                       | `false`                                                                                                                                                  |

### Cert-manager Certificate Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| certificate.enabled | Enable Certificate Custom Resource                                                                                                                                                                | `false`                                                                                                                                               |
| certificate.enabled | Enable Certificate Custom Resource                                                                                                                                                                | `false`                                                                                                                                               |
| certificate.additionalLabels | Additional labels for Certificate Custom Resource                                                                                                                                                | `{}`                                                                                                                                                  |
| certificate.annotations | Annotations for Certificate Custom Resource                                                                                                                                                      | `{}`                                                                                                                                                  |
| certificate.secretName | SecretName is the name of the secret resource that will be automatically created and managed by this Certificate resource                                                                        | `tls-cert`                                                                                                                                            |
| certificate.duration | The requested ‘duration’ (i.e. lifetime) of the Certificate                                                                                                                                      | `8760h0m0s`                                                                                                                                           |
| certificate.renewBefore | The amount of time before the currently issued certificate’s notAfter time that cert-manager will begin to attempt to renew the certificate                                                      | `720h0m0s`                                                                                                                                            |
| certificate.subject | Full X509 name specification for certificate                                                                                                                                                     | `{}`                                                                                                                                                  |
| certificate.commonName | CommonName is the common name as specified on the DER encoded CSR                                                                                                                                | `admin-app`                                                                                                                                           |
| certificate.keyAlgorithm | KeyAlgorithm is the private key algorithm of the corresponding private key for this certificate                                                                                                  | `rsa`                                                                                                                                                 |
| certificate.keyEncoding | KeyEncoding is the private key cryptography standards (PKCS) for this certificate’s private key to be encoded in                                                                                 | `pkcs1`                                                                                                                                               |
| certificate.keySize | KeySize is the key bit size of the corresponding private key for this certificate                                                                                                                | `2048`                                                                                                                                                |
| certificate.isCA | IsCA will mark this Certificate as valid for certificate signing                                                                                                                                 | `false`                                                                                                                                               |
| certificate.usages | Usages is the set of x509 usages that are requested for the certificate                                                                                                                          | `{}`                                                                                                                                                  |
| certificate.dnsNames | DNSNames is a list of DNS subjectAltNames to be set on the Certificate.                                                                                                                          | `{}`                                                                                                                                                  |
| certificate.ipAddresses | IPAddresses is a list of IP address subjectAltNames to be set on the Certificate.                                                                                                                | `{}`                                                                                                                                                  |
| certificate.uriSANs | URISANs is a list of URI subjectAltNames to be set on the Certificate.                                                                                                                           | `{}`                                                                                                                                                  |
| certificate.emailSANs | EmailSANs is a list of email subjectAltNames to be set on the Certificate.                                                                                                                       | `{}`                                                                                                                                                  |
| certificate.privateKey.enabled | Enable private key for the certificate                                                                                                                                                           | `false`                                                                                                                                               |
| certificate.privateKey.rotationPolicy | Denotes how private keys should be generated or sourced when a Certificate is being issued.                                                                                                      | `Always`                                                                                                                                              |
| certificate.issuerRef.name | IssuerRef is a reference to the issuer for this certificate. Name of the resource being referred to                                                                                              | `ca-issuer`                                                                                                                                           |
| certificate.issuerRef.kind | Kind of the resource being referred to                                                                                                                                                           | `ClusterIssuer`                                                                                                                                       |
| certificate.keystores.enabled | Enables keystore configuration. Keystores configures additional keystore output formats stored in the secretName Secret resource                                                                 | `false`                                                                                                                                               |
| certificate.keystores.pkcs12.create | Enables PKCS12 keystore creation for the Certificate. PKCS12 configures options for storing a PKCS12 keystore in the spec.secretName Secret resource                                             | `true`                                                                                                                                                |
| certificate.keystores.pkcs12.key | The key of the entry in the Secret resource’s data field to be used                                                                                                                              | `test_key`                                                                                                                                            |
| certificate.keystores.pkcs12.name | The name of the Secret resource being referred to                                                                                                                                                | `test-creds`                                                                                                                                          |
| certificate.keystores.jks.create | Enables jks keystore creation for the Certificate. JKS configures options for storing a JKS keystore in the spec.secretName Secret resource                                                      | `false`                                                                                                                                               |
| certificate.keystores.jks.key | The key of the entry in the Secret resource’s data field to be used                                                                                                                              | `test_key`                                                                                                                                            |
| certificate.keystores.jks.name | The name of the Secret resource being referred to                                                                                                                                                | `test-creds`                                                                                                                                          |

### Alertmanager Config Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| alertmanagerConfig.enabled | Enable alertmanagerConfig for this app (Will be merged in the base config)                                                                                                                       | `false`                                                                                                                                               |
| alertmanagerConfig.selectionLabels | Labels for this config to be selected for merging in alertmanager base config                                                                                                                    | `alertmanagerConfig: "workload"`                                                                                                                      |
| alertmanagerConfig.spec.route | The Alertmanager route definition for alerts matching the resource’s namespace. It will be added to the generated Alertmanager configuration as a first-level route                              | `{}`                                                                                                                                                  |
| alertmanagerConfig.spec.receivers | List of receivers                                                                                                                                                                                | `[]`                                                                                                                                                  |
| alertmanagerConfig.spec.inhibitRules | InhibitRule defines an inhibition rule that allows to mute alerts when other alerts are already firing                                                                                           | `[]`                                                                                                                                                  |

### PrometheusRule Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| prometheusRule.enabled | Enable prometheusRule for this app                                                                                                                                                               | `false`                                                                                                                                               |
| prometheusRule.additionalLabels | Kubernetes labels object, these additional labels will be added to PrometheusRule CRD                                                                                                            | `{}`                                                                                                                                                  |
| prometheusRule.spec.groups | PrometheusRules in their groups to be added                                                                                                                                                      | `[]`                                                                                                                                                  |

### SecretProviderClass Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| secretProviderClass.enabled | Enables Secret Provider Class Custom Resource                                                                                                                                                    | `false`                                                                                                                                               |
| secretProviderClass.name | Name of Secret Provider Class Custom Resource                                                                                                                                                    | `""`                                                                                                                                                  |
| secretProviderClass.provider | Provider of Secret Provider Class Custom Resource                                                                                                                                                | `""`                                                                                                                                                  |
| secretProviderClass.vaultAddress | Address of vault                                                                                                                                                                                 | `""`                                                                                                                                                  |
| secretProviderClass.roleName | Name of the role being referred to in vault                                                                                                                                                      | `""`                                                                                                                                                  |
| secretProviderClass.objects | The object created from the secret in vault                                                                                                                                                      | `[]`                                                                                                                                                  |
| secretProviderClass.secretObjects | This creates the kubernetes secret                                                                                                                                                               | `""`                                                                                                                                                  |
### ExternalSecret Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| externalSecret.enabled | Enables External Secret Custom Resource                                                                                                                                                          | `false`                                                                                                                                               |
| externalSecret.secretStore.name | Defines name of default SecretStore to use when fetching the secret data                                                                                                                         | `tenant-vault-secret-store`                                                                                                                           |
| externalSecret.secretStore.kind | Defines kind as SecretStore or ClusterSecretStore                                                                                                                                                | `SecretStore`                                                                                                                                         |
| externalSecret.refreshInterval | Amount of time before the values reading again from the SecretStore provider                                                                                                                     | `1m`                                                                                                                                                  |
| externalSecret.files | Array of secret files with name and remote reference data contained in those files                                                                                                               | `[]`                                                                                                                                                  |

### NetworkPolicy Paramaters
| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| networkPolicy.enabled    | Enable NetworkPolicy                                                                         | `false`         |
| networkPolicy.additionalLabels | Kubernetes labels object                                                               | `{}`            |
| networkPolicy.annotations | Annotations for NetworkPolicy                                                               | `{}`            |
| networkPolicy.ingress | Ingress ruels for NetworkPolicy                                                                 | `[]`            |
| networkPolicy.egress | egress rules for NetworkPolicy                                                                   | `[]`            |

### Backup Paramaters
| Name | Description | Value |
| ---- | ----------- | ----- |
| backup.enabled    | Enable Backup | `false` |
| backup.namespace | Backup Namespace | `""` |
| backup.storageLocation | StorageLocation for Backup | `""` |
| backup.includedNamespaces | Namespaces to be included in Backup | `[]` |
| backup.excludedResources | Resources to be excluded in Backup | `[]` |
| backup.ttl | Time Duration for Backup | `1h0m0s` |
| backup.snapshotVolumes | Weather SnapshotVolumes in Backup | `true` |

### Grafana Dashboard Paramaters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| grafanaDashboard.enabled | Enables Grafana Dashboard                                                                    | `false`         |
| grafanaDashboard.additionalLabels | Kubernetes labels object                                                            | `{}`            |
| grafanaDashboard.annotations | Annotations for Grafana Dashboard                                                        | `{}`            |
| grafanaDashboard.contents.key | Used as name of Grafana Dashboard object                                                | `""`            |
| grafanaDashboard.contents.key.json | json string used as content of Grafana Dashboard object                            | `""`            |
| grafanaDashboard.contents.key.url| Url used to fetch dashboard content. According to GrafanaDashboard behavior, if both url and json are specified then the GrafanaDashboard content will be updated with fetched content from url                                                    | `""`            |
| grafanaDashboard.contents.key.instanceSelector | selects Grafana instances for import                                                  | `{}`    |
| grafanaDashboard.contents.key.folder           | folder assignment for dashboard                                                | `""`    |
| grafanaDashboard.contents.key.configMapRef     | dashboard from configmap                                               | `[]`    |
| grafanaDashboard.contents.key.datasources      | maps required data sources to existing ones                                                  | `{}`    |

### CronJob Parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `cronJob.enabled`        | Enable cronjob in application chart                                                          | `""`            |
| `cronJob.jobs`           | cronjobs spec                                                                                | {}              |

Job parameter for each cronjob object at `cronJob.jobs`

| Name                                | Description                                                    |
| ----------------------------------- | -------------------------------------------------------------- |
| `<name>.schedule`                   | Schedule of cronjob                                            |
| `<name>.timeZone`                   | Time zone of cronjob (Supported on K8s version 1.27 or Higher) |
| `<name>.image.repository`           | Repository of container image of cronjob                       |
| `<name>.image.tag`                  | Tag of container image of cronjob                              |
| `<name>.image.digest`               | Digest of container image of cronjob                           |
| `<name>.image.imagePullPolicy`      | ImagePullPolicy of container image of cronjob                  |
| `<name>.command`                    | Command of container of job                                    |
| `<name>.args`                       | Args of container of job                                       |
| `<name>.priorityClassName`          | Defines the priority class of job                              |
| `<name>.resources`                  | Resources of container of job                                  |
| `<name>.additionalLabels`           | Additional labels of cronjob                                   |
| `<name>.annotations`                | Annotation of cronjob                                          |
| `<name>.successfulJobsHistoryLimit` | Successful jobs historyLimit of cronjob                        |
| `<name>.concurrencyPolicy`          | ConcurrencyPolicy of cronjob                                   |
| `<name>.failedJobsHistoryLimit`     | FailedJobsHistoryLimit of cronjob                              |
| `<name>.volumeMounts`               | Volume mounts  of cronjob                                      |
| `<name>.volumes`                    | Volumes  of cronjob                                            |
| `<name>.nodeSelector`               | Node selector of cronjob                                       |
| `<name>.affinity`                   | Affinity of cronjob                                            |
| `<name>.tolerations`                | Tolerations of cronjob                                         |
| `<name>.restartPolicy`              | RestartPolicy of cronjob                                       |
| `<name>.imagePullSecrets`           | ImagePullSecrets of cronjob                                    |
| `<name>.activeDeadlineSeconds`      | ActiveDeadlineSeconds of job                                   |
| `<name>.backoffLimit`               | BackoffLimit of job                                            |
| `<name>.additionalPodAnnotations`   | Additional annotations of pod of job                           |
| `<name>.additionalPodLabels`        | Additional labels of pod of job                                |
| `<name>.topologySpreadConstraints`  | TopologySpreadConstraints of pod of job                        |
| `<name>.securityContext`            | SecurityContext of pod of job                                  |

### Job Parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `job.enabled`            | Enable job in application chart                                                              | `""`            |
| `job.jobs`               | jobs spec                                                                                    | {}              |

Job parameter for each job object at `job.jobs`

| Name                                | Description                                   |
| ----------------------------------- | --------------------------------------------- |
| `<name>.image.repository`           | Repository of container image of job          |
| `<name>.image.tag`                  | Tag of container image of job                 |
| `<name>.image.digest`               | Digest of container image of job              |
| `<name>.image.imagePullPolicy`      | ImagePullPolicy of container image of job     |
| `<name>.command`                    | Command of container of job                   |
| `<name>.args`                       | Args of container of job                      |
| `<name>.resources`                  | Resources of container of job                 |
| `<name>.additionalLabels`           | Additional labels of job                      |
| `<name>.annotations`                | Annotation of job                             |
| `<name>.volumeMounts`               | Volume mounts  of job                         |
| `<name>.volumes`                    | Volumes  of job                               |
| `<name>.nodeSelector`               | Node selector of job                          |
| `<name>.affinity`                   | Affinity of job                               |
| `<name>.tolerations`                | Tolerations of job                            |
| `<name>.restartPolicy`              | RestartPolicy of job                          |
| `<name>.imagePullSecrets`           | ImagePullSecrets of job                       |
| `<name>.activeDeadlineSeconds`      | ActiveDeadlineSeconds of job                  |
| `<name>.backoffLimit`               | BackoffLimit of job                           |
| `<name>.additionalPodAnnotations`   | Additional annotations of pod of job          |
| `<name>.additionalPodLabels`        | Additional labels of pod of job               |
| `<name>.topologySpreadConstraints`  | TopologySpreadConstraints of pod of job       |
| `<name>.securityContext`            | SecurityContext of pod of job                 |

## Naming convention for ConfigMap, Secret, SealedSecret and ExternalSecret

Name format of ConfigMap, Secret, SealedSecret and ExternalSecret is ```{{ template "application.name" $ }}-{{ $nameSuffix }}``` then:

- ```{{ template "application.name" }}``` is a helper function that outputs ```.Values.applicationName``` if exist else return chart name as output
- `nameSuffix` is the each key in ```secret.files```,```configMap.files```, ```sealedSecret.files``` and ```externalSecret.files```

For example if we have following values file:

```
applicationName: helloworld # {{ template "application.name" $ }}

configMap:
  files:
    config: # {{ $nameSuffix }}
      key: value
```

then the configmap name will be ``helloworld-config``

## Consuming environment variable in application chart

In order to use environment variable in deployment or cronjob, you will have to provide environment variable in *key/value* pair in `env` value. where key being environment variable key and value varies in different scenarios 

- For simple key/value environment variable, just provide `value: <value>` 
  ```
   env:
      KEY:
        value: MY_VALUE
  ```

 - To get environement variable value from **ConfigMap**
  
   Suppose we have configmap created from applicaion chart
   
   ```
   applicationName: my-application
   configMap:
     enabled: true
     files:
       application-config:
         LOG: DEBUG
         VERBOSE: v1
   ```
   To get environment variable value from above created configmap, we will need to add following
   ```
   env:
    APP_LOG_LEVEL:
     valueFrom:
       configMapKeyRef:
         name: my-application-appication-config
         key: LOG
   ```
   To get all environment variables key/values from **ConfigMap**, where configmap key being key of environment variable and value being value
   ```
     envFrom:
      application-config-env:
        type: configmap
        nameSuffix: application-config
   ```
   you can either provide `nameSuffix` which means name added after prefix ```<applicationName>-``` or static name with ```name``` of configmap.

- To get environment variable value from **Secret**
   
   Suppose we have secret created from application chart
   ```
    applicationName: my-application
    secret:
      enabled: true
      files:
         db-credentials:
           PASSWORD: skljd#2Qer!!
           USER: postgres
   ```

   To get environment variable value from above created secret, we will need to add following
   ```
     env:
        KEY:
         valueFrom:
          secretKeyRef:
            name: my-application-db-credentials
            key: USER
   ``` 

   To get environement variable value from **Secret**, where secret key being key of environment variable and value being value
   ```
   envFrom:
     database-credentials:
        type: secret
        nameSuffix: db-credentials
   ```
   you can either provide `nameSuffix` which means name added after prefix ```<applicationName>-``` or static name with ```name``` of secret

   **Note:** first key after ``envFrom`` is just used to uniquely identify different objects in ``envFrom`` block. Make sure to keep it unique and relevant 

## Configuring probes

To disable liveness or readiness probe, set value of `enabled` to `false`.

```
  livenessProbe:
    enabled: false
```

By default probe handler type is `httpGet`. You just need to override `port` and `path` as per your need.

```
  livenessProbe:
    enabled: true
    httpGet:
      path: '/path'
      port: 8080
```

In order to use `exec` handler, you can define field `livenessProbe.exec` in your values.yaml.

```
  livenessProbe:
    enabled: true
    exec:
      command:
        - cat
        - /tmp/healthy
```
