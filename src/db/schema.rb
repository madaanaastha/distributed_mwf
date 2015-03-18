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

ActiveRecord::Schema.define(version: 20141113070347) do

  create_table "data_tuples", force: true do |t|
    t.string   "world_uri"
    t.string   "schema_uri"
    t.text     "data_store"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "event_type"
    t.datetime "date_time"
    t.string   "world_uri"
    t.text     "privilege_id"
    t.string   "user_uri"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "event_type_id"
    t.string   "world_uri"
    t.text     "privilege_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proxy_worlds", force: true do |t|
    t.string   "world_uri"
    t.string   "proxy_world_uri"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schema_tables", force: true do |t|
    t.string   "world_uri"
    t.string   "name"
    t.string   "uri"
    t.string   "role_player_column_name"
    t.integer  "version"
    t.text     "hash_store"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uris", force: true do |t|
    t.string   "host"
    t.integer  "port"
    t.string   "uri_type"
    t.integer  "local_id"
    t.string   "name"
    t.string   "slug"
    t.boolean  "is_external"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "world_admins", force: true do |t|
    t.string   "world_uri"
    t.string   "admin_uri"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "world_imports", force: true do |t|
    t.string   "import_to_uri"
    t.string   "import_from_uri"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "world_instances", force: true do |t|
    t.string   "name"
    t.string   "superclass_uri"
    t.string   "container_uri"
    t.text     "description"
    t.text     "attrs"
    t.text     "options"
    t.string   "world_instance_uri"
    t.string   "home_location_uri"
    t.string   "image"
    t.string   "url"
    t.text     "access_rules"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "world_participations", force: true do |t|
    t.string  "participating_world_uri"
    t.string  "container_table_uri"
    t.string  "container_world_uri"
    t.boolean "verified"
  end

  create_table "worlds", force: true do |t|
    t.string   "name"
    t.string   "superclass_uri"
    t.string   "superclass_name"
    t.string   "container_uri"
    t.string   "container_name"
    t.text     "description"
    t.text     "attrs"
    t.text     "options"
    t.string   "world_uri"
    t.string   "home_location_uri"
    t.string   "image"
    t.string   "url"
    t.text     "access_rules"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
