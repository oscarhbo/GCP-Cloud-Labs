#!/bin/bash

source ./../../utils/funciones.sh

ZONE="us-east1-d"
REGION="us-east1"
WEB_SERVER1="vm-webserver1"
WEB_SERVER2="vm-webserver2"
WEB_SERVER3="vm-webserver3"
REGLA_NET_LB="www-firewall-network-lb"
IP_LB="network-lb-ip-1"
HEALTH_CHECK="basic-check"
WS_TARGET_POOL="www-pool"
FW_RULE_WWW="www-rule"

print_msg "Eliminando máquina virtual  $WEB_SERVER1 ..."
gcloud compute instances delete "$WEB_SERVER1" --zone "$ZONE" --quiet

print_msg "Eliminando máquina virtual  $WEB_SERVER2 ..."
gcloud compute instances delete "$WEB_SERVER2" --zone "$ZONE" --quiet

print_msg "Eliminando máquina virtual  $WEB_SERVER3 ..."
gcloud compute instances delete "$WEB_SERVER3" --zone "$ZONE" --quiet

print_msg "Eliminando regla de firewall $REGLA_NET_LB ..."
gcloud compute firewall-rules delete "$REGLA_NET_LB" --quiet

print_msg "Eliminando IP estática $IP_LB ..."
gcloud compute addresses delete "$IP_LB" --region $REGION --quiet

print_msg "Eliminando forwarding-rule $FW_RULE_WWW ..."
gcloud compute forwarding-rules delete "$FW_RULE_WWW" --region $REGION --quiet

print_msg "Eliminando target-pool $WS_TARGET_POOL ..."
gcloud compute target-pools delete "$WS_TARGET_POOL" --region $REGION --quiet

print_msg "Eliminando health-check "$HEALTH_CHECK" ..."
gcloud compute http-health-checks delete "$HEALTH_CHECK" --quiet

print_msg "Máquina virtual, regla de firewall, load Balancer eliminados correctamente."
