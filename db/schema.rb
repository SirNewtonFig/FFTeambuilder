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

ActiveRecord::Schema[7.0].define(version: 2022_12_25_191002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "innates", force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_innates_on_job_id"
    t.index ["skill_id"], name: "index_innates_on_skill_id"
  end

  create_table "items", force: :cascade do |t|
    t.text "name"
    t.integer "item_type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.text "name"
    t.text "skillset"
    t.text "abbreviation"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prerequisites", force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "prerequisite_id"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_prerequisites_on_job_id"
    t.index ["prerequisite_id"], name: "index_prerequisites_on_prerequisite_id"
  end

  create_table "proficiencies", force: :cascade do |t|
    t.bigint "item_id"
    t.string "record_type"
    t.bigint "record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_proficiencies_on_item_id"
    t.index ["record_type", "record_id"], name: "index_proficiencies_on_record"
  end

  create_table "skills", force: :cascade do |t|
    t.text "value"
    t.integer "jp_cost"
    t.text "name"
    t.integer "skill_type", default: 0
    t.jsonb "data"
    t.bigint "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_skills_on_job_id"
  end

  create_table "teams", force: :cascade do |t|
    t.uuid "user_id"
    t.text "name"
    t.text "player_name"
    t.integer "palette_a", default: 0
    t.integer "palette_b", default: 0
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
