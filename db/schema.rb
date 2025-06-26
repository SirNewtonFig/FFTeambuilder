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

ActiveRecord::Schema[7.1].define(version: 2025_06_26_231707) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "challonge_credentials", force: :cascade do |t|
    t.uuid "user_id"
    t.text "username"
    t.text "key"
    t.index ["user_id"], name: "index_challonge_credentials_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.text "title"
    t.datetime "deadline"
    t.jsonb "data", default: {}, null: false
    t.boolean "active", default: true, null: false
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.text "slug"
    t.text "state", default: "open"
    t.integer "external_id"
    t.text "bracket_url"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "exclusions", force: :cascade do |t|
    t.string "ability_a_type", null: false
    t.bigint "ability_a_id", null: false
    t.string "ability_b_type", null: false
    t.bigint "ability_b_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ability_a_type", "ability_a_id"], name: "index_exclusions_on_ability_a"
    t.index ["ability_b_type", "ability_b_id"], name: "index_exclusions_on_ability_b"
  end

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

  create_table "monster_passives", force: :cascade do |t|
    t.text "name"
    t.integer "jp_cost"
    t.jsonb "data"
    t.bigint "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_monster_passives_on_job_id"
  end

  create_table "monster_skills", force: :cascade do |t|
    t.text "name"
    t.jsonb "data"
    t.boolean "monster_skill"
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

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
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

  create_table "statuses", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.integer "default_priority"
    t.text "duration"
    t.text "indicator"
    t.boolean "show_priority", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "upgrades_to"
    t.text "upgrade_effect"
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "team_id"
    t.jsonb "data", default: {}, null: false
    t.boolean "active", default: true
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority"
    t.text "player_name_override"
    t.text "team_name_override"
    t.integer "external_id"
    t.integer "rank"
    t.bigint "team_snapshot_id", null: false
    t.index ["event_id"], name: "index_submissions_on_event_id"
    t.index ["team_id"], name: "index_submissions_on_team_id"
    t.index ["team_snapshot_id"], name: "index_submissions_on_team_snapshot_id"
  end

  create_table "team_snapshots", force: :cascade do |t|
    t.uuid "user_id"
    t.text "name"
    t.text "player_name"
    t.integer "palette_a", default: 0
    t.integer "palette_b", default: 0
    t.jsonb "data"
    t.integer "jp_total", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_team_snapshots_on_user_id"
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
    t.integer "jp_total", default: 0
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "username", null: false
    t.text "uid"
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.uuid "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "submissions", "team_snapshots"
  add_foreign_key "team_snapshots", "users"
end
