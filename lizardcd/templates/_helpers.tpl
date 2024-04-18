{{/*
Expand the name of the chart.
*/}}
{{- define "lizardcd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "common.names.fullname" -}}
{{- if .Values.global.commonName -}}
{{- .Values.global.commonName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.global.commonName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "lizardcd.imagePullSecrets" -}}
{{ include "common.images.renderPullSecrets" (dict "images" (list .Values.server.image .Values.agent.image .Values.ui.image) "context" $) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "lizardcd.server.fullname" -}}
{{- if .Values.server.fullnameOverride }}
{{- .Values.server.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "lizardcd-server" .Values.server.fullnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "lizardcd.agent.fullname" -}}
{{- if .Values.agent.fullnameOverride }}
{{- .Values.agent.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "lizardcd-agent" .Values.server.fullnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "lizardcd.ui.fullname" -}}
{{- if .Values.ui.fullnameOverride }}
{{- .Values.ui.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "lizardcd-ui" .Values.ui.fullnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "lizardcd.initJob.fullname" -}}
{{- if .Values.initJob.fullnameOverride }}
{{- .Values.initJob.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "lizardcd-initjob" .Values.ui.fullnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "lizardcd.server.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.server.image "global" .Values.global) }}
{{- end -}}

{{- define "lizardcd.agent.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.agent.image "global" .Values.global) }}
{{- end -}}

{{- define "lizardcd.ui.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.ui.image "global" .Values.global) }}
{{- end -}}

{{- define "lizardcd.initJob.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.initJob.image "global" .Values.global) }}
{{- end -}}

{{- define "lizardcd.consulhost" -}}
{{- if .Values.consul.enabled -}}
{{- $name := "consul-headless:8500" }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Values.externalConsul.consul_host }}
{{- end -}}
{{- end -}}

{{- define "lizardcd.etcdhost" -}}
{{- if .Values.etcd.enabled -}}
{{- $name := "etcd" }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end -}}
{{- end -}}

{{- define "lizardcd.ui.externalServer" -}}
{{- if .Values.ui.externalServer -}}
{{- printf "%s:%s" .Values.ui.externalServer.server .Values.ui.externalServer.port }}
{{- end -}}
{{- end -}}

{{- define "lizardcd.server.enabled" -}}
{{- if and .Values.server.enabled (gt (int .Values.server.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{- define "lizardcd.agent.enabled" -}}
{{- if and .Values.agent.enabled (gt (int .Values.agent.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{- define "lizardcd.ui.enabled" -}}
{{- if and .Values.ui.enabled (gt (int .Values.ui.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "lizardcd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
server labels
*/}}
{{- define "lizardcd.server.labels" -}}
helm.sh/chart: {{ include "lizardcd.chart" . }}
app: {{ include "lizardcd.server.fullname" . }}
{{ include "lizardcd.server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
agent labels
*/}}
{{- define "lizardcd.agent.labels" -}}
helm.sh/chart: {{ include "lizardcd.chart" . }}
app: {{ include "lizardcd.agent.fullname" . }}
{{ include "lizardcd.agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
ui labels
*/}}
{{- define "lizardcd.ui.labels" -}}
helm.sh/chart: {{ include "lizardcd.chart" . }}
app: {{ include "lizardcd.ui.fullname" . }}
{{ include "lizardcd.ui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "lizardcd.server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lizardcd.server.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ include "lizardcd.server.fullname" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "lizardcd.agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lizardcd.agent.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ include "lizardcd.agent.fullname" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "lizardcd.ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lizardcd.ui.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ include "lizardcd.ui.fullname" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "lizardcd.server.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create }}
{{- default (include "lizardcd.server.fullname" .) .Values.server.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.server.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "lizardcd.agent.serviceAccountName" -}}
{{- if .Values.agent.serviceAccount.create }}
{{- default (include "lizardcd.agent.fullname" .) .Values.agent.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.agent.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "lizardcd.ui.serviceAccountName" -}}
{{- if .Values.ui.serviceAccount.create }}
{{- default (include "lizardcd.ui.fullname" .) .Values.ui.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.ui.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "lizardcd.initJob.serviceAccountName" -}}
{{- if .Values.initJob.serviceAccount.create }}
{{- default (include "lizardcd.initJob.fullname" .) .Values.initJob.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.initJob.serviceAccount.name }}
{{- end }}
{{- end }}
