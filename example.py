from redis.cluster import RedisCluster
import json

# Any of the redis cluster nodes can be used for the initial connection
redis_cluster_host = "redis-cluster-docker-compose-redis-cluster-1"

client = RedisCluster(redis_cluster_host)
info = client.cluster_nodes()

print(json.dumps(info, indent=2))
