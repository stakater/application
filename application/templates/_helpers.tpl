{{/* vim: set filetype=mustache: */}}

{{/*
Define the name of the chart/application.
*/}}
{{- define "application.name" -}}
{{- default .Chart.Name .Values.applicationName | trunc 63 | trimSuffix "-" -}}
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
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "application.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
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
{{- /* TODO: obsolete else case on major bump (?) */}}
{{- else }}
app.kubernetes.io/part-of: {{ include "application.name" . }}
{{- end }}
{{- include "application.additionalLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "application.selectorLabels" -}}
app.kubernetes.io/name: {{ include "application.name" . }}
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
