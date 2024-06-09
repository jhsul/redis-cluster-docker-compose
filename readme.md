This repo contains a minimal setup for a Redis cluster using Docker Compose. For a kubernetes setup, I recommend using [this repo](https://github.com/sobotklp/kubernetes-redis-cluster) as a guide.

### Setup

```sh
git clone https://github.com/jhsul/redis-cluster-docker-compose
cd redis-cluster-docker-compose

# Start the cluster
docker compose up -d

# (First time only) Configure the cluster
docker compose up redis-cluster-init
```

The redis nodes will remember their cluster configuration in their container filesystem even if they are restarted. If you want to start from scratch, you can remove all the containers:

```sh
docker compose stop redis-cluster
docker compose rm redis-cluster
```

### Usage

You can access the cluster using `redis-cli` directly from any of the cluster nodes.

```sh
docker exec redis-cluster-docker-compose-redis-cluster-1 redis-cli -c cluster nodes

# Output
692224203532603c8b1103dbf3ddd383b35deab1 172.18.0.6:6379@16379 master - 0 1717947605000 3 connected 10923-16383
09eb6444adf35fcb5cf185fc8a08231cd4119536 172.18.0.7:6379@16379 master - 0 1717947604000 2 connected 5461-10922
6ebd0415a63175e6e17686817dd23c49aa118e1d 172.18.0.3:6379@16379 slave d9166150899c1b584ffbcf51779751108e67c673 0 1717947605301 1 connected
624070233e88a0ce946bc76873f92c28955143e1 172.18.0.4:6379@16379 slave 09eb6444adf35fcb5cf185fc8a08231cd4119536 0 1717947604282 2 connected
d9166150899c1b584ffbcf51779751108e67c673 172.18.0.2:6379@16379 myself,master - 0 1717947602000 1 connected 0-5460
f8c8acec9a0aec8c3da2079adbb0bdc28fa85432 172.18.0.5:6379@16379 slave 692224203532603c8b1103dbf3ddd383b35deab1 0 1717947604000 3 connected
```

This repo also contains an example python app that connects to the cluster.

```sh
docker compose up example-app

# Output
example-app-1  | {
example-app-1  |   "172.18.0.6:6379": {
example-app-1  |     "node_id": "692224203532603c8b1103dbf3ddd383b35deab1",
example-app-1  |     "flags": "master",
example-app-1  |     "master_id": "-",
example-app-1  |     "last_ping_sent": "0",
example-app-1  |     "last_pong_rcvd": "1717947906000",
example-app-1  |     "epoch": "3",
example-app-1  |     "slots": [
example-app-1  |       [
example-app-1  |         "10923",
example-app-1  |         "16383"
example-app-1  |       ]
example-app-1  |     ],
example-app-1  |     "migrations": [],
example-app-1  |     "connected": true
example-app-1  |   },
...
```

### TODO

This implementation is super limited. Here are some features that would be nice to have:

- [ ] Ability to reconfigure the cluster topology without taking the whole thing down
- [ ] Persistent storage using the host filesystem
- [ ] Shared configuration for number of nodes and replicas
