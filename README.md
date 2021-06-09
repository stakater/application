# Application
Generic helm chart for all kind of applications

# Installing the Chart

To install the chart with the release name my-application in namespace test:

    helm repo add stakater https://stakater.github.io/stakater-charts
    helm repo update
    helm install my-application stakater/application --namespace test

# Uninstall the Chart

To uninstall the chart:

    helm delete <name-of-the-chart>

# Configuration

| Parameter | Description | Default |
|:---|:---|:----|
| applicationName | Name of the application | `application` |
| namespaceOverride | Override default release namespace with a custom value | `application` |
| labels.group | Label to define application group | `com.stakater.platform` |
| labels.team | Label to define team | `stakater` |
| deployment.strategy | Strategy for updating deployments |`RollingUpdate`|
| deployment.reloadOnChange| Reload deployment if configMap/secret mounted are updated | `true` |
| deployment.nodeSelector | Select node to deploy this application | `{}` |
| deployment.initContainers | Init containers which runs before the app container | `[]` |
| deployment.additionalLabels | Additional labels for Deployment | `{}` |
| deployment.podLabels | Additional label added on pod which is used in Service's Label Selector | {} |
| deployment.annotations | Annotations on deployments | `{}` |
| deployment.additionalPodAnnotation  | Additional Pod Annotations added on pod created by this Deployment | `{}` |
| deployment.fluentdConfigAnnotations | Annotations for fluentd Configurations | `{}` |
| deployment.replicas | Replicas to be created | `2` |
| deployment.imagePullSecrets | Secrets used to pull image | `""` |
| deployment.envFrom | Environment variables to be picked from configmap or secret | `[]` |
| deployment.envFrom.type | Type of data i.e. Configmap or Secret | `` |
| deployment.envFrom.name | Name of Configmap or Secret, if set empty, set to application name | `` |
| deployment.envFrom.nameSuffix | Suffix Name of Configmap or Secret, applicationName is appended as prefix | `` |
| deployment.env | Environment variables to be passed to the app container | `[]` |
| deployment.volumes | Volumes to be added to the pod | `[]` |
| deployment.volumeMounts | Mount path for Volumes | `[]` |
| deployment.command | Command for primary container of deployment | `[]` |
| deployment.args | Arg for primary container of deployment | `[]` |
| deployment.tolerations | Taint tolerations for nodes | `[]` |
| deployment.affinity | Affinity for pod/node | `[]` |
| deployment.image.repository | Image repository for the application | `repository/image-name` |
| deployment.image.tag | Tag of the application Image | `v1.0.0` |
| deployment.image.pullPolicy | Pull policy for the application image | `IfNotPresent` |
| deployment.ports | Ports for primary container | `[]` |
| deployment.probes.readinessProbe | The readiness probe block | `{"failureThreshold":3,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":1,"initialDelaySeconds":"10\nhttpGet:\n  path: /path\n  port: 8080"}` |
| deployment.probes.livenessProbe| The livenessness probe block. | `{"failureThreshold":3,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":1,"initialDelaySeconds":"10\nhttpGet:\n  path: /path\n  port: 8080"}` |
| deployment.resources | Application pod resource requests & limits |     limits:<br>&nbsp;&nbsp;memory: 256Mi<br>&nbsp;&nbsp;cpu: 1<br>requests:<br>&nbsp;&nbsp;memory: 128Mi<br>&nbsp;&nbsp;cpu: 0.5 |
| deployment.openshiftOAuthProxy.enabled | Add Openshift OAuth Proxy as SideCar Container | `false` |
| deployment.openshiftOAuthProxy.port | Application port so proxy should forward to this port | `8080` |
| deployment.openshiftOAuthProxy.secretName | Secret name containing the TLS cert | `openshift-oauth-proxy-tls` |
| deployment.additionalContainers | Add additional containers besides init and app containers | `[]` |
| deployment.securityContext | Security Context for the pod | `{}` |
| persistence.enabled | Enable persistence | `false` |
| persistence.mountPVC | Whether to mount the created PVC to the deployment | `false` |
| persistence.mountPath | If `persistence.mountPVC` is set, so where to mount the volume in the deployment | `/` |
| persistence.accessMode | Access mode for volume | `ReadWriteOnce` |
| persistence.storageClass | StorageClass of the volume  | `-` |
| persistence.additionalLabels | Additional labels for persistent volume | `{}` |
| persistence.annotations | Annotations for persistent volume | `{}` |
| persistence.storageSize | Size of the persistent volume | `8Gi` |
| service.additionalLabels | Additional labels for service | `{}` |
| service.annotations | Annotations for service | `{}` |
| service.ports | Ports for applications service | - port: 8080<br>&nbsp;&nbsp;name: http<br>&nbsp;&nbsp;protocol: TCP<br>&nbsp;&nbsp;targetPort: 8080 |
| ingress.enabled | Enable ingress | `false` |
| ingress.servicePort | Port of the service that serves pod | `8080` |
| ingress.hosts | Array of FQDN hosts to be served by this ingress | `- chart-example.local` |
| ingress.annotations | Annotations for ingress | `{}` |
| ingress.tls | TLS block for ingress | `[]` |
| route.enabled | Enable Route incase of Openshift | `false` |
| route.host | Host of route | nil |
| route.annotations | Annotations for route | `{}` |
| route.additionalLables | Labels for route | `{}` |
| route.port.targetPort | Port of the service that serves pods | `http` |
| route.wildcardPolicy | Route wildcard policy | `None` |
| route.tls.termination | TLS termination strategy | `edge` |
| route.tls.insecureEdgeTerminationPolicy | TLS termination policy for insecure traffic | `Redirect` |
| forecastle.enabled | Enable Forecastle | `false` |
| forecastle.additionalLabels | Additional labels for Forecastle Custom Resource | `{}` |
| forecastle.icon | URL of application icon display on forecastle dashboard | `https://raw.githubusercontent.com/stakater/ForecastleIcons/master/stakater-big.png` |
| forecastle.displayName | Name of the application to be displayed on Forecastle dashboard | `application` |
| forecastle.group | Group application on Forecastle dashboard | if not defined Namespace name is used |
| forecastle.properties | Additional properties for Custom Resource | `{}` |
| forecastle.networkRestricted | Whether app is network restricted or not | `false` |
| rbac.enabled | Enable RBAC | `true` |
| rbac.serviceAccount.enabled | Enable serviceAccount | `false` |
| rbac.serviceAccount.name | Name of the existing serviceAccount | `""` |
| rbac.serviceAccount.additionalLabels | Labels for serviceAccount | `{}` |
| rbac.serviceAccount.annotations | Annotations for serviceAccount | `{}` |
| rbac.roles | Array of roles | `[]` |
| rbac.clusterroles | Array of clusterroles | `[]` |
| configMap.enabled | Enable configMaps | `false` |
| configMap.additionalLabels | Labels for configMaps | `{}` |
| configMap.annotations | Annotations for configMaps | `{}` |
| configMap.files | Array of configMap files with suffixes and data contained in those files | `[]` |
| secret.enabled | Enable secret | `false` |
| secret.additionalLabels | Labels for secret | `{}` |
| secret.annotations | Annotations for secret | `{}` |
| secret.files | Array of secret files with suffixes and data contained in those files | `[]` |
| serviceMonitor.enabled | Enable serviceMonitor | `false` |
| serviceMonitor.additionalLabels | Labels for serviceMonitor | `{}` |
| serviceMonitor.annotations | Annotations for serviceMonitor | `{}` |
| serviceMonitor.jobLabel | Job Label used for application selector | `k8s-app` |
| serviceMonitor.endpoints | Array of endpoints to be scraped by prometheus |   - interval: 5s<br>&nbsp;&nbsp;path: /actuator/prometheus<br>&nbsp;&nbsp;port: http |
| autoscaling.enabled | Enable horizontal pod autoscaler | `false` |
| autoscaling.additionalLabels | Labels for horizontal pod autoscaler | `{}` |
| autoscaling.annotations | Annotations for horizontal pod autoscaler | `{}` |
| autoscaling.minReplicas | Sets minimum replica count when autoscaling is enabled | `1` |
| autoscaling.maxReplicas | Sets maximum replica count when autoscaling is enabled | `10` |
| autoscaling.metrics | Configuration for hpa metrics, set when autoscaling is enabled | `{}` |
| endpointMonitor.enabled | Enable endpointMonitor for IMC (https://github.com/stakater/IngressMonitorController) | `false` |
| endpointMonitor.additionalLabels | Labels for endpointMonitor | `{}` |
| endpointMonitor.annotations | Annotations for endpointMonitor | `{}` |
| endpointMonitor.additionalConfig | Additional Config for endpointMonitor | `{}` |
| space.enabled | Enable Space Custom Resource | `false` |
| space.additionalLabels | Additional labels for Space Custom Resource | `{}` |
| space.annotations | Annotations for Space Custom Resource | `{}` |
| space.tenant | Tenant associated with Space Custom Resource | `""` |
| sealedSecret.enabled | Enable sealed secret | `false` |
| sealedSecret.additionalLabels | Labels for sealed secret | `{}` |
| sealedSecret.annotations | Annotations for sealed secret | `{}` |
| sealedSecret.files | Array of secret files with name and encrypted data contained in those files | `[]` |
| certificate.enabled | Enable Certficate Custom Resource | `false` |
| certificate.enabled | Enable Certficate Custom Resource | `false` |
| certificate.additionalLabels | Additional labels for Certificate Custom Resource  | `{}` |
| certificate.annotations | Annotations for Certificate Custom Resource  | `{}` |
| certificate.secretName | SecretName is the name of the secret resource that will be automatically created and managed by this Certificate resource  | `tls-cert` |
| certificate.duration | The requested ‘duration’ (i.e. lifetime) of the Certificate  | `8760h0m0s` |
| certificate.renewBefore | The amount of time before the currently issued certificate’s notAfter time that cert-manager will begin to attempt to renew the certificate  | `720h0m0s` |
| certificate.subject | Full X509 name specification for certificate  | `{}` |
| certificate.commonName | CommonName is the common name as specified on the DER encoded CSR  | `admin-app` |
| certificate.keyAlgorithm | KeyAlgorithm is the private key algorithm of the corresponding private key for this certificate | `rsa` |
| certificate.keyEncoding | KeyEncoding is the private key cryptography standards (PKCS) for this certificate’s private key to be encoded in  | `pkcs1` |
| certificate.keySize | KeySize is the key bit size of the corresponding private key for this certificate  | `2048` |
| certificate.isCA | IsCA will mark this Certificate as valid for certificate signing | `false` |
| certificate.usages | Usages is the set of x509 usages that are requested for the certificate  | `{}` |
| certificate.dnsNames | DNSNames is a list of DNS subjectAltNames to be set on the Certificate.  | `{}` |
| certificate.ipAddresses | IPAddresses is a list of IP address subjectAltNames to be set on the Certificate.  | `{}` |
| certificate.uriSANs | URISANs is a list of URI subjectAltNames to be set on the Certificate.  | `{}` |
| certificate.emailSANs | EmailSANs is a list of email subjectAltNames to be set on the Certificate.  | `{}` |
| certificate.privateKey.enabled | Enable private key for the certificate  | `false` |
| certificate.privateKey.rotationPolicy | Denotes how private keys should be generated or sourced when a Certificate is being issued.  | `Always` |
| certificate.issuerRef.name | IssuerRef is a reference to the issuer for this certificate. Name of the resource being referred to | `ca-issuer` |
| certificate.issuerRef.kind | Kind of the resource being referred to | `ClusterIssuer` |
| certificate.keystores.enabled | Enables keystore configuration. Keystores configures additional keystore output formats stored in the secretName Secret resource | `false` |
| certificate.keystores.pkcs12.create | Enables PKCS12 keystore creation for the Certificate. PKCS12 configures options for storing a PKCS12 keystore in the spec.secretName Secret resource | `true` |
| certificate.keystores.pkcs12.key | The key of the entry in the Secret resource’s data field to be used | `test_key` |
| certificate.keystores.pkcs12.name | The name of the Secret resource being referred to | `test-creds` |
| certificate.keystores.jks.create | Enables jks keystore creation for the Certificate. JKS configures options for storing a JKS keystore in the spec.secretName Secret resource | `false` |
| certificate.keystores.jks.key | The key of the entry in the Secret resource’s data field to be used | `test_key` |
| certificate.keystores.jks.name | The name of the Secret resource being referred to | `test-creds` |
