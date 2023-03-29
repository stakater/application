
# Changelog

All notable changes to this project will be documented here.

### v2.1.7
- Fix: Add ingress path with default configuration if not specified at all. [PR-240](https://github.com/stakater/application/pull/240)

### v2.1.6
- Fix: Qoute application version label in labels [PR-238](https://github.com/stakater/application/pull/238)

### v2.1.5
- Fix: Repair ingress multiple paths definitions [PR-233](https://github.com/stakater/application/pull/233)

### v2.1.4
- Update: Add MIT License [PR-237](https://github.com/stakater/application/pull/237)

### v2.1.2 && v2.1.3
- Update: Improve enable conditions by adding capabilites, use `_helpers.tpl` properly, Move to common k8s labels and remove other labels [PR-226](https://github.com/stakater/application/pull/226)
- Feature: Make `ingress` path configurable [PR-226](https://github.com/stakater/application/pull/226)
- Fix: Add dependency for `helm_resource` on relevant `helm_repo` in tiltfile [PR-231](https://github.com/stakater/application/pull/231)

### v2.1.1
- Fix: added template for oauth proxy deployment to use http container port in case of ingress

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
