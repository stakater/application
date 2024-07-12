
# Changelog

All notable changes to this project will be documented here.

### Unreleased

#### Feature

- Feature: Add Job template

### v4.1.3
- BugFix: Only add application name label to Backup Template 

### v4.1.2
- BugFix: Incorrect selectorLabels were previously added to the Backup Template

### v4.1.1
- Feature: Edit Backup template 

### v4.1.0
- Feature: Add Backup template [PR-296](https://github.com/stakater/application/pull/296)

### v3.0.0
- Feature: Updates the GrafanaDashboard api version to v1beta1.

### v2.3.2
- Feature: fix clusterIP null field introduced by [PR-275](https://github.com/stakater/application/pull/275) [PR-295](https://github.com/stakater/application/pull/295)

### v2.3.1
- Feature: Allow loadbalancer service external IP [PR-275](https://github.com/stakater/application/pull/275)
- Feature: Allowing HPA behavior to be set [PR-292](https://github.com/stakater/application/pull/292)

### v2.3.0
- Feature: allow multiple provided text types on secret creation: stringData, data and encodedData [PR-282](https://github.com/stakater/application/pull/282)

### v2.2.6
- fix: allow multiple cronjobs [PR-271](https://github.com/stakater/application/pull/271)

### v2.2.5
- fix: Namespace selector fixed for service monitor [PR-270](https://github.com/stakater/application/pull/270)

### v2.2.4
- fix: Matchlabel fixed for service monitor [PR-269](https://github.com/stakater/application/pull/269)

### v2.2.3
- feat: Add more properties to CronJob [PR-265](https://github.com/stakater/application/pull/265)

### v2.2.1
- fix: Matchlabel fixed for service monitor [PR-267](https://github.com/stakater/application/pull/267)

### v2.2.0
- Fix: Reverts [PR-240](https://github.com/stakater/application/pull/240), It can already be configured via `paths` [PR-247](https://github.com/stakater/application/pull/247)

### v2.1.18
- feat: Add vertical pod autoscaler template [PR-249](https://github.com/stakater/application/pull/249)

### v2.1.17
- feat: allow overriding revisionHistoryLimit [PR-257](https://github.com/stakater/application/pull/257)

  > Caution: This PR changes the default value for `revisionHistoryLimit` from 10 to 2.

### v2.1.16
- fix: optional service account [PR-213](https://github.com/stakater/application/pull/213)

### v2.1.15
- fix: allow setting arbitrary resource constraints [PR-255](https://github.com/stakater/application/pull/255)

### v2.1.14
- feat: allow overriding clusterIP [PR-258](https://github.com/stakater/application/pull/258)

### v2.1.13
- Fix: make deployment.image.tag and job.image.tag optional [PR-234](https://github.com/stakater/application/pull/234)

### v2.1.12
- Update: Changelog updates. This release shouldnt have been made as the head commit had [`[skip ci]`](https://docs.github.com/en/actions/managing-workflow-runs/skipping-workflow-runs). [PR-248](https://github.com/stakater/application/pull/248)

### v2.1.11
- Feature: Add topologySpreadConstraints [PR-239](https://github.com/stakater/application/pull/239)

### v2.1.10
- Chore: Add some basic unit tests and update CI workflow [PR-218](https://github.com/stakater/application/pull/218)

### v2.1.9
- Fix: Make servicePort var override possible with ingress hosts [PR-243](https://github.com/stakater/application/pull/243)

### v2.1.8
- Update: Use new API versions for HPA and CronJob if available [PR-221](https://github.com/stakater/application/pull/221)

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
