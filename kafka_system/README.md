# Local Kafka System

The `kafka` service in the project-level [`docker-compose.yml`](../docker-compose.yml) runs a single-node Apache Kafka 4.1.2 cluster in KRaft combined mode for local development. ZooKeeper is not required.

## Start the local stack

From the project root:

```sh
docker compose up -d
```

Kafka exposes two listener addresses:

| Client location | Bootstrap server |
| --- | --- |
| Your host machine | `localhost:9092` |
| Another Compose service | `kafka:19092` |

The broker starts with three default topic partitions and disables automatic topic creation so that services explicitly define their topics.

## Create a topic

```sh
docker compose exec kafka /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server localhost:9092 \
  --create \
  --topic orders.created \
  --partitions 3 \
  --replication-factor 1
```

## Inspect topics

```sh
docker compose exec kafka /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server localhost:9092 \
  --list
```

This is a single-broker development configuration. A production Kafka cluster requires multiple brokers, replication, durable storage, and appropriate security controls.
