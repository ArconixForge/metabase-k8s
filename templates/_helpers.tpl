{{- define "k8-metabase.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "k8-metabase.labels" -}}
app.kubernetes.io/name: {{ include "k8-metabase.name" . }}
helm.sh/chart: {{ include "k8-metabase.name" . }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: Helm
{{- end -}}

{{- define "k8-metabase.pvcLabels" -}}
app: {{ include "k8-metabase.name" . }}
{{- end -}}
