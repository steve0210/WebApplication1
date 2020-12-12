CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

START TRANSACTION;

CREATE TABLE asp_net_roles (
    id text NOT NULL,
    name character varying(256) NULL,
    normalized_name character varying(256) NULL,
    concurrency_stamp text NULL,
    CONSTRAINT "PK_asp_net_roles" PRIMARY KEY (id)
);

CREATE TABLE asp_net_users (
    id text NOT NULL,
    user_name character varying(256) NULL,
    normalized_user_name character varying(256) NULL,
    email character varying(256) NULL,
    normalized_email character varying(256) NULL,
    email_confirmed boolean NOT NULL,
    password_hash text NULL,
    security_stamp text NULL,
    concurrency_stamp text NULL,
    phone_number text NULL,
    phone_number_confirmed boolean NOT NULL,
    two_factor_enabled boolean NOT NULL,
    lockout_end timestamp with time zone NULL,
    lockout_enabled boolean NOT NULL,
    access_failed_count integer NOT NULL,
    CONSTRAINT "PK_asp_net_users" PRIMARY KEY (id)
);

CREATE TABLE blogs (
    blog_id serial not null,
    name text NULL,
    url text NULL,
    CONSTRAINT "PK_blogs" PRIMARY KEY (blog_id)
);

CREATE TABLE asp_net_role_claims (
    id serial not null,
    role_id text NOT NULL,
    claim_type text NULL,
    claim_value text NULL,
    CONSTRAINT "PK_asp_net_role_claims" PRIMARY KEY (id),
    CONSTRAINT "FK_asp_net_role_claims_asp_net_roles_role_id" FOREIGN KEY (role_id) REFERENCES asp_net_roles (id) ON DELETE CASCADE
);

CREATE TABLE asp_net_user_claims (
    id serial not null,
    user_id text NOT NULL,
    claim_type text NULL,
    claim_value text NULL,
    CONSTRAINT "PK_asp_net_user_claims" PRIMARY KEY (id),
    CONSTRAINT "FK_asp_net_user_claims_asp_net_users_user_id" FOREIGN KEY (user_id) REFERENCES asp_net_users (id) ON DELETE CASCADE
);

CREATE TABLE asp_net_user_logins (
    login_provider text NOT NULL,
    provider_key text NOT NULL,
    provider_display_name text NULL,
    user_id text NOT NULL,
    CONSTRAINT "PK_asp_net_user_logins" PRIMARY KEY (login_provider, provider_key),
    CONSTRAINT "FK_asp_net_user_logins_asp_net_users_user_id" FOREIGN KEY (user_id) REFERENCES asp_net_users (id) ON DELETE CASCADE
);

CREATE TABLE asp_net_user_roles (
    user_id text NOT NULL,
    role_id text NOT NULL,
    CONSTRAINT "PK_asp_net_user_roles" PRIMARY KEY (user_id, role_id),
    CONSTRAINT "FK_asp_net_user_roles_asp_net_roles_role_id" FOREIGN KEY (role_id) REFERENCES asp_net_roles (id) ON DELETE CASCADE,
    CONSTRAINT "FK_asp_net_user_roles_asp_net_users_user_id" FOREIGN KEY (user_id) REFERENCES asp_net_users (id) ON DELETE CASCADE
);

CREATE TABLE asp_net_user_tokens (
    user_id text NOT NULL,
    login_provider text NOT NULL,
    name text NOT NULL,
    value text NULL,
    CONSTRAINT "PK_asp_net_user_tokens" PRIMARY KEY (user_id, login_provider, name),
    CONSTRAINT "FK_asp_net_user_tokens_asp_net_users_user_id" FOREIGN KEY (user_id) REFERENCES asp_net_users (id) ON DELETE CASCADE
);

CREATE TABLE posts (
    post_id serial not null,
    title text NULL,
    content text NULL,
    blog_id integer NOT NULL,
    CONSTRAINT "PK_posts" PRIMARY KEY (post_id),
    CONSTRAINT "FK_posts_blogs_blog_id" FOREIGN KEY (blog_id) REFERENCES blogs (blog_id) ON DELETE CASCADE
);

CREATE INDEX "IX_asp_net_role_claims_role_id" ON asp_net_role_claims (role_id);

CREATE UNIQUE INDEX "RoleNameIndex" ON asp_net_roles (normalized_name);

CREATE INDEX "IX_asp_net_user_claims_user_id" ON asp_net_user_claims (user_id);

CREATE INDEX "IX_asp_net_user_logins_user_id" ON asp_net_user_logins (user_id);

CREATE INDEX "IX_asp_net_user_roles_role_id" ON asp_net_user_roles (role_id);

CREATE INDEX "EmailIndex" ON asp_net_users (normalized_email);

CREATE UNIQUE INDEX "UserNameIndex" ON asp_net_users (normalized_user_name);

CREATE INDEX "IX_posts_blog_id" ON posts (blog_id);

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20201122012451_AddInitial', '5.0.0');

COMMIT;

