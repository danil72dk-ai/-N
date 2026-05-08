# Cassandra Table Diagrams

## 1) messages_by_chat_bucket

```text
Partition Key: (chat_id, bucket_ymd)
Clustering: msg_ts DESC, server_msg_id DESC

+--------------------------------------------------------------+
| messages_by_chat_bucket                                      |
+--------------------------------------------------------------+
| PK  chat_id : bigint                                         |
| PK  bucket_ymd : int     (e.g. 20260508)                    |
| CK  msg_ts : timestamp                                       |
| CK  server_msg_id : text                                     |
|     sender_user_id : bigint                                  |
|     client_msg_id : text                                     |
|     text : text                                              |
|     attachments_json : text                                  |
|     status : tinyint                                         |
+--------------------------------------------------------------+
Read path: recent messages in chat within current + prior buckets.
Write path: append-only.
```

## 2) message_index_by_client_msg

```text
Partition Key: (chat_id)
Clustering: client_msg_id

+--------------------------------------------------------------+
| message_index_by_client_msg                                  |
+--------------------------------------------------------------+
| PK  chat_id : bigint                                         |
| CK  client_msg_id : text                                     |
|     server_msg_id : text                                     |
|     created_at : timestamp                                   |
+--------------------------------------------------------------+
Purpose: dedup/idempotency for client retries.
```

## 3) unread_counter_by_user_chat

```text
Partition Key: (user_id)
Clustering: chat_id

+--------------------------------------------------------------+
| unread_counter_by_user_chat                                  |
+--------------------------------------------------------------+
| PK  user_id : bigint                                         |
| CK  chat_id : bigint                                         |
|     unread_count : counter                                   |
+--------------------------------------------------------------+
Purpose: fast unread counters for chat list.
```

## 4) last_message_by_chat

```text
Primary Key: chat_id

+--------------------------------------------------------------+
| last_message_by_chat                                         |
+--------------------------------------------------------------+
| PK  chat_id : bigint                                         |
|     bucket_ymd : int                                         |
|     server_msg_id : text                                     |
|     msg_ts : timestamp                                       |
|     preview_text : text                                      |
|     sender_user_id : bigint                                  |
+--------------------------------------------------------------+
Purpose: chat list preview + ordering hints.
```
