# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090718161840) do

  create_table "albums", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.boolean  "publish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configs", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fingers", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.integer  "finger_num"
    t.string   "file_name"
    t.text     "data"
    t.integer  "status"
    t.string   "fingerdata_file_name"
    t.string   "fingerdata_content_type"
    t.integer  "fingerdata_file_size"
    t.datetime "fingerdata_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fingers", ["user_id"], :name => "index_fingers_on_user_id"

  create_table "locations", :force => true do |t|
    t.integer  "user_id"
    t.float    "lat"
    t.float    "long"
    t.string   "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.string   "description"
    t.integer  "finger_num"
    t.integer  "status"
    t.text     "data"
  end

  add_index "photos", ["album_id"], :name => "index_photos_on_album_id"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "context"
    t.datetime "dtpost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.integer  "sex",                                      :default => 1
    t.string   "addr",                      :limit => 120
    t.string   "tel",                       :limit => 120
    t.date     "birth"
    t.integer  "avatar_id"
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
