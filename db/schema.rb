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

ActiveRecord::Schema.define(version: 20140421154905) do

  create_table "articles", id: false, force: true do |t|
    t.text "title"
    t.text "description"
  end

  create_table "attachments", force: true do |t|
    t.integer "board_id"
    t.text    "file"
  end

  create_table "board_empathies", force: true do |t|
    t.integer "board_id"
    t.integer "user_id"
  end

  create_table "boards", force: true do |t|
    t.integer  "region_id"
    t.integer  "route_id"
    t.integer  "station_id"
    t.integer  "user_id"
    t.integer  "hits"
    t.text     "title"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "friend_public",  limit: 1
    t.integer  "comments_count"
  end

  create_table "comments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "board_id"
    t.integer  "user_id"
    t.string   "title",      limit: 30
    t.text     "contents"
  end

  create_table "regions", force: true do |t|
    t.string "name"
  end

  create_table "routes", force: true do |t|
    t.integer "region_id"
    t.string  "name"
    t.integer "boards_count", default: 0
  end

  create_table "stations", force: true do |t|
    t.integer "region_id"
    t.integer "route_id"
    t.string  "name"
  end

  create_table "tokens", force: true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "expires"
  end

  create_table "users", force: true do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img_url",                limit: 30
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
