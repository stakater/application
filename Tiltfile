load('ext://helm_resource', 'helm_resource', 'helm_repo')
load('ext://namespace', 'namespace_create', 'namespace_inject')

settings = read_json('tilt-settings-sno3.json', default={})

allow_k8s_contexts(k8s_context()) # disable check

# Add Helm repos
helm_repo('stakater', 'https://stakater.github.io/stakater-charts')
helm_repo('sealed-secrets', 'https://bitnami-labs.github.io/sealed-secrets')

# Install IMC
imc_namespace = "stakater-ingress-monitor-controller"
namespace_create(imc_namespace)
helm_resource('imc', 'oci://ghcr.io/stakater/charts/ingress-monitor-controller', namespace=imc_namespace,flags=['--set','developmentMode=true'])

# Install Forecastle
forecastle_namespace = "stakater-forecastle"
namespace_create(forecastle_namespace)
helm_resource('forecastle', 'stakater/forecastle', namespace=forecastle_namespace, resource_deps=["stakater"])

# Install SealedSecrets
sealedsecrets_namespace = "sealed-secrets"
namespace_create(sealedsecrets_namespace)
helm_resource('sealedsecrets', 'sealed-secrets/sealed-secrets', namespace=sealedsecrets_namespace, flags=['--set', 'podSecurityContext.enabled=false','--set', 'containerSecurityContext.enabled=false'], resource_deps=["sealed-secrets"])

# Install ExternalSecrets
externalsecrets_namespace = "external-secrets-operator"
namespace_create(externalsecrets_namespace)
local_resource(
    'external-secrets-operator', 
    cmd='helm install external-secrets-operator -n external-secrets-operator oci://ghcr.io/stakater/charts/external-secrets-operator --version=0.0.2 --set operator.installPlanApproval=Automatic --set securityContext.runAsUser="" --set securityContext.fsGroup=""'
    )

# Install grafana-operator
grafana_namespace = "grafana-operator"
namespace_create(grafana_namespace)
local_resource(
    'grafana-operator', 
    cmd='helm install grafana-operator -n grafana-operator oci://ghcr.io/stakater/charts/grafana-operator --version=0.0.1 --set operator.installPlanApproval=Automatic'
    )

# Install cert-manager
# it exists already
