CREATE TABLE "Users" (
  "id" bigserial PRIMARY KEY,
  "email" varchar NOT NULL,
  "password" varchar NOT NULL,
  "role" varchar NOT NULL,
  "avatar" varchar,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "updated_at" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "Videos" (
  "id" bigserial PRIMARY KEY,
  "uploader" bigint NOT NULL,
  "title" varchar NOT NULL,
  "description" varchar,
  "genre_id" bigint,
  "status" varchar NOT NULL DEFAULT (PENDING),
  "original_url" varchar,
  "hls_url" varchar,
  "thumbnail_url" varchar,
  "duration" bigint,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "updated_at" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "Genres" (
  "id" bigserial PRIMARY KEY,
  "name" varchar NOT NULL,
  "description" varchar
);

CREATE TABLE "Tags" (
  "id" bigserial PRIMARY KEY,
  "name" varchar NOT NULL
);

CREATE TABLE "video_tags" (
  "PRIMARY" "KEY(video_id,tag_id)",
  "video_id" int NOT NULL,
  "tag_id" int NOT NULL,
  PRIMARY KEY ("video_id", "tag_id")
);

CREATE TABLE "Comments" (
  "id" bigserial PRIMARY KEY,
  "video_id" bigint NOT NULL,
  "user_id" bigint NOT NULL,
  "parent_id" bigint,
  "content" varchar,
  "like_count" int,
  "dislike_count" int,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "updated_at" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "Watchlists" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "video_id" bigint NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "updated_at" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "Ratings" (
  "id" bigserial PRIMARY KEY,
  "video_id" bigint NOT NULL,
  "user_id" bigint NOT NULL,
  "rating" int,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "updated_at" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "Histories" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "video_id" bigint NOT NULL,
  "watched_at" timestamp,
  "progress" int
);

CREATE TABLE "Jobs" (
  "id" bigserial PRIMARY KEY,
  "video_id" bigint NOT NULL,
  "status" varchar,
  "log" varchar,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "updated_at" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "Reactions" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "target_type" varchar,
  "target_id" bigint,
  "type" varchar,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "updated_at" timestamp NOT NULL DEFAULT (now())
);

CREATE UNIQUE INDEX ON "Users" ("email");

CREATE INDEX ON "Comments" ("video_id");

CREATE INDEX ON "Comments" ("parent_id");

CREATE UNIQUE INDEX ON "Watchlists" ("user_id", "video_id");

CREATE UNIQUE INDEX ON "Ratings" ("video_id", "user_id");

CREATE INDEX ON "Ratings" ("video_id");

CREATE INDEX ON "Histories" ("user_id");

CREATE INDEX ON "Jobs" ("status");

CREATE INDEX ON "Jobs" ("video_id");

CREATE UNIQUE INDEX ON "Reactions" ("user_id", "target_type", "target_id");

CREATE INDEX ON "Reactions" ("target_type", "target_id");

COMMENT ON COLUMN "Ratings"."rating" IS 'CHECK (rating BETWEEN 1 AND 5)';

COMMENT ON COLUMN "Reactions"."target_type" IS 'ENUM(video, comment)';

COMMENT ON COLUMN "Reactions"."type" IS 'ENUM(like, dislike)';

ALTER TABLE "Videos" ADD FOREIGN KEY ("uploader") REFERENCES "Users" ("id");

ALTER TABLE "Videos" ADD FOREIGN KEY ("genre_id") REFERENCES "Genres" ("id");

ALTER TABLE "video_tags" ADD FOREIGN KEY ("video_id") REFERENCES "Videos" ("id");

ALTER TABLE "video_tags" ADD FOREIGN KEY ("tag_id") REFERENCES "Tags" ("id");

ALTER TABLE "Comments" ADD FOREIGN KEY ("video_id") REFERENCES "Videos" ("id");

ALTER TABLE "Comments" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "Watchlists" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "Watchlists" ADD FOREIGN KEY ("video_id") REFERENCES "Videos" ("id");

ALTER TABLE "Ratings" ADD FOREIGN KEY ("video_id") REFERENCES "Videos" ("id");

ALTER TABLE "Ratings" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "Histories" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "Histories" ADD FOREIGN KEY ("video_id") REFERENCES "Videos" ("id");

ALTER TABLE "Jobs" ADD FOREIGN KEY ("video_id") REFERENCES "Videos" ("id");

ALTER TABLE "Reactions" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");
