{{/* vim: set filetype=mustache: */}}
{{/*
Define the name of the chart/application.
*/}}
{{- define "application.name" -}}
{{- default .Chart.Name .Values.applicationName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "application.labels.selector" -}}
app: {{ template "application.name" . }}
group: {{ .Values.labels.group }}
provider: {{ .Values.labels.provider }}
team: {{ .Values.labels.team }}
{{- end -}}

{{- define "application.labels.stakater" -}}
{{ template "application.labels.selector" . }}
appVersion: "{{ .Values.deployment.image.tag }}"
{{- end -}}

{{- define "application.labels.chart" -}}
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
release: {{ .Release.Name | quote }}
heritage: {{ .Release.Service | quote }}
{{- end -}}
