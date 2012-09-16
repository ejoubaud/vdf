# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120916171646) do

  create_table "checks", :force => true do |t|
    t.string   "claim",       :limit => 140, :null => false
    t.string   "remark",      :limit => 140, :null => false
    t.string   "ref_url"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "stamp_id"
    t.integer  "document_id"
  end

  create_table "documents", :force => true do |t|
    t.string   "name",        :limit => 15,                    :null => false
    t.string   "title",                                        :null => false
    t.string   "subtitle"
    t.text     "description",                                  :null => false
    t.string   "impact"
    t.string   "poster"
    t.boolean  "active",                    :default => false, :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "creator",     :limit => 32
    t.string   "creator_url"
  end

  add_index "documents", ["name"], :name => "index_documents_on_name"

  create_table "stamps", :force => true do |t|
    t.string  "name",        :limit => 15, :null => false
    t.string  "title",       :limit => 32, :null => false
    t.string  "description"
    t.integer "document_id"
  end

end
