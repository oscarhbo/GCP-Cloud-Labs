#!/bin/bash

source ./../../utils/funciones.sh

INSTANCE_TEMPLATE="lb-backend-template"
NET_TAG="allow-health-check"
REGLA_FIREWALL_LB="fw-allow-health-check"
IP_LB="lb-ipv4-1"
HEALTH_CHECK="http-basic-check"
BACKEND_NAME="web-backend-service"
URL_MAP="web-map-http"
TARGET_PROXY="http-lb-proxy"
FW_RULE_HTTP="http-content-rule"
INSTANCE_GROUP="lb-backend-group"
DEF_REGION="us-east1"
DEF_ZONE="us-east1-d"


print_msg "Eliminando forwarding-rule $FW_RULE_HTTP ..."
gcloud compute forwarding-rules delete "$FW_RULE_HTTP" --quiet

print_msg "Eliminando target proxy  $TARGET_PROXY ..."
gcloud compute target-http-proxies delete "$TARGET_PROXY"  --quiet

print_msg "Eliminando mapa de URL  $URL_MAP ..."
gcloud compute url-maps delete "$URL_MAP" --zone "$ZONE" --quiet

print_msg "Eliminando servicio de backend  $BACKEND_NAME ..."
gcloud compute backend-services delete "$BACKEND_NAME" --quiet

print_msg "Eliminando health-check "$HEALTH_CHECK" ..."
gcloud compute health-checks delete "$HEALTH_CHECK" --quiet

print_msg "Eliminando IP estática $IP_LB ..."
gcloud compute addresses delete "$IP_LB" --quiet

print_msg "Eliminando regla de firewall $REGLA_FIREWALL_LB ..."
gcloud compute firewall-rules delete "$REGLA_FIREWALL_LB" --quiet

print_msg "Eliminando target-pool $INSTANCE_GROUP ..."
gcloud compute instance-groups delete "$INSTANCE_GROUP" --zone $DEF_ZONE --quiet

print_msg "Eliminando instance-template $INSTANCE_TEMPLATE ..."
gcloud compute instance-templates delete "$INSTANCE_TEMPLATE" --region $DEF_REGION --quiet


print_msg "Todos los recursos para el load Balancer fueron eliminados correctamente."
