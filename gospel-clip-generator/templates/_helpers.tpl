{{/*
Expand the name of the chart.
*/}}
{{- define "gospel.name" -}}
{{-  .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "gospel.namespace" -}}
{{- default "gospel" .Values.namespace -}}
{{- end }}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gospel.fullname" -}}
{{- $name := include "gospel.name" . -}}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gospel.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gospel.labels" -}}
helm.sh/chart: {{ include "gospel.chart" . }}
{{ include "gospel.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gospel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gospel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

# Determine which database host to use
{{- define "gospel.databaseHost" -}}
{{- if .Values.externalDatabase.enabled -}}
{{- required "A valid external database host is required" .Values.externalDatabase.host -}}
{{- else -}}
{{- printf "%s-mysql.%s.svc.cluster.local" (include "gospel.name" .) .Release.Namespace -}}
{{- end -}}
{{- end }}

# Determine which database username to use
{{- define "gospel.databaseUsername" -}}
{{- if .Values.externalDatabase.enabled -}}
{{- required "A valid external database username is required" .Values.externalDatabase.username -}}
{{- else -}}
{{- required "A valid MySQL username is required" .Values.mysql.auth.username -}}
{{- end -}}
{{- end }}

# Determine which database password to use
{{- define "gospel.databasePassword" -}}
{{- if .Values.externalDatabase.enabled -}}
{{- required "A valid external database password is required" .Values.externalDatabase.password -}}
{{- else -}}
{{- required "A valid MySQL password is required" .Values.mysql.auth.password -}}
{{- end -}}
{{- end }}

# Determine which database name to use
{{- define "gospel.databaseName" -}}
{{- if .Values.externalDatabase.enabled -}}
{{- required "A valid external database name is required" .Values.externalDatabase.database -}}
{{- else -}}
{{- required "A valid MySQL database is required" .Values.mysql.auth.database -}}
{{- end -}}
{{- end }}

# Generate the JDBC URL based on which database is enabled
{{- define "gospel.databaseJdbcUrl" -}}
{{- printf "%s%s:%s@%s/%s" ("mysql://") (include "gospel.databaseUsername" .) (include "gospel.databasePassword" .) (include "gospel.databaseHost" .) (include "gospel.databaseName" .) -}}
{{- end }}

# Wait for mysql initcontainer
{{- define "gospel.waitForMysql" -}}
{{- $mysqlDnsName := include "gospel.databaseHost" . -}}
- name: wait-for-mysql
  image: busybox
  imagePullPolicy: IfNotPresent
  command: ['sh', '-c', 'until nslookup {{ $mysqlDnsName }}; do echo waiting for service; sleep 5; done;']
{{- end }}

{{- define "gospel.redisHost" -}}
{{- printf "%s-%s.%s.svc.cluster.local" (include "gospel.name" .) ( .Values.redis.host) .Release.Namespace -}}
{{- end }}

# Wait for redis initcontainer
{{- define "gospel.waitForRedis" -}}
{{- $redisHostName := (include "gospel.redisHost" .) -}}
- name: wait-for-redis
  image: busybox
  imagePullPolicy: IfNotPresent
  command: ['sh', '-c', 'until nslookup {{ $redisHostName }}; do echo waiting for service; sleep 5; done;']
{{- end }}
