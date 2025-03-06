{{- define "metabase-k8s.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "k8-metabase.labels" -}}
app.kubernetes.io/name: {{ include "metabase-k8s.name" . }}
helm.sh/chart: {{ include "metabase-k8s.name" . }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: Helm
{{- end -}}

{{- define "k8-metabase.pvcLabels" -}}
app: {{ include "metabase-k8s.name" . }}
{{- end -}}
