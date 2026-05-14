{{/* vim: set filetype=mustache: */}}

{{/*
Define the name of the chart/application.
*/}}
{{- define "application.name" -}}
{{- default .Release.Name .Values.applicationName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the name of the chart/application.
*/}}
{{- define "application.version" -}}
  {{- $version := default "" .Values.deployment.image.tag -}}
  {{- regexReplaceAll "[^a-zA-Z0-9_\\.\\-]" $version "-" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "application.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "application.tplvalues.render" -}}
    {{- $value := .value -}}
    {{- if or (not $value) (kindIs "invalid" $value) -}}
        {{- "" -}}
    {{- else if typeIs "string" $value -}}
        {{- tpl $value .context -}}
    {{- else -}}
        {{- tpl ($value | toYaml) .context -}}
    {{- end -}}
{{- end -}}

{{/*
Resolve chart version, allowing override for stable snapshot testing.
See: https://github.com/helm-unittest/helm-unittest/issues/197
*/}}
{{- define "application.chartVersion" -}}
{{- .Values.chartVersionOverride | default .Chart.Version -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "application.chart" -}}
{{- printf "%s-%s" .Chart.Name (include "application.chartVersion" .) | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Additional common labels
*/}}
{{- define "application.additionalLabels" -}}
{{- if .Values.additionalLabels }}
{{ include "application.tplvalues.render" ( dict "value" .Values.additionalLabels "context" $ ) }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "application.labels" -}}
app.kubernetes.io/name: {{ include "application.name" . }}
helm.sh/chart: {{ include "application.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- with include "application.version" . }}
app.kubernetes.io/version: {{ quote . }}
{{- end }}
{{- if .Values.componentOverride }}
app.kubernetes.io/component: {{ .Values.componentOverride }}
{{- end }}
{{- if .Values.partOfOverride }}
app.kubernetes.io/part-of: {{ .Values.partOfOverride }}
{{- end }}
{{- include "application.additionalLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "application.selectorLabels" -}}
app.kubernetes.io/name: {{ include "application.name" . }}
application.stakater.com/workload-class: serving
{{- end }}

{{/*
Allow the release namespace to be overridden
*/}}
{{- define "application.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride -}}
{{- end -}}

{{- define "application.sa.oauth-redirectreference" }}
apiVersion: v1
kind: OAuthRedirectReference
reference:
  kind: Route
  name: {{ include "application.name" . }}
{{- end }}

{{/*
Get the name of the service account to use.
If the service account is set to be created, return the service account name or a default name.
If the service account is not set to be created and a name is provided, return the provided name;
otherwise, return the default namespace service account.
*/}}
{{- define "application.serviceAccountName" }}
  {{- $saName := .Values.rbac.serviceAccount.name }}
  {{- if .Values.rbac.serviceAccount.create }}
    {{- empty $saName | ternary (include "application.name" .) (quote $saName) }}
  {{- else }}
    {{- empty $saName | ternary "default" (quote $saName) }}
  {{- end }}
{{- end }}

{{/*
Renders httpRoute rules with proper integer type for port fields.
Usage:
{{ include "application.httpRoute.rules" . }}
*/}}
{{- define "application.httpRoute.rules" -}}
{{- $rulesYaml := include "application.tplvalues.render" ( dict "value" .Values.httpRoute.rules "context" . ) -}}
{{- $wrappedYaml := printf "rules:\n%s" $rulesYaml -}}
{{- $parsed := $wrappedYaml | fromYaml -}}
{{- range $ruleIndex, $rule := $parsed.rules -}}
{{- if $ruleIndex }}
{{ end -}}
- {{- if $rule.matches }}
  matches: {{ $rule.matches | toYaml | nindent 4 }}
  {{- end }}
  {{- if $rule.filters }}
  filters: {{ $rule.filters | toYaml | nindent 4 }}
  {{- end }}
  {{- if $rule.sessionAffinity }}
  sessionAffinity: {{ $rule.sessionAffinity | toYaml | nindent 4 }}
  {{- end }}
  {{- if $rule.timeouts }}
  timeouts: {{ $rule.timeouts | toYaml | nindent 4 }}
  {{- end }}
  {{- if $rule.backendRefs }}
  backendRefs:
  {{- range $rule.backendRefs }}
  {{- $portVal := .port | int }}
  {{- if or (lt $portVal 1) (gt $portVal 65535) }}
    {{- fail (printf "Invalid port value: %v. Port must be between 1 and 65535" .port) }}
  {{- end }}
  - name: {{ .name }}
    port: {{ $portVal }}
    {{- if .weight }}
    weight: {{ .weight | int }}
    {{- end }}
    {{- if .namespace }}
    namespace: {{ .namespace }}
    {{- end }}
    {{- if .kind }}
    kind: {{ .kind }}
    {{- end }}
    {{- if .group }}
    group: {{ .group }}
    {{- end }}
  {{- end }}
  {{- end }}
{{- end -}}
{{- end -}}
