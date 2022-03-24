{{/*
# Default command
*/}}
{{- define "besu.defaultCommand" -}}
- sh
- -ac
- >
{{- if and .Values.p2pNodePort.enabled .Values.p2pNodePort.initContainer.enabled }}
  . /env/init-nodeport;
{{- end }}
  exec besu
  --data-path=/data
  --nat-method={{ .Values.natMethod }}
{{- if and .Values.p2pNodePort.enabled (eq .Values.natMethod "NONE")}}
  --p2p-host=$EXTERNAL_IP
  --p2p-port=$EXTERNAL_PORT
{{- else if (eq .Values.natMethod "NONE") }}
  --p2p-host=$(POD_IP)
  --p2p-port={{ include "besu.p2pPort" . }}
{{- end }}
  --rpc-http-enabled
  --rpc-http-host=0.0.0.0
  --rpc-http-port={{ include "besu.httpPort" . }}
  --rpc-http-cors-origins=*
  --rpc-ws-enabled
  --rpc-ws-host=0.0.0.0
  --rpc-ws-port={{ include "besu.wsPort" . }}
  --host-allowlist=*
  --metrics-enabled
  --metrics-host=0.0.0.0
  --metrics-port={{ include "besu.metricsPort" . }}
{{- range .Values.extraArgs }}
  {{ (tpl . $) }}
{{- end }}
{{- end }}
