
# Changelog

All notable changes to this project will be documented here.

### v2.1.0
- Fix: added oauth proxy image template and test to ensure oauth deployment image is not added in default case

### v2.0.0
- Update: Updating ExternalSecret from v1alpha1 to v1beta1

### v1.3.3
- Feature: Uncomment liveness and readiness probes in default values. Set enabled:false in probes.

### v1.3.2
- Feature: Comment liveness and readiness probe in default values.

### v1.3.1
- Feature: Support for specifiying tcpSocket probe check mechanisms in probes.

### v1.3.0
- Feature: Support for adding Security Context at conatiner level in deployment.

### v1.2.11
- Feature: Use `policy/v1/PodDisruptionBudget` if supported by the target cluster.

### v1.2.10
- Feature: Add `image.digest` field to deployment and cronjob resources.

### v1.2.8 & v1.2.9
- Update: Update `route` template, add support for `alternateBackends` 

### v1.2.7
- Update: Update `Certificate` template from `cert-manager.io/v1alpha3` to `cert-manager.io/v1` in order to support cert-manager v1.7.

### v1.2.6
- Feature: add service type in service template.

### v1.2.5
- Feature: add name, volumeName and volumeMode in pvc template.

### v1.2.4
- Fix: namespace indentation for rolebinding

### v1.2.3
- Feature: add ingressClassName in ingress template.

### v1.2.1
- Fix: change label `chart: {{ .Chart.Name }}-{{ .Chart.Version }} ` to `chart: {{ .Chart.Name }}`.

### v1.2.0
- Fix: remove `probes` key from deployment. Note: This is a breaking change. Applications need to update values file accordingly.

### v1.1.14
- Feature: replica field is made optional

### v1.1.13
- Fix: fix templating error in `Deployment.envFrom.secretRef`, fixes an `error converting YAML to JSON` error when `application.deployment.envfrom[].name` is set.

### v1.1.12
- Fix: add `probes` key back to deployment

### v1.1.11
- Fix: remove network policy default value

### v1.1.10
- Feature: add functionality to set `type` in sealed secrets
- Feature: add functionality for adding annotation for `cluster-wide` in sealed secrets
- Feature: add functionality to add `annotations` to each sealed secret separately
- Feature: add functionality to add `labels` to each sealed secret separately

### v1.1.9
- Feature: add functionality to disable liveness and readiness probes.
- Feature: support `exec` handler type in liveness and readiness probes 
- Feature: support for setting individual values for probe configuration is added.

### v1.1.8
- Fix: add an application name prefix in the external secret name.  

### v0.1.6
- Fix: corrected the namespace indentation in rolebinding template. Corresponding chart package has been pushed to helmchart repo manually.
