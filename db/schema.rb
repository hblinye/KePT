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

ActiveRecord::Schema.define(version: 2019_05_28_133648) do

  create_table "meetings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "skey"
    t.integer "status", default: 0
  end

  create_table "thought_opinions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "thought_id"
    t.integer "opinion", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thought_id"], name: "index_thought_opinions_on_thought_id"
    t.index ["user_id"], name: "index_thought_opinions_on_user_id"
  end

  create_table "thought_picks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "thought_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thought_id"], name: "index_thought_picks_on_thought_id"
    t.index ["user_id"], name: "index_thought_picks_on_user_id"
  end

  create_table "thoughts", force: :cascade do |t|
    t.string "content"
    t.integer "ttype"
    t.integer "user_id"
    t.integer "meeting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discussing", default: 0
    t.index ["meeting_id"], name: "index_thoughts_on_meeting_id"
    t.index ["user_id"], name: "index_thoughts_on_user_id"
  end

  create_table "user_meeting_relationships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "meeting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["meeting_id"], name: "index_user_meeting_relationships_on_meeting_id"
    t.index ["user_id"], name: "index_user_meeting_relationships_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "skey", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
