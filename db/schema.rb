# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_03_104050) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ai_chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "dog_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_ai_chats_on_dog_id"
  end

  create_table "ai_messages", force: :cascade do |t|
    t.bigint "ai_chat_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ai_chat_id"], name: "index_ai_messages_on_ai_chat_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "dog_id", null: false
    t.bigint "post_id", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_comments_on_dog_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "dog_one_id", null: false
    t.bigint "dog_two_id", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_one_id", "dog_two_id"], name: "index_conversations_on_dog_one_id_and_dog_two_id", unique: true
  end

  create_table "dogs", force: :cascade do |t|
    t.integer "age"
    t.string "breed"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_dogs_on_user_id"
  end

  create_table "event_participants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "dog_id", null: false
    t.bigint "event_id", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_event_participants_on_dog_id"
    t.index ["event_id"], name: "index_event_participants_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.date "date"
    t.text "description"
    t.bigint "dog_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_events_on_dog_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.bigint "dog_id", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["dog_id"], name: "index_messages_on_dog_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "dog_id", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_posts_on_dog_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "woufs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "dog_id", null: false
    t.bigint "post_id", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_woufs_on_dog_id"
    t.index ["post_id"], name: "index_woufs_on_post_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ai_chats", "dogs"
  add_foreign_key "ai_messages", "ai_chats"
  add_foreign_key "comments", "dogs"
  add_foreign_key "comments", "posts"
  add_foreign_key "conversations", "dogs", column: "dog_one_id"
  add_foreign_key "conversations", "dogs", column: "dog_two_id"
  add_foreign_key "dogs", "users"
  add_foreign_key "event_participants", "dogs"
  add_foreign_key "event_participants", "events"
  add_foreign_key "events", "dogs"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "dogs"
  add_foreign_key "posts", "dogs"
  add_foreign_key "woufs", "dogs"
  add_foreign_key "woufs", "posts"
end
