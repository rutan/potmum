CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(32) NOT NULL, "email" varchar, "stock_count" integer DEFAULT 0 NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "like_count" integer DEFAULT 0);
CREATE UNIQUE INDEX "index_users_on_name" ON "users" ("name");
CREATE INDEX "index_users_on_stock_count" ON "users" ("stock_count");
CREATE TABLE "authentications" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "provider" varchar(32) NOT NULL, "uid" varchar(128) NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_08833fecbe"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_authentications_on_user_id" ON "authentications" ("user_id");
CREATE UNIQUE INDEX "index_authentications_on_provider_and_uid" ON "authentications" ("provider", "uid");
CREATE TABLE "articles" ("id" VARCHAR(128) PRIMARY KEY NOT NULL, "user_id" integer, "title" varchar(128), "newest_revision_id" integer, "view_count" integer DEFAULT 0 NOT NULL, "stock_count" integer DEFAULT 0 NOT NULL, "comment_count" integer DEFAULT 0 NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "published_at" datetime, "publish_type" integer DEFAULT 0, "like_count" integer DEFAULT 0, CONSTRAINT "fk_rails_3d31dad1cc"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_articles_on_user_id" ON "articles" ("user_id");
CREATE UNIQUE INDEX "index_articles_on_id" ON "articles" ("id");
CREATE INDEX "index_articles_on_view_count" ON "articles" ("view_count");
CREATE INDEX "index_articles_on_stock_count" ON "articles" ("stock_count");
CREATE INDEX "index_articles_on_comment_count" ON "articles" ("comment_count");
CREATE INDEX "index_articles_on_created_at" ON "articles" ("created_at");
CREATE INDEX "index_articles_on_published_at" ON "articles" ("published_at");
CREATE TABLE "revisions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "article_id" varchar(128), "body" text, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "title" varchar DEFAULT '', "tags_text" text DEFAULT '', "user_id" integer, "published_at" datetime DEFAULT NULL, "revision_type" integer DEFAULT 0, "note" text);
CREATE INDEX "index_revisions_on_article_id" ON "revisions" ("article_id");
CREATE TABLE "tags" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(64) NOT NULL, "content" varchar(64) NOT NULL, "article_count" integer DEFAULT 0 NOT NULL, "is_menu" boolean DEFAULT 'f', "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "key" varchar(128));
CREATE UNIQUE INDEX "index_tags_on_content" ON "tags" ("content");
CREATE INDEX "index_tags_on_article_count" ON "tags" ("article_count");
CREATE INDEX "index_tags_on_is_menu" ON "tags" ("is_menu");
CREATE TABLE "link_article_tags" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "article_id" varchar(128), "tag_id" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE UNIQUE INDEX "index_link_article_tags_on_article_id_and_tag_id" ON "link_article_tags" ("article_id", "tag_id");
CREATE TABLE "stocks" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "article_id" varchar(128) NOT NULL, "user_id" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE UNIQUE INDEX "index_stocks_on_article_id_and_user_id" ON "stocks" ("article_id", "user_id");
CREATE INDEX "index_stocks_on_created_at" ON "stocks" ("created_at");
CREATE TABLE "comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "article_id" varchar(128) NOT NULL, "user_id" integer, "body" text, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_03de2dc08c"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_comments_on_user_id" ON "comments" ("user_id");
CREATE INDEX "index_comments_on_article_id" ON "comments" ("article_id");
CREATE INDEX "index_comments_on_created_at" ON "comments" ("created_at");
CREATE INDEX "index_articles_on_publish_type" ON "articles" ("publish_type");
CREATE TABLE "attachment_files" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "file" varchar(128), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_0cd130c061"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_attachment_files_on_user_id" ON "attachment_files" ("user_id");
CREATE UNIQUE INDEX "index_attachment_files_on_file" ON "attachment_files" ("file");
CREATE INDEX "index_revisions_on_user_id" ON "revisions" ("user_id");
CREATE INDEX "index_revisions_on_published_at" ON "revisions" ("published_at");
CREATE INDEX "index_revisions_on_revision_type" ON "revisions" ("revision_type");
CREATE TABLE "access_tokens" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "token_type" integer DEFAULT 0, "permit_type" integer DEFAULT 0, "title" varchar(32), "token" varchar(128) NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_96fc070778"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_access_tokens_on_user_id" ON "access_tokens" ("user_id");
CREATE TABLE "likes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "target_type" varchar NOT NULL, "target_id" varchar NOT NULL, "user_id" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE UNIQUE INDEX "index_likes_on_target_type_and_target_id_and_user_id" ON "likes" ("target_type", "target_id", "user_id");
CREATE INDEX "index_articles_on_like_count" ON "articles" ("like_count");
CREATE INDEX "index_users_on_like_count" ON "users" ("like_count");
CREATE UNIQUE INDEX "index_tags_on_key" ON "tags" ("key");
INSERT INTO "schema_migrations" (version) VALUES
('20150722154057'),
('20150722154204'),
('20150722154419'),
('20150722154441'),
('20150722154504'),
('20150722154548'),
('20150722154606'),
('20150722154631'),
('20150811163448'),
('20150812165100'),
('20160426162535'),
('20160610180448'),
('20161116164401'),
('20170702044607');


