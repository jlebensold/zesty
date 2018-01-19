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

ActiveRecord::Schema.define(version: 20180117211741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "classification_jobs", force: :cascade do |t|
    t.bigint "classifier_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "job_number", default: 1
    t.index ["classifier_id"], name: "index_classification_jobs_on_classifier_id"
  end

  create_table "classifiers", force: :cascade do |t|
    t.string "name"
    t.json "meta", default: {}
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_classifiers_on_organization_id"
  end

  create_table "input_assets", force: :cascade do |t|
    t.string "label", default: "", null: false
    t.bigint "classifier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["classifier_id"], name: "index_input_assets_on_classifier_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "output_assets", force: :cascade do |t|
    t.string "label", default: "", null: false
    t.bigint "classifier_id", null: false
    t.bigint "classification_job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["classification_job_id"], name: "index_output_assets_on_classification_job_id"
    t.index ["classifier_id"], name: "index_output_assets_on_classifier_id"
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'role' for column 'role'

  add_foreign_key "classifiers", "organizations"
end
