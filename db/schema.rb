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

ActiveRecord::Schema.define(version: 20150315065931) do

  create_table "amazons", force: :cascade do |t|
    t.string   "asin",             limit: 255
    t.text     "url",              limit: 65535
    t.text     "medium_image_url", limit: 65535
    t.text     "small_image_url",  limit: 65535
    t.string   "product_name",     limit: 255
    t.string   "creator",          limit: 255
    t.string   "manufacturer",     limit: 255
    t.string   "media",            limit: 255
    t.string   "release_date",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "amazons", ["asin"], name: "index_amazons_on_asin", using: :btree

  create_table "article_contents", force: :cascade do |t|
    t.integer  "article_id", limit: 4,     null: false
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_contents", ["article_id"], name: "index_article_contents_on_article_id", unique: true, using: :btree

  create_table "article_keywords", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.integer  "keyword_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_keywords", ["article_id"], name: "index_article_keywords_on_article_id", using: :btree
  add_index "article_keywords", ["keyword_id"], name: "index_article_keywords_on_keyword_id", using: :btree

  create_table "article_photos", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.integer  "photo_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_photos", ["article_id", "photo_id"], name: "index_article_photos_on_article_id_and_photo_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "title",        limit: 255,             null: false
    t.datetime "publish_at",                           null: false
    t.integer  "access_count", limit: 4,   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["access_count"], name: "index_articles_on_access_count", using: :btree
  add_index "articles", ["publish_at"], name: "index_articles_on_publish_at", using: :btree

  create_table "back_images", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255, null: false
    t.string   "image_content_type", limit: 255, null: false
    t.integer  "image_file_size",    limit: 4,   null: false
    t.datetime "image_updated_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id", using: :btree
  add_index "comments", ["created_at"], name: "index_comments_on_created_at", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0
    t.integer  "attempts",   limit: 4,     default: 0
    t.text     "handler",    limit: 65535
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "facebook_tokens", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "token",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_tokens", ["user_id"], name: "index_facebooks_on_user_id", using: :btree

  create_table "keywords", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "body",       limit: 1000, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keywords", ["name"], name: "index_keywords_on_name", unique: true, using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255, null: false
    t.string   "image_content_type", limit: 255, null: false
    t.integer  "image_file_size",    limit: 4,   null: false
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["image_updated_at"], name: "index_photos_on_image_updated_at", using: :btree

  create_table "related_articles", force: :cascade do |t|
    t.integer  "article_id",         limit: 4
    t.integer  "related_article_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "related_articles", ["article_id", "related_article_id"], name: "index_related_articles_on_article_id_and_related_article_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255, default: "", null: false
    t.string   "password_digest", limit: 255,              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
