SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE access_tokens (
    id integer NOT NULL,
    user_id integer,
    token_type integer DEFAULT 0,
    permit_type integer DEFAULT 0,
    title character varying(32),
    token character varying(128) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE access_tokens_id_seq OWNED BY access_tokens.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE articles (
    id character varying(128) NOT NULL,
    user_id integer,
    title character varying(128),
    newest_revision_id integer,
    view_count integer DEFAULT 0 NOT NULL,
    stock_count integer DEFAULT 0 NOT NULL,
    comment_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    published_at timestamp without time zone,
    publish_type integer DEFAULT 0,
    like_count integer DEFAULT 0
);


--
-- Name: attachment_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE attachment_files (
    id integer NOT NULL,
    user_id integer,
    file character varying(128),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attachment_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachment_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachment_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attachment_files_id_seq OWNED BY attachment_files.id;


--
-- Name: authentications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE authentications (
    id integer NOT NULL,
    user_id integer,
    provider character varying(32) NOT NULL,
    uid character varying(128) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: authentications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authentications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authentications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authentications_id_seq OWNED BY authentications.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comments (
    id integer NOT NULL,
    article_id character varying(128) NOT NULL,
    user_id integer,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    key character varying(128)
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE likes (
    id integer NOT NULL,
    target_type character varying NOT NULL,
    target_id character varying NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE likes_id_seq OWNED BY likes.id;


--
-- Name: link_article_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE link_article_tags (
    id integer NOT NULL,
    article_id character varying(128),
    tag_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: link_article_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE link_article_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: link_article_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE link_article_tags_id_seq OWNED BY link_article_tags.id;


--
-- Name: revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE revisions (
    id integer NOT NULL,
    article_id character varying(128),
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying DEFAULT ''::character varying,
    tags_text text DEFAULT ''::text,
    user_id integer,
    published_at timestamp without time zone,
    revision_type integer DEFAULT 0,
    note text
);


--
-- Name: revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE revisions_id_seq OWNED BY revisions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: stocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stocks (
    id integer NOT NULL,
    article_id character varying(128) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stocks_id_seq OWNED BY stocks.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    content character varying(64) NOT NULL,
    article_count integer DEFAULT 0 NOT NULL,
    is_menu boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    key character varying(128)
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    email character varying,
    stock_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    like_count integer DEFAULT 0
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_tokens ALTER COLUMN id SET DEFAULT nextval('access_tokens_id_seq'::regclass);


--
-- Name: attachment_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachment_files ALTER COLUMN id SET DEFAULT nextval('attachment_files_id_seq'::regclass);


--
-- Name: authentications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY authentications ALTER COLUMN id SET DEFAULT nextval('authentications_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: likes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes ALTER COLUMN id SET DEFAULT nextval('likes_id_seq'::regclass);


--
-- Name: link_article_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY link_article_tags ALTER COLUMN id SET DEFAULT nextval('link_article_tags_id_seq'::regclass);


--
-- Name: revisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY revisions ALTER COLUMN id SET DEFAULT nextval('revisions_id_seq'::regclass);


--
-- Name: stocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stocks ALTER COLUMN id SET DEFAULT nextval('stocks_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: access_tokens access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT access_tokens_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: attachment_files attachment_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachment_files
    ADD CONSTRAINT attachment_files_pkey PRIMARY KEY (id);


--
-- Name: authentications authentications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authentications
    ADD CONSTRAINT authentications_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: link_article_tags link_article_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY link_article_tags
    ADD CONSTRAINT link_article_tags_pkey PRIMARY KEY (id);


--
-- Name: revisions revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY revisions
    ADD CONSTRAINT revisions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: stocks stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stocks
    ADD CONSTRAINT stocks_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_access_tokens_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_tokens_on_user_id ON access_tokens USING btree (user_id);


--
-- Name: index_articles_on_comment_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_comment_count ON articles USING btree (comment_count);


--
-- Name: index_articles_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_created_at ON articles USING btree (created_at);


--
-- Name: index_articles_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_articles_on_id ON articles USING btree (id);


--
-- Name: index_articles_on_like_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_like_count ON articles USING btree (like_count);


--
-- Name: index_articles_on_publish_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_publish_type ON articles USING btree (publish_type);


--
-- Name: index_articles_on_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_published_at ON articles USING btree (published_at);


--
-- Name: index_articles_on_stock_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_stock_count ON articles USING btree (stock_count);


--
-- Name: index_articles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_user_id ON articles USING btree (user_id);


--
-- Name: index_articles_on_view_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_view_count ON articles USING btree (view_count);


--
-- Name: index_attachment_files_on_file; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_attachment_files_on_file ON attachment_files USING btree (file);


--
-- Name: index_attachment_files_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachment_files_on_user_id ON attachment_files USING btree (user_id);


--
-- Name: index_authentications_on_provider_and_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_authentications_on_provider_and_uid ON authentications USING btree (provider, uid);


--
-- Name: index_authentications_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authentications_on_user_id ON authentications USING btree (user_id);


--
-- Name: index_comments_on_article_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_article_id ON comments USING btree (article_id);


--
-- Name: index_comments_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_created_at ON comments USING btree (created_at);


--
-- Name: index_comments_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_comments_on_key ON comments USING btree (key);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_likes_on_target_type_and_target_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_likes_on_target_type_and_target_id_and_user_id ON likes USING btree (target_type, target_id, user_id);


--
-- Name: index_link_article_tags_on_article_id_and_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_link_article_tags_on_article_id_and_tag_id ON link_article_tags USING btree (article_id, tag_id);


--
-- Name: index_revisions_on_article_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revisions_on_article_id ON revisions USING btree (article_id);


--
-- Name: index_revisions_on_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revisions_on_published_at ON revisions USING btree (published_at);


--
-- Name: index_revisions_on_revision_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revisions_on_revision_type ON revisions USING btree (revision_type);


--
-- Name: index_revisions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revisions_on_user_id ON revisions USING btree (user_id);


--
-- Name: index_stocks_on_article_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_stocks_on_article_id_and_user_id ON stocks USING btree (article_id, user_id);


--
-- Name: index_stocks_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stocks_on_created_at ON stocks USING btree (created_at);


--
-- Name: index_tags_on_article_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_article_count ON tags USING btree (article_count);


--
-- Name: index_tags_on_content; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_content ON tags USING btree (content);


--
-- Name: index_tags_on_is_menu; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_is_menu ON tags USING btree (is_menu);


--
-- Name: index_tags_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_key ON tags USING btree (key);


--
-- Name: index_users_on_like_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_like_count ON users USING btree (like_count);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_name ON users USING btree (name);


--
-- Name: index_users_on_stock_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_stock_count ON users USING btree (stock_count);


--
-- Name: comments fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: authentications fk_rails_08833fecbe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authentications
    ADD CONSTRAINT fk_rails_08833fecbe FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: attachment_files fk_rails_0cd130c061; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachment_files
    ADD CONSTRAINT fk_rails_0cd130c061 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: articles fk_rails_3d31dad1cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT fk_rails_3d31dad1cc FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: access_tokens fk_rails_96fc070778; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT fk_rails_96fc070778 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

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
('20170702044607'),
('20170702114546');


