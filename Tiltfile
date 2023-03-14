load('ext://helm_resource', 'helm_resource', 'helm_repo')
load('ext://namespace', 'namespace_create', 'namespace_inject')

settings = read_json('tilt-settings-sno3.json', default={})
helm_registry_user = settings.get("helm_registry_user")
helm_registry_pwd = settings.get("helm_registry_pwd")

if settings.get("allow_k8s_contexts"):
  allow_k8s_contexts(settings.get("allow_k8s_contexts"))

# Add helm repos
helm_repo('stakater', 'https://stakater.github.io/stakater-charts')
helm_repo('sealed-secrets', 'https://bitnami-labs.github.io/sealed-secrets')

# Install IMC
imc_namespace = "stakater-imc"
namespace_create(imc_namespace)
helm_resource('imc', 'stakater/ingressmonitorcontroller', namespace=imc_namespace)

# Install Forecastle
forecastle_namespace = "stakater-forecastle"
namespace_create(forecastle_namespace)
helm_resource('forecastle', 'stakater/forecastle', namespace=forecastle_namespace)

# Install SealedSecrets
sealedsecrets_namespace = "sealed-secrets"
namespace_create(sealedsecrets_namespace)
helm_resource('sealedsecrets', 'sealed-secrets/sealed-secrets', namespace=sealedsecrets_namespace)

# Install ExternalSecrets
externalsecrets_namespace = "external-secrets-operator"
namespace_create(externalsecrets_namespace)
helm_resource('external-secrets-operator', 'oci://ghcr.io/stakater/charts/external-secrets-operator', namespace=externalsecrets_namespace, flags=['--version=0.0.2','--username=helm_registry_user','--password=helm_registry_pwd','--set','operator.installPlanApproval=Automatic'])

# Install grafana-operator
grafana_namespace = "grafana-operator"
namespace_create(grafana_namespace)
helm_resource('grafana-operator', 'oci://ghcr.io/stakater/charts/grafana-operator', namespace=grafana_namespace, flags=['--version=0.0.1','--username=helm_registry_user','--password=helm_registry_pwd','--set','operator.installPlanApproval=Automatic'])

# Install cert-manager
# it exists already
