-- PostgreSQL DDL v1 for messenger metadata and transactional entities.

create table if not exists users (
  user_id bigserial primary key,
  phone_e164 varchar(20) unique,
  username varchar(32) unique,
  password_hash text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists devices (
  device_id bigserial primary key,
  user_id bigint not null references users(user_id) on delete cascade,
  platform varchar(16) not null,
  device_fingerprint text not null,
  push_token text,
  created_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now()
);

create table if not exists sessions (
  session_id uuid primary key,
  user_id bigint not null references users(user_id) on delete cascade,
  device_id bigint not null references devices(device_id) on delete cascade,
  refresh_token_hash text not null,
  expires_at timestamptz not null,
  created_at timestamptz not null default now()
);

create table if not exists chats (
  chat_id bigserial primary key,
  chat_type smallint not null,
  title varchar(255),
  owner_user_id bigint references users(user_id),
  created_at timestamptz not null default now()
);

create table if not exists chat_members (
  chat_id bigint not null references chats(chat_id) on delete cascade,
  user_id bigint not null references users(user_id) on delete cascade,
  role varchar(24) not null default 'member',
  joined_at timestamptz not null default now(),
  last_read_msg_id varchar(27),
  primary key (chat_id, user_id)
);

create table if not exists attachments (
  attachment_id uuid primary key,
  owner_user_id bigint not null references users(user_id),
  object_key text not null unique,
  content_type varchar(127) not null,
  size_bytes bigint not null,
  sha256 char(64),
  created_at timestamptz not null default now()
);

create table if not exists delivery_receipts (
  chat_id bigint not null,
  server_msg_id varchar(27) not null,
  user_id bigint not null references users(user_id),
  device_id bigint references devices(device_id),
  delivered_at timestamptz not null default now(),
  primary key (chat_id, server_msg_id, user_id, device_id)
);

create table if not exists read_receipts (
  chat_id bigint not null,
  server_msg_id varchar(27) not null,
  user_id bigint not null references users(user_id),
  read_at timestamptz not null default now(),
  primary key (chat_id, server_msg_id, user_id)
);

create table if not exists bots (
  bot_id bigserial primary key,
  owner_user_id bigint not null references users(user_id),
  display_name varchar(64) not null,
  created_at timestamptz not null default now()
);

create table if not exists bot_tokens (
  token_id uuid primary key,
  bot_id bigint not null references bots(bot_id) on delete cascade,
  token_hash text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  revoked_at timestamptz
);

create table if not exists moderation_actions (
  action_id uuid primary key,
  case_id uuid not null,
  target_user_id bigint references users(user_id),
  action_type varchar(32) not null,
  reason text,
  created_by bigint references users(user_id),
  created_at timestamptz not null default now()
);

create index if not exists idx_chat_members_user_id on chat_members(user_id);
create index if not exists idx_sessions_user_device on sessions(user_id, device_id);
create index if not exists idx_attachments_owner_created on attachments(owner_user_id, created_at desc);
create index if not exists idx_delivery_receipts_user on delivery_receipts(user_id, delivered_at desc);
create index if not exists idx_read_receipts_user on read_receipts(user_id, read_at desc);
