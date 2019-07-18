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

ActiveRecord::Schema.define(version: 2017_01_24_143633) do

  create_table "article_contents", force: :cascade do |t|
    t.integer "article_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_contents_on_article_id", unique: true
  end

  create_table "article_keywords", force: :cascade do |t|
    t.integer "article_id"
    t.integer "keyword_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_keywords_on_article_id"
    t.index ["keyword_id"], name: "index_article_keywords_on_keyword_id"
  end

  create_table "article_photos", force: :cascade do |t|
    t.integer "article_id"
    t.integer "photo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id", "photo_id"], name: "index_article_photos_on_article_id_and_photo_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "publish_at", null: false
    t.integer "access_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_count"], name: "index_articles_on_access_count"
    t.index ["publish_at"], name: "index_articles_on_publish_at"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "body", limit: 1000, default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_keywords_on_name", unique: true
  end

  create_table "photos", force: :cascade do |t|
    t.string "image_file_name", null: false
    t.string "image_content_type", null: false
    t.integer "image_file_size", null: false
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_updated_at"], name: "index_photos_on_image_updated_at"
  end

  create_table "related_articles", force: :cascade do |t|
    t.integer "article_id"
    t.integer "related_article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id", "related_article_id"], name: "index_related_articles_on_article_id_and_related_article_id"
  end

  create_table "share_to_sns", force: :cascade do |t|
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_share_to_sns_on_article_id"
    t.index ["created_at"], name: "index_share_to_sns_on_created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
