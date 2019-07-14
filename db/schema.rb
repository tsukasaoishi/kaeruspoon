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

  create_table "amazons", force: :cascade do |t|
    t.string "asin", limit: 255
    t.text "url"
    t.text "medium_image_url"
    t.text "small_image_url"
    t.string "product_name", limit: 255
    t.string "creator", limit: 255
    t.string "manufacturer", limit: 255
    t.string "media", limit: 255
    t.string "release_date", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["asin"], name: "amazons_index_amazons_on_asin"
  end

  create_table "article_contents", force: :cascade do |t|
    t.integer "article_id", limit: 11, null: false
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id"], name: "article_contents_index_article_contents_on_article_id"
  end

  create_table "article_keywords", force: :cascade do |t|
    t.integer "article_id", limit: 11
    t.integer "keyword_id", limit: 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id"], name: "article_keywords_index_article_keywords_on_article_id"
    t.index ["keyword_id"], name: "article_keywords_index_article_keywords_on_keyword_id"
  end

  create_table "article_photos", force: :cascade do |t|
    t.integer "article_id", limit: 11
    t.integer "photo_id", limit: 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id", "photo_id"], name: "article_photos_index_article_photos_on_article_id_and_photo_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.datetime "publish_at", null: false
    t.integer "access_count", limit: 11, default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["access_count"], name: "articles_index_articles_on_access_count"
    t.index ["publish_at"], name: "articles_index_articles_on_publish_at"
  end

  create_table "back_images", force: :cascade do |t|
    t.string "image_file_name", limit: 255, null: false
    t.string "image_content_type", limit: 255, null: false
    t.integer "image_file_size", limit: 11, null: false
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "article_id", limit: 11
    t.integer "user_id", limit: 11
    t.string "name", limit: 255
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id"], name: "comments_index_comments_on_article_id"
    t.index ["created_at"], name: "comments_index_comments_on_created_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", limit: 11, default: 0
    t.integer "attempts", limit: 11, default: 0
    t.text "handler"
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by", limit: 255
    t.string "queue", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_delayed_jobs_priority"
  end

  create_table "facebook_tokens", force: :cascade do |t|
    t.integer "user_id", limit: 11
    t.string "token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "facebook_tokens_index_facebooks_on_user_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "body", limit: 1000, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "keywords_index_keywords_on_name"
  end

  create_table "photos", force: :cascade do |t|
    t.string "image_file_name", limit: 255, null: false
    t.string "image_content_type", limit: 255, null: false
    t.integer "image_file_size", limit: 11, null: false
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["image_updated_at"], name: "photos_index_photos_on_image_updated_at"
  end

  create_table "related_articles", force: :cascade do |t|
    t.integer "article_id", limit: 11
    t.integer "related_article_id", limit: 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id", "related_article_id"], name: "related_articles_index_related_articles_on_article_id_and_related_article_id"
  end

  create_table "share_to_sns", force: :cascade do |t|
    t.integer "article_id", limit: 11
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "share_to_sns_index_share_to_sns_on_article_id"
    t.index ["created_at"], name: "share_to_sns_index_share_to_sns_on_created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.string "password_digest", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
