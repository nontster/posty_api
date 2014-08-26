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

ActiveRecord::Schema.define(:version => 20140826085300) do

  create_table "api_keys", :force => true do |t|
    t.string   "access_token",                   :null => false
    t.boolean  "active",       :default => true, :null => false
    t.datetime "expires_at"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "virtual_domains", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "virtual_domain_aliases", :force => true do |t|
    t.integer  "virtual_domain_id"
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.index ["virtual_domain_id"], :name => "fk__virtual_domain_aliases_virtual_domain_id"
    t.foreign_key ["virtual_domain_id"], "virtual_domains", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_virtual_domain_aliases_virtual_domain_id"
  end

  create_view "domain_aliases_view", "select concat('@',`virtual_domain_aliases`.`name`) AS `source`,concat('@',`virtual_domains`.`name`) AS `destination` from `virtual_domain_aliases` join `virtual_domains` where (`virtual_domain_aliases`.`virtual_domain_id` = `virtual_domains`.`id`)", :force => true
  create_table "virtual_users", :force => true do |t|
    t.integer  "virtual_domain_id"
    t.string   "password"
    t.string   "name"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.integer  "quota",             :limit => 8,  :default => 100
    t.string   "host",              :limit => 15, :default => "192.168.108.5"
    t.index ["virtual_domain_id"], :name => "fk__virtual_users_virtual_domain_id"
    t.foreign_key ["virtual_domain_id"], "virtual_domains", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_virtual_users_virtual_domain_id"
  end

  create_table "virtual_user_aliases", :force => true do |t|
    t.integer  "virtual_user_id"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.index ["virtual_user_id"], :name => "fk__virtual_user_aliases_virtual_user_id"
    t.foreign_key ["virtual_user_id"], "virtual_users", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_virtual_user_aliases_virtual_user_id"
  end

  create_view "user_aliases_view", "select concat(`virtual_user_aliases`.`name`,'@',`virtual_domains`.`name`) AS `source`,concat(`virtual_users`.`name`,'@',`virtual_domains`.`name`) AS `destination` from `virtual_user_aliases` join `virtual_users` join `virtual_domains` where ((`virtual_users`.`virtual_domain_id` = `virtual_domains`.`id`) and (`virtual_user_aliases`.`virtual_user_id` = `virtual_users`.`id`))", :force => true
  create_view "users_view", "select concat(`virtual_users`.`name`,'@',`virtual_domains`.`name`) AS `email`,`virtual_users`.`password` AS `password`,`virtual_users`.`quota` AS `quota`,`virtual_users`.`host` AS `host` from `virtual_users` join `virtual_domains` where (`virtual_users`.`virtual_domain_id` = `virtual_domains`.`id`)", :force => true
  create_table "virtual_transports", :force => true do |t|
    t.string   "name"
    t.string   "destination"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
