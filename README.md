# Messenger Monorepo Skeleton

This repository is a starter skeleton for a Telegram-like messenger.

## Layout

- `proto/`: gRPC protobuf contracts by domain.
- `services/`: microservice skeletons (gateway, auth, chat, message, media, notification, bot, moderation).
- `db/postgres/`: PostgreSQL DDL migrations.
- `db/cassandra/`: Cassandra/Scylla schema and table diagrams.
- `.github/workflows/ci-cd-pipeline.yaml`: CI/CD starter pipeline.

## Service boundaries

1. Gateway service for WebSocket session handling and stream fanout.
2. Auth service for user, device, and session lifecycle.
3. Chat service for chat metadata and memberships.
4. Message service for sending, storing, and status updates.
5. Media service for upload/download and processing workflow.
6. Notification service for APNs/FCM/WebPush dispatch.
7. Bot service for Bot API token and permissions lifecycle.
8. Moderation service for abuse reports and enforcement actions.
