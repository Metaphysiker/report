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

  create_table "alchemy_attachments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "file_name"
    t.string "file_mime_type"
    t.integer "file_size"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "cached_tag_list"
    t.string "file_uid"
    t.index ["file_uid"], name: "index_alchemy_attachments_on_file_uid"
  end

  create_table "alchemy_cells", id: :serial, force: :cascade do |t|
    t.integer "page_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_alchemy_cells_on_page_id"
  end

  create_table "alchemy_contents", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "essence_type", null: false
    t.integer "essence_id", null: false
    t.integer "element_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.index ["element_id", "position"], name: "index_contents_on_element_id_and_position"
    t.index ["essence_id", "essence_type"], name: "index_alchemy_contents_on_essence_id_and_essence_type", unique: true
  end

  create_table "alchemy_elements", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.integer "page_id", null: false
    t.boolean "public", default: true
    t.boolean "folded", default: false
    t.boolean "unique", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.integer "cell_id"
    t.text "cached_tag_list"
    t.integer "parent_element_id"
    t.index ["cell_id"], name: "index_alchemy_elements_on_cell_id"
    t.index ["page_id", "parent_element_id"], name: "index_alchemy_elements_on_page_id_and_parent_element_id"
    t.index ["page_id", "position"], name: "index_elements_on_page_id_and_position"
  end

  create_table "alchemy_elements_alchemy_pages", id: false, force: :cascade do |t|
    t.integer "element_id"
    t.integer "page_id"
  end

  create_table "alchemy_essence_booleans", id: :serial, force: :cascade do |t|
    t.boolean "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.index ["value"], name: "index_alchemy_essence_booleans_on_value"
  end

  create_table "alchemy_essence_dates", id: :serial, force: :cascade do |t|
    t.datetime "date"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alchemy_essence_files", id: :serial, force: :cascade do |t|
    t.integer "attachment_id"
    t.string "title"
    t.string "css_class"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link_text"
    t.index ["attachment_id"], name: "index_alchemy_essence_files_on_attachment_id"
  end

  create_table "alchemy_essence_htmls", id: :serial, force: :cascade do |t|
    t.text "source"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alchemy_essence_links", id: :serial, force: :cascade do |t|
    t.string "link"
    t.string "link_title"
    t.string "link_target"
    t.string "link_class_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
  end

  create_table "alchemy_essence_pictures", id: :serial, force: :cascade do |t|
    t.integer "picture_id"
    t.string "caption"
    t.string "title"
    t.string "alt_tag"
    t.string "link"
    t.string "link_class_name"
    t.string "link_title"
    t.string "css_class"
    t.string "link_target"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crop_from"
    t.string "crop_size"
    t.string "render_size"
    t.boolean "searchable", default: true
    t.index ["picture_id"], name: "index_alchemy_essence_pictures_on_picture_id"
  end

  create_table "alchemy_essence_richtexts", id: :serial, force: :cascade do |t|
    t.text "body"
    t.text "stripped_body"
    t.boolean "public"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "searchable", default: true
  end

  create_table "alchemy_essence_selects", id: :serial, force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.index ["value"], name: "index_alchemy_essence_selects_on_value"
  end

  create_table "alchemy_essence_texts", id: :serial, force: :cascade do |t|
    t.text "body"
    t.string "link"
    t.string "link_title"
    t.string "link_class_name"
    t.boolean "public", default: false
    t.string "link_target"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "searchable", default: true
  end

  create_table "alchemy_essence_topics", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alchemy_essence_topics_topics", id: false, force: :cascade do |t|
    t.integer "alchemy_essence_topic_id", null: false
    t.integer "topic_id", null: false
    t.integer "position"
    t.index ["alchemy_essence_topic_id", "topic_id"], name: "essence_topics_topic_id"
    t.index ["topic_id", "alchemy_essence_topic_id"], name: "topics_topic_id"
  end

  create_table "alchemy_folded_pages", id: :serial, force: :cascade do |t|
    t.integer "page_id", null: false
    t.integer "user_id", null: false
    t.boolean "folded", default: false
    t.index ["page_id", "user_id"], name: "index_alchemy_folded_pages_on_page_id_and_user_id", unique: true
  end

  create_table "alchemy_languages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "language_code"
    t.string "frontpage_name"
    t.string "page_layout", default: "intro"
    t.boolean "public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.boolean "default", default: false
    t.string "country_code", default: "", null: false
    t.integer "site_id", null: false
    t.string "locale"
    t.index ["language_code", "country_code"], name: "index_alchemy_languages_on_language_code_and_country_code"
    t.index ["language_code"], name: "index_alchemy_languages_on_language_code"
    t.index ["site_id"], name: "index_alchemy_languages_on_site_id"
  end

  create_table "alchemy_legacy_page_urls", id: :serial, force: :cascade do |t|
    t.string "urlname", null: false
    t.integer "page_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_alchemy_legacy_page_urls_on_page_id"
    t.index ["urlname"], name: "index_alchemy_legacy_page_urls_on_urlname"
  end

  create_table "alchemy_pages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "urlname"
    t.string "title"
    t.string "language_code"
    t.boolean "language_root"
    t.string "page_layout"
    t.text "meta_keywords"
    t.text "meta_description"
    t.integer "lft"
    t.integer "rgt"
    t.integer "parent_id"
    t.integer "depth"
    t.boolean "visible", default: false
    t.integer "locked_by"
    t.boolean "restricted", default: false
    t.boolean "robot_index", default: true
    t.boolean "robot_follow", default: true
    t.boolean "sitemap", default: true
    t.boolean "layoutpage", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.integer "language_id"
    t.text "cached_tag_list"
    t.datetime "published_at"
    t.datetime "public_on"
    t.datetime "public_until"
    t.datetime "locked_at"
    t.index ["language_id"], name: "index_pages_on_language_id"
    t.index ["locked_at", "locked_by"], name: "index_alchemy_pages_on_locked_at_and_locked_by"
    t.index ["parent_id", "lft"], name: "index_pages_on_parent_id_and_lft"
    t.index ["public_on", "public_until"], name: "index_alchemy_pages_on_public_on_and_public_until"
    t.index ["rgt"], name: "index_alchemy_pages_on_rgt"
    t.index ["urlname"], name: "index_pages_on_urlname"
  end

  create_table "alchemy_pictures", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "image_file_name"
    t.integer "image_file_width"
    t.integer "image_file_height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.string "upload_hash"
    t.text "cached_tag_list"
    t.string "image_file_uid"
    t.integer "image_file_size"
    t.string "image_file_format"
  end

  create_table "alchemy_sites", id: :serial, force: :cascade do |t|
    t.string "host"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public", default: false
    t.text "aliases"
    t.boolean "redirect_to_primary_host"
    t.index ["host", "public"], name: "alchemy_sites_public_hosts_idx"
    t.index ["host"], name: "index_alchemy_sites_on_host"
  end

  create_table "alchemy_users", id: :serial, force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "login"
    t.string "email"
    t.string "gender"
    t.string "language"
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "password_salt", limit: 128, default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.text "cached_tag_list"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "alchemy_roles", default: "member"
    t.integer "profile_id"
    t.index ["alchemy_roles"], name: "index_alchemy_users_on_alchemy_roles"
    t.index ["email"], name: "index_alchemy_users_on_email", unique: true
    t.index ["firstname"], name: "index_alchemy_users_on_firstname"
    t.index ["lastname"], name: "index_alchemy_users_on_lastname"
    t.index ["login"], name: "index_alchemy_users_on_login", unique: true
    t.index ["reset_password_token"], name: "index_alchemy_users_on_reset_password_token", unique: true
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "commentable_id"
    t.string "commentable_type"
    t.string "title"
    t.text "body"
    t.string "subject"
    t.integer "user_id"
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "user_email"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["confirmation_token"], name: "index_comments_on_confirmation_token", unique: true
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "follows", id: :serial, force: :cascade do |t|
    t.integer "followable_id", null: false
    t.string "followable_type", null: false
    t.integer "follower_id", null: false
    t.string "follower_type", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.date "birth_date"
    t.boolean "public", default: false
    t.integer "level", default: 0
    t.string "website"
    t.string "facebook_profile"
    t.string "academic_page"
    t.text "other_personal_information"
    t.string "area"
    t.string "institutional_affiliation"
    t.string "type_of_affiliation"
    t.string "teacher_at_institution"
    t.string "teach_as_well"
    t.boolean "receive_leaflets", default: false
    t.boolean "share_material", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "interested_in_education", default: "yes"
    t.text "first_favorites"
    t.text "second_favorites"
    t.string "country", default: "CH"
    t.string "other_institutional_affiliation"
    t.integer "society_id"
    t.string "name"
    t.string "abbreviation"
    t.text "description"
    t.text "activities"
    t.integer "number_of_professorships"
    t.text "address"
    t.integer "number_of_postgraduates"
    t.integer "number_of_students"
    t.text "characteristics"
    t.string "other_type_of_affiliation"
    t.string "image_uid"
    t.string "image_name"
    t.string "slug"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "filter", default: "all"
    t.index ["confirmation_token"], name: "index_profiles_on_confirmation_token", unique: true
  end

  create_table "profiles_topics", id: false, force: :cascade do |t|
    t.integer "profile_id", null: false
    t.integer "topic_id", null: false
    t.index ["profile_id", "topic_id"], name: "index_profiles_topics_on_profile_id_and_topic_id"
    t.index ["topic_id", "profile_id"], name: "index_profiles_topics_on_topic_id_and_profile_id"
  end

  create_table "reports", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "preferences"
    t.hstore "general"
    t.hstore "interests"
    t.hstore "stats"
    t.string "name"
    t.boolean "specialreport", default: false
    t.date "whichbackup"
    t.date "startdate"
    t.date "enddate"
    t.hstore "societies"
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
    t.index ["interests"], name: "index_reports_on_interests", using: :gin
    t.index ["jobserstellt"], name: "index_reports_on_jobserstellt", using: :gin
    t.index ["jobstotal"], name: "index_reports_on_jobstotal", using: :gin
    t.index ["kommentareerstellt"], name: "index_reports_on_kommentareerstellt", using: :gin
    t.index ["kommentaretotal"], name: "index_reports_on_kommentaretotal", using: :gin
    t.index ["newslettererstellt"], name: "index_reports_on_newslettererstellt", using: :gin
    t.index ["newslettertotal"], name: "index_reports_on_newslettertotal", using: :gin
    t.index ["preferences"], name: "index_reports_on_preferences", using: :gin
    t.index ["profileerstellt"], name: "index_reports_on_profileerstellt", using: :gin
    t.index ["profiletotal"], name: "index_reports_on_profiletotal", using: :gin
    t.index ["societies"], name: "index_reports_on_societies", using: :gin
    t.index ["stats"], name: "index_reports_on_stats", using: :gin
    t.index ["zuletztangemeldet"], name: "index_reports_on_zuletztangemeldet", using: :gin
  end

  create_table "societies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "profile_id"
    t.boolean "custom_topics", default: false
    t.integer "interval", default: 0
    t.datetime "valid_until"
    t.datetime "last_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level", default: 0
    t.datetime "payed_at"
    t.boolean "active", default: false
    t.integer "payment_type", default: 0
    t.boolean "recurring", default: false
    t.string "amount", default: "30"
    t.string "company"
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "lockbox"
    t.string "zip_code"
    t.string "location"
    t.string "email"
    t.string "paypal_profile_id"
    t.datetime "last_reminder_sent_at"
  end

  create_table "subscriptions_topics", id: false, force: :cascade do |t|
    t.integer "subscription_id", null: false
    t.integer "topic_id", null: false
    t.index ["subscription_id"], name: "index_subscriptions_topics_on_subscription_id"
    t.index ["topic_id"], name: "index_subscriptions_topics_on_topic_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "topics", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "group", default: 0
    t.integer "interest_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "alchemy_cells", "alchemy_pages", column: "page_id", name: "alchemy_cells_page_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "alchemy_contents", "alchemy_elements", column: "element_id", name: "alchemy_contents_element_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "alchemy_elements", "alchemy_cells", column: "cell_id", name: "alchemy_elements_cell_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "alchemy_elements", "alchemy_pages", column: "page_id", name: "alchemy_elements_page_id_fkey", on_update: :cascade, on_delete: :cascade
end
