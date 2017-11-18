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

ActiveRecord::Schema.define(version: 20170725193849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "reports", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "general"
    t.hstore "interests"
    t.hstore "stats"
    t.string "name"
    t.boolean "specialreport", default: false
    t.date "whichbackup"
    t.date "startdate"
    t.date "enddate"
    t.string "allgemeingroupinterests", default: [], array: true
    t.string "articleanalysis", default: [], array: true
    t.string "eventanalysis", default: [], array: true
    t.hstore "societies"
    t.hstore "lehrpersonentotal"
    t.hstore "interestedineducationtotal"
    t.hstore "profileerstellt"
    t.hstore "profiletotal"
    t.hstore "kommentareerstellt"
    t.hstore "kommentaretotal"
    t.hstore "eventserstellt"
    t.hstore "eventstotal"
    t.hstore "artikelerstellt"
    t.hstore "artikeltotal"
    t.hstore "jobserstellt"
    t.hstore "jobstotal"
    t.hstore "cfperstellt"
    t.hstore "cfptotal"
    t.hstore "newslettererstellt"
    t.hstore "newslettertotal"
    t.hstore "zuletztangemeldet"
    t.string "stackedinterests", default: [], array: true
    t.index ["artikelerstellt"], name: "index_reports_on_artikelerstellt", using: :gin
    t.index ["artikeltotal"], name: "index_reports_on_artikeltotal", using: :gin
    t.index ["cfperstellt"], name: "index_reports_on_cfperstellt", using: :gin
    t.index ["cfptotal"], name: "index_reports_on_cfptotal", using: :gin
    t.index ["eventserstellt"], name: "index_reports_on_eventserstellt", using: :gin
    t.index ["eventstotal"], name: "index_reports_on_eventstotal", using: :gin
    t.index ["general"], name: "index_reports_on_general", using: :gin
    t.index ["interestedineducationtotal"], name: "index_reports_on_interestedineducationtotal", using: :gin
    t.index ["interests"], name: "index_reports_on_interests", using: :gin
    t.index ["jobserstellt"], name: "index_reports_on_jobserstellt", using: :gin
    t.index ["jobstotal"], name: "index_reports_on_jobstotal", using: :gin
    t.index ["kommentareerstellt"], name: "index_reports_on_kommentareerstellt", using: :gin
    t.index ["kommentaretotal"], name: "index_reports_on_kommentaretotal", using: :gin
    t.index ["lehrpersonentotal"], name: "index_reports_on_lehrpersonentotal", using: :gin
    t.index ["newslettererstellt"], name: "index_reports_on_newslettererstellt", using: :gin
    t.index ["newslettertotal"], name: "index_reports_on_newslettertotal", using: :gin
    t.index ["profileerstellt"], name: "index_reports_on_profileerstellt", using: :gin
    t.index ["profiletotal"], name: "index_reports_on_profiletotal", using: :gin
    t.index ["societies"], name: "index_reports_on_societies", using: :gin
    t.index ["stats"], name: "index_reports_on_stats", using: :gin
    t.index ["zuletztangemeldet"], name: "index_reports_on_zuletztangemeldet", using: :gin
  end

  create_table "universities", force: :cascade do |t|
    t.string "title"
    t.bigint "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "information"
    t.index ["information"], name: "index_universities_on_information", using: :gin
    t.index ["report_id"], name: "index_universities_on_report_id"
  end

end
