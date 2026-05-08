-- Cassandra/Scylla schema for high-volume message timelines.

create keyspace if not exists messenger
with replication = {'class': 'NetworkTopologyStrategy', 'dc1': 3};

use messenger;

create table if not exists messages_by_chat_bucket (
  chat_id bigint,
  bucket_ymd int,
  msg_ts timestamp,
  server_msg_id text,
  sender_user_id bigint,
  client_msg_id text,
  text text,
  attachments_json text,
  status tinyint,
  primary key ((chat_id, bucket_ymd), msg_ts, server_msg_id)
) with clustering order by (msg_ts desc, server_msg_id desc);

create table if not exists message_index_by_client_msg (
  chat_id bigint,
  client_msg_id text,
  server_msg_id text,
  created_at timestamp,
  primary key ((chat_id), client_msg_id)
);

create table if not exists unread_counter_by_user_chat (
  user_id bigint,
  chat_id bigint,
  unread_count counter,
  primary key ((user_id), chat_id)
);

create table if not exists last_message_by_chat (
  chat_id bigint primary key,
  bucket_ymd int,
  server_msg_id text,
  msg_ts timestamp,
  preview_text text,
  sender_user_id bigint
);
