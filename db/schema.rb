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

ActiveRecord::Schema.define(version: 2020_04_25_234843) do

  create_table "logs", force: :cascade do |t|
    t.string "query", null: false
    t.string "answer", null: false
    t.datetime "created_at"
    t.integer "algo"
    t.index ["answer"], name: "index_logs_on_answer"
    t.index ["query"], name: "index_logs_on_query"
  end

  create_table "populations", force: :cascade do |t|
    t.integer "population"
    t.integer "year"
    t.index ["year"], name: "index_populations_on_year"
  end

end
