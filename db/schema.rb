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

ActiveRecord::Schema.define(version: 2018_09_26_170952) do

  create_table "applies", force: :cascade do |t|
    t.integer "status"
    t.boolean "highlight", default: false
    t.integer "user_id"
    t.integer "job_advert_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_advert_id", "user_id"], name: "job_advert_user", unique: true
    t.index ["job_advert_id"], name: "index_applies_on_job_advert_id"
    t.index ["user_id"], name: "index_applies_on_user_id"
  end

  create_table "job_adverts", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_job_adverts_on_user_id"
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rol", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
