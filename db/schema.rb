# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151012182837) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "accounts", force: true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "username"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.datetime "oauth_expires"
    t.string   "provider"
    t.string   "oauth_refresh_token"
  end

  add_index "accounts", ["oauth_expires"], name: "index_accounts_on_oauth_expires", using: :btree
  add_index "accounts", ["uid", "provider"], name: "index_accounts_on_uid_and_provider", unique: true, using: :btree
  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree
  add_index "accounts", ["username", "provider"], name: "index_accounts_on_username_and_provider", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree

  create_table "ccla_signatures", force: true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "ccla_id"
    t.datetime "signed_at"
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "email"
    t.string   "phone"
    t.string   "company"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ccla_signatures", ["ccla_id"], name: "index_ccla_signatures_on_ccla_id", using: :btree
  add_index "ccla_signatures", ["organization_id"], name: "index_ccla_signatures_on_organization_id", using: :btree
  add_index "ccla_signatures", ["user_id"], name: "index_ccla_signatures_on_user_id", using: :btree

  create_table "cclas", force: true do |t|
    t.string   "version"
    t.text     "head"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cla_reports", force: true do |t|
    t.integer  "first_ccla_id"
    t.integer  "last_ccla_id"
    t.integer  "first_icla_id"
    t.integer  "last_icla_id"
    t.string   "csv_file_name"
    t.string   "csv_content_type"
    t.integer  "csv_file_size"
    t.datetime "csv_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collaborators", force: true do |t|
    t.integer  "resourceable_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resourceable_type"
  end

  add_index "collaborators", ["user_id", "resourceable_type", "resourceable_id"], name: "index_cookbook_collaborators_on_user_id_and_resourceable", unique: true, using: :btree

  create_table "commit_shas", force: true do |t|
    t.string   "sha",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commit_shas", ["sha"], name: "index_commit_shas_on_sha", unique: true, using: :btree

  create_table "contributor_request_responses", force: true do |t|
    t.integer  "contributor_request_id", null: false
    t.string   "decision",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contributor_request_responses", ["contributor_request_id"], name: "index_contributor_request_responses_on_contributor_request_id", unique: true, using: :btree

  create_table "contributor_requests", force: true do |t|
    t.integer  "organization_id",   null: false
    t.integer  "user_id",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ccla_signature_id", null: false
  end

  add_index "contributor_requests", ["organization_id", "user_id"], name: "index_contributor_requests_on_organization_id_and_user_id", unique: true, using: :btree

  create_table "contributors", force: true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contributors", ["organization_id"], name: "index_contributors_on_organization_id", using: :btree
  add_index "contributors", ["user_id", "organization_id"], name: "index_contributors_on_user_id_and_organization_id", unique: true, using: :btree
  add_index "contributors", ["user_id"], name: "index_contributors_on_user_id", using: :btree

  create_table "curry_commit_authors", force: true do |t|
    t.string   "login"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "authorized_to_contribute", default: false, null: false
  end

  add_index "curry_commit_authors", ["email"], name: "index_curry_commit_authors_on_email", unique: true, using: :btree
  add_index "curry_commit_authors", ["login"], name: "index_curry_commit_authors_on_login", unique: true, using: :btree

  create_table "curry_pull_request_comments", force: true do |t|
    t.integer  "github_id",                                null: false
    t.integer  "pull_request_id",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unauthorized_commit_authors", default: [],              array: true
  end

  add_index "curry_pull_request_comments", ["github_id"], name: "index_curry_pull_request_comments_on_github_id", unique: true, using: :btree
  add_index "curry_pull_request_comments", ["pull_request_id"], name: "index_curry_pull_request_comments_on_pull_request_id", using: :btree

  create_table "curry_pull_request_commit_authors", force: true do |t|
    t.integer "pull_request_id",  null: false
    t.integer "commit_author_id", null: false
  end

  add_index "curry_pull_request_commit_authors", ["commit_author_id", "pull_request_id"], name: "curry_pr_commit_author_ids", unique: true, using: :btree

  create_table "curry_pull_request_updates", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "action"
    t.integer  "pull_request_id", null: false
  end

  create_table "curry_pull_requests", force: true do |t|
    t.string   "number",        null: false
    t.integer  "repository_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "curry_pull_requests", ["number", "repository_id"], name: "index_curry_pull_requests_on_number_and_repository_id", unique: true, using: :btree

  create_table "curry_repositories", force: true do |t|
    t.string   "owner",        null: false
    t.string   "name",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "callback_url", null: false
  end

  create_table "daily_metrics", force: true do |t|
    t.string   "key",                    null: false
    t.integer  "count",      default: 0, null: false
    t.date     "day",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "daily_metrics", ["key", "day"], name: "index_daily_metrics_on_key_and_day", using: :btree

  create_table "email_preferences", force: true do |t|
    t.integer  "user_id",         null: false
    t.integer  "system_email_id", null: false
    t.string   "token",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_preferences", ["token"], name: "index_email_preferences_on_token", unique: true, using: :btree
  add_index "email_preferences", ["user_id", "system_email_id"], name: "index_email_preferences_on_user_id_and_system_email_id", unique: true, using: :btree

  create_table "extension_dependencies", force: true do |t|
    t.string   "name",                                      null: false
    t.string   "version_constraint",   default: ">= 0.0.0", null: false
    t.integer  "extension_version_id",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "extension_id"
  end

  add_index "extension_dependencies", ["extension_id"], name: "index_extension_dependencies_on_extension_id", using: :btree
  add_index "extension_dependencies", ["extension_version_id", "name", "version_constraint"], name: "cookbook_dependencies_unique_by_name_and_constraint", unique: true, using: :btree
  add_index "extension_dependencies", ["extension_version_id"], name: "index_extension_dependencies_on_extension_version_id", using: :btree

  create_table "extension_followers", force: true do |t|
    t.integer  "extension_id", null: false
    t.integer  "user_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extension_followers", ["extension_id", "user_id"], name: "index_extension_followers_on_extension_id_and_user_id", unique: true, using: :btree

  create_table "extension_version_content_items", force: true do |t|
    t.integer  "extension_version_id", null: false
    t.string   "name",                 null: false
    t.string   "path",                 null: false
    t.string   "item_type",            null: false
    t.string   "github_url",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extension_version_content_items", ["extension_version_id", "path"], name: "evcis_evid_path", unique: true, using: :btree
  add_index "extension_version_content_items", ["extension_version_id"], name: "index_extension_version_content_items_on_extension_version_id", using: :btree

  create_table "extension_version_platforms", force: true do |t|
    t.integer  "extension_version_id"
    t.integer  "supported_platform_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extension_version_platforms", ["extension_version_id", "supported_platform_id"], name: "index_cvp_on_cvi_and_spi", unique: true, using: :btree

  create_table "extension_versions", force: true do |t|
    t.integer  "extension_id"
    t.string   "license"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tarball_file_name"
    t.string   "tarball_content_type"
    t.integer  "tarball_file_size"
    t.datetime "tarball_updated_at"
    t.text     "readme",                default: "",    null: false
    t.string   "readme_extension",      default: "",    null: false
    t.boolean  "dependencies_imported", default: false
    t.text     "description"
    t.integer  "legacy_id"
    t.integer  "web_download_count",    default: 0
    t.integer  "api_download_count",    default: 0
    t.text     "changelog"
    t.string   "changelog_extension",   default: "",    null: false
    t.boolean  "foodcritic_failure"
    t.text     "foodcritic_feedback"
    t.integer  "rb_line_count",         default: 0,     null: false
    t.integer  "yml_line_count",        default: 0,     null: false
    t.string   "last_commit_string"
    t.datetime "last_commit_at"
    t.string   "last_commit_sha"
    t.string   "last_commit_url"
    t.integer  "commit_count",          default: 0,     null: false
  end

  add_index "extension_versions", ["legacy_id"], name: "index_extension_versions_on_legacy_id", unique: true, using: :btree
  add_index "extension_versions", ["version", "extension_id"], name: "index_extension_versions_on_version_and_extension_id", unique: true, using: :btree
  add_index "extension_versions", ["version"], name: "index_extension_versions_on_version", using: :btree

  create_table "extensions", force: true do |t|
    t.string   "name",                                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_url"
    t.boolean  "deprecated",                default: false
    t.integer  "category_id"
    t.string   "lowercase_name"
    t.string   "issues_url"
    t.integer  "extension_followers_count", default: 0
    t.integer  "user_id"
    t.integer  "replacement_id"
    t.integer  "web_download_count",        default: 0
    t.integer  "api_download_count",        default: 0
    t.boolean  "featured",                  default: false
    t.boolean  "up_for_adoption"
    t.boolean  "privacy"
    t.string   "description"
    t.string   "github_url"
    t.string   "license_name",              default: ""
    t.text     "license_text",              default: ""
    t.boolean  "enabled",                   default: true,  null: false
    t.boolean  "syncing",                   default: false
    t.integer  "github_organization_id"
    t.string   "owner_name"
  end

  add_index "extensions", ["enabled"], name: "index_extensions_on_enabled", using: :btree
  add_index "extensions", ["github_organization_id"], name: "index_extensions_on_github_organization_id", using: :btree
  add_index "extensions", ["lowercase_name"], name: "index_extensions_on_lowercase_name", unique: true, using: :btree
  add_index "extensions", ["name"], name: "index_extensions_on_name", using: :btree
  add_index "extensions", ["owner_name"], name: "index_extensions_on_owner_name", using: :btree
  add_index "extensions", ["user_id"], name: "index_extensions_on_user_id", using: :btree

  create_table "github_organizations", force: true do |t|
    t.integer  "github_id",  null: false
    t.string   "name",       null: false
    t.string   "avatar_url", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hits", force: true do |t|
    t.string  "label",             null: false
    t.integer "total", default: 0, null: false
  end

  add_index "hits", ["label"], name: "index_hits_on_label", unique: true, using: :btree

  create_table "icla_signatures", force: true do |t|
    t.integer  "user_id"
    t.datetime "signed_at"
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "email"
    t.string   "phone"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.integer  "icla_id"
  end

  add_index "icla_signatures", ["icla_id"], name: "index_icla_signatures_on_icla_id", using: :btree
  add_index "icla_signatures", ["user_id"], name: "index_icla_signatures_on_user_id", using: :btree

  create_table "iclas", force: true do |t|
    t.string   "version"
    t.text     "head"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.integer  "organization_id"
    t.string   "email"
    t.string   "token"
    t.boolean  "admin"
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["organization_id"], name: "index_invitations_on_organization_id", using: :btree

  create_table "organizations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ownership_transfer_requests", force: true do |t|
    t.integer  "extension_id", null: false
    t.integer  "recipient_id", null: false
    t.integer  "sender_id",    null: false
    t.string   "token",        null: false
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ownership_transfer_requests", ["extension_id"], name: "index_ownership_transfer_requests_on_extension_id", using: :btree
  add_index "ownership_transfer_requests", ["recipient_id"], name: "index_ownership_transfer_requests_on_recipient_id", using: :btree
  add_index "ownership_transfer_requests", ["token"], name: "index_ownership_transfer_requests_on_token", unique: true, using: :btree

  create_table "supported_platforms", force: true do |t|
    t.string   "name",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "released_on", null: false
  end

  create_table "system_emails", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "tag_id"], name: "index_taggings_on_taggable_id_and_taggable_type_and_tag_id", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tools", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "type"
    t.text     "description"
    t.string   "source_url"
    t.text     "instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lowercase_name"
    t.string   "slug"
    t.boolean  "up_for_adoption"
  end

  add_index "tools", ["lowercase_name"], name: "index_tools_on_lowercase_name", unique: true, using: :btree
  add_index "tools", ["slug"], name: "index_tools_on_slug", unique: true, using: :btree
  add_index "tools", ["user_id"], name: "index_tools_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company"
    t.integer  "roles_mask"
    t.string   "email",              default: ""
    t.string   "jira_username"
    t.string   "irc_nickname"
    t.string   "twitter_username"
    t.text     "public_key"
    t.string   "install_preference"
    t.string   "auth_scope",         default: "",   null: false
    t.string   "avatar_url"
    t.boolean  "enabled",            default: true, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["roles_mask"], name: "index_users_on_roles_mask", using: :btree

end
