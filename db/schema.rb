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

ActiveRecord::Schema.define(version: 2019_07_31_074919) do

  create_table "nonces", force: :cascade do |t|
    t.string "nonce"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notify_days", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "is_sunday"
    t.boolean "is_monday"
    t.boolean "is_tuesday"
    t.boolean "is_wednesday"
    t.boolean "is_thursday"
    t.boolean "is_friday"
    t.boolean "is_saturday"
  end

  create_table "notify_times", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "notify_6to8"
    t.boolean "notify_8to10"
    t.boolean "notify_10to12"
    t.boolean "notify_12to14"
    t.boolean "notify_14to16"
    t.boolean "notify_16to18"
    t.boolean "notify_18to20"
    t.boolean "notify_20to22"
    t.boolean "notify_22to24"
  end

  create_table "phases", force: :cascade do |t|
    t.string "name"
    t.date "deadline"
    t.integer "project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.float "progress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.string "memo"
    t.integer "progress"
    t.integer "phase_id"
    t.integer "project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "mail"
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_line_id"
  end

end
