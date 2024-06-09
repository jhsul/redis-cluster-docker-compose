#!/bin/sh

resolve_ip() {
  nslookup "$1" | grep 'Address' | tail -n1 | awk '{ split($2, a, "#"); print a[1] }'
}

echo "Waiting for Redis instances to be start..."
sleep 5

REDIS_IPS=""

REDIS_NODES=6
REDIS_REPLICAS=1

for i in $(seq 1 $REDIS_NODES); do
  while : ; do
    IP=$(resolve_ip "redis-cluster-docker-compose-redis-cluster-${i}")
    if [ -n "$IP" ]; then
      REDIS_IPS="$REDIS_IPS $IP:6379"
      break
    else
      echo "Waiting for redis cluster node ${i} to resolve..."
      sleep 2
    fi
  done
done

echo "Resolved Redis instance IPs:"
for i in $REDIS_IPS; do
  echo "- $i"
done

# Create the Redis cluster
redis-cli --cluster create $REDIS_IPS --cluster-yes --cluster-replicas $REDIS_REPLICAS
