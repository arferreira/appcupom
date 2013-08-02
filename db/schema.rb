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

ActiveRecord::Schema.define(:version => 20130710005527) do

  create_table "admin_roles", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "administrators", :force => true do |t|
    t.string   "name",               :null => false
    t.string   "email",              :null => false
    t.integer  "admin_role_id",      :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "encrypted_password"
    t.string   "salt"
  end

  add_index "administrators", ["admin_role_id"], :name => "index_administrators_on_Admin_Role_id"

  create_table "ads", :force => true do |t|
    t.string   "name",        :null => false
    t.date     "date_starts", :null => false
    t.date     "date_ends",   :null => false
    t.integer  "client_id",   :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "ads", ["client_id"], :name => "index_ads_on_client_id"

  create_table "badges", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "icon"
  end

  create_table "card_flags", :force => true do |t|
    t.string   "flag"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "code"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "icon"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.decimal  "latitude",   :precision => 15, :scale => 10
    t.decimal  "longitude",  :precision => 15, :scale => 10
    t.integer  "radius"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cupons", :force => true do |t|
    t.integer  "user_id",                                                    :null => false
    t.integer  "offer_id",                                                   :null => false
    t.decimal  "price",                       :precision => 8,  :scale => 2, :null => false
    t.string   "cupon_code",                                                 :null => false
    t.integer  "monthly_cupon_accounting_id",                                :null => false
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.date     "good_date"
    t.string   "transaction_id"
    t.boolean  "approved"
    t.string   "moip_id"
    t.string   "nasp_key"
    t.decimal  "bill_value",                  :precision => 8,  :scale => 2
    t.boolean  "validated"
    t.datetime "validated_date"
    t.decimal  "credit_discount",             :precision => 10, :scale => 0
    t.string   "moip_status"
  end

  add_index "cupons", ["monthly_cupon_accounting_id"], :name => "index_cupons_on_monthly_cupon_accounting_id"
  add_index "cupons", ["offer_id"], :name => "index_cupons_on_offer_id"
  add_index "cupons", ["user_id"], :name => "index_cupons_on_user_id"

  create_table "facilities", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "faqs", :force => true do |t|
    t.string   "question"
    t.text     "answer"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer  "me_id"
    t.integer  "friend_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "accepted"
    t.boolean  "facebook_friend"
  end

  create_table "mail_privacies", :force => true do |t|
    t.string   "description"
    t.boolean  "default"
    t.string   "user_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "monthly_cupon_accountings", :force => true do |t|
    t.string   "month_accounting",                                :null => false
    t.decimal  "total_value",      :precision => 10, :scale => 0, :null => false
    t.integer  "total_sold",                                      :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "offer_comments", :id => false, :force => true do |t|
    t.integer  "offer_id",   :null => false
    t.integer  "user_id",    :null => false
    t.text     "comment",    :null => false
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "offer_comments", ["offer_id"], :name => "index_offer_comments_on_offer_id"
  add_index "offer_comments", ["user_id"], :name => "index_offer_comments_on_user_id"

  create_table "offer_products", :force => true do |t|
    t.integer  "product_id",  :null => false
    t.integer  "offer_id",    :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "product_qty"
  end

  add_index "offer_products", ["offer_id"], :name => "index_offer_products_on_offer_id"
  add_index "offer_products", ["product_id"], :name => "index_offer_products_on_product_id"

  create_table "offer_rules", :force => true do |t|
    t.integer  "offer_id"
    t.integer  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "rule_id"
  end

  add_index "offer_rules", ["offer_id"], :name => "index_offer_rules_on_offer_id"

  create_table "offers", :force => true do |t|
    t.integer  "partner_id",                                                                                 :null => false
    t.text     "description",         :limit => 2147483647
    t.integer  "discount"
    t.decimal  "price",                                     :precision => 8, :scale => 2
    t.time     "time_starts"
    t.time     "time_ends"
    t.string   "recurrence"
    t.boolean  "active",                                                                  :default => true
    t.datetime "created_at",                                                                                 :null => false
    t.datetime "updated_at",                                                                                 :null => false
    t.datetime "start_date"
    t.string   "ttype"
    t.integer  "partner_pic1_id"
    t.integer  "partner_pic2_id"
    t.integer  "partner_pic3_id"
    t.integer  "main_pic"
    t.integer  "cupon_counter"
    t.string   "temp_distance"
    t.integer  "city_id"
    t.integer  "daily_cupons"
    t.decimal  "original_price",                            :precision => 8, :scale => 2
    t.boolean  "paused"
    t.string   "company_name"
    t.boolean  "deleted",                                                                 :default => false, :null => false
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.date     "end_date"
  end

  add_index "offers", ["partner_id"], :name => "index_offers_on_partner_id"

  create_table "partner_categories", :id => false, :force => true do |t|
    t.integer "partner_id"
    t.integer "category_id"
  end

  add_index "partner_categories", ["category_id", "partner_id"], :name => "index_partner_categories_on_category_id_and_partner_id"
  add_index "partner_categories", ["partner_id", "category_id"], :name => "index_partner_categories_on_partner_id_and_category_id"

  create_table "partner_comments", :id => false, :force => true do |t|
    t.integer  "partner_id", :null => false
    t.integer  "user_id",    :null => false
    t.text     "comment",    :null => false
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "partner_comments", ["partner_id"], :name => "index_partner_comments_on_partner_id"
  add_index "partner_comments", ["user_id"], :name => "index_partner_comments_on_user_id"

  create_table "partner_facilities", :id => false, :force => true do |t|
    t.integer  "partner_id",  :null => false
    t.integer  "facility_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "partner_facilities", ["facility_id"], :name => "index_partner_facilities_on_facility_id"
  add_index "partner_facilities", ["partner_id"], :name => "index_partner_facilities_on_partner_id"

  create_table "partner_payment_options", :id => false, :force => true do |t|
    t.integer "partner_id"
    t.integer "payment_option_id"
  end

  add_index "partner_payment_options", ["partner_id"], :name => "index_partner_payment_options_on_partner_id"
  add_index "partner_payment_options", ["payment_option_id"], :name => "index_partner_payment_options_on_payment_option_id"

  create_table "partner_pics", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "partner_id"
    t.string   "pic_type",           :limit => 1
  end

  add_index "partner_pics", ["partner_id"], :name => "index_partner_pics_on_partner_id"

  create_table "partner_recommendations", :id => false, :force => true do |t|
    t.integer  "partner_id",        :null => false
    t.integer  "recommendation_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "partner_recommendations", ["partner_id"], :name => "index_partner_recommendations_on_partner_id"
  add_index "partner_recommendations", ["recommendation_id"], :name => "index_partner_recommendations_on_recommendation_id"

  create_table "partners", :force => true do |t|
    t.string   "company_name",                                                              :null => false
    t.string   "trade_name",                                                                :null => false
    t.string   "site"
    t.string   "email",                                                                     :null => false
    t.string   "primary_phone",                                                             :null => false
    t.string   "secondary_phone"
    t.string   "facebook_link"
    t.string   "twitter_link"
    t.integer  "cnpj",                                                                      :null => false
    t.text     "description"
    t.date     "foundation"
    t.decimal  "latitude",               :precision => 15, :scale => 10,                    :null => false
    t.decimal  "longitude",              :precision => 15, :scale => 10,                    :null => false
    t.integer  "capacity",                                                                  :null => false
    t.boolean  "active",                                                 :default => true
    t.boolean  "approved",                                               :default => false
    t.integer  "administrator_id"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.string   "contact_name"
    t.boolean  "has_internet"
    t.string   "client_age"
    t.string   "average_consumption"
    t.string   "got_to_know"
    t.integer  "sub_category_id"
    t.string   "encrypted_password"
    t.string   "salt"
    t.integer  "system_profit"
    t.string   "address"
    t.string   "temp_distance"
    t.string   "working_schedule"
    t.integer  "city_id"
    t.integer  "category_id"
    t.string   "add_number"
    t.string   "add_complement"
    t.string   "add_county"
    t.string   "add_state"
    t.string   "cep"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "partners", ["administrator_id"], :name => "index_partners_on_administrator_id"
  add_index "partners", ["category_id"], :name => "index_partners_on_category_id"
  add_index "partners", ["sub_category_id"], :name => "index_partners_on_sub_category_id"

  create_table "payment_options", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "privacies", :force => true do |t|
    t.string   "description"
    t.boolean  "default"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "user_type",   :limit => 2
  end

  create_table "product_families", :force => true do |t|
    t.string   "name"
    t.integer  "partner_id"
    t.integer  "product_type_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "active",          :default => true
  end

  add_index "product_families", ["partner_id"], :name => "index_product_families_on_partner_id"
  add_index "product_families", ["product_type_id"], :name => "index_product_families_on_product_type_id"

  create_table "product_types", :force => true do |t|
    t.string   "name",                         :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "partner_id"
    t.boolean  "public"
    t.boolean  "active",     :default => true
  end

  add_index "product_types", ["partner_id"], :name => "index_product_types_on_partner_id"

  create_table "products", :force => true do |t|
    t.string   "name",                                                              :null => false
    t.text     "description"
    t.decimal  "price",             :precision => 8, :scale => 2,                   :null => false
    t.boolean  "active",                                          :default => true
    t.integer  "partner_id",                                                        :null => false
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.integer  "product_family_id"
    t.integer  "product_type_id"
  end

  add_index "products", ["partner_id"], :name => "index_products_on_partner_id"
  add_index "products", ["product_family_id"], :name => "index_products_on_product_family_id"
  add_index "products", ["product_type_id"], :name => "index_products_on_product_type_id"

  create_table "rec_offer_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "recommend_offer_id"
    t.text     "opinion"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "rec_partner_comments", :force => true do |t|
    t.integer  "recommend_partner_id"
    t.integer  "user_id"
    t.text     "opinion"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "rec_partner_comments", ["recommend_partner_id"], :name => "index_rec_partner_comments_on_recommend_partner_id"
  add_index "rec_partner_comments", ["user_id"], :name => "index_rec_partner_comments_on_user_id"

  create_table "rec_product_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "recommend_product_id"
    t.text     "opinion"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "rec_product_comments", ["recommend_product_id"], :name => "index_rec_product_comments_on_recommend_product_id"
  add_index "rec_product_comments", ["user_id"], :name => "index_rec_product_comments_on_user_id"

  create_table "receipts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "offer_id"
    t.decimal  "value",         :precision => 8, :scale => 2
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "partner_id"
    t.string   "description"
    t.decimal  "nowon_price",   :precision => 8, :scale => 2
    t.decimal  "partner_price", :precision => 8, :scale => 2
    t.decimal  "credit",        :precision => 8, :scale => 2
    t.integer  "discount"
    t.boolean  "migrated"
  end

  add_index "receipts", ["offer_id"], :name => "index_receipts_on_offer_id"
  add_index "receipts", ["user_id"], :name => "index_receipts_on_user_id"

  create_table "recommend_offers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "offer_id"
    t.text     "opinion"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "recommend_offers", ["offer_id"], :name => "index_recommend_offers_on_offer_id"
  add_index "recommend_offers", ["user_id"], :name => "index_recommend_offers_on_user_id"

  create_table "recommend_partners", :force => true do |t|
    t.integer  "user_id"
    t.integer  "partner_id"
    t.text     "opinion"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "recommend_partners", ["partner_id"], :name => "index_recommend_partners_on_partner_id"
  add_index "recommend_partners", ["user_id"], :name => "index_recommend_partners_on_user_id"

  create_table "recommend_products", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.text     "opinion"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "recommend_products", ["product_id"], :name => "index_recommend_products_on_product_id"
  add_index "recommend_products", ["user_id"], :name => "index_recommend_products_on_user_id"

  create_table "recommendations", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rules", :force => true do |t|
    t.string   "description"
    t.string   "offer_type"
    t.string   "ttype"
    t.string   "default"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "resume"
  end

  create_table "social_links", :force => true do |t|
    t.string   "username"
    t.string   "social_id",          :null => false
    t.string   "social_type",        :null => false
    t.string   "image_url"
    t.string   "access_toke_secret"
    t.integer  "user_id",            :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "access_token"
  end

  add_index "social_links", ["user_id"], :name => "index_social_links_on_user_id"

  create_table "timeline_items", :force => true do |t|
    t.integer  "user_id"
    t.string   "item_type"
    t.integer  "item_count"
    t.integer  "recommend_partner_id"
    t.integer  "recommend_product_id"
    t.integer  "wish_product_id"
    t.integer  "wish_product_comment_id"
    t.integer  "offer_id"
    t.integer  "product_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "rec_product_comment_id"
    t.integer  "rec_partner_comment_id"
    t.integer  "badge_id"
    t.integer  "friend_id"
    t.integer  "recommend_offer_id"
    t.integer  "rec_offer_comment_id"
  end

  add_index "timeline_items", ["offer_id"], :name => "index_timeline_items_on_offer_id"
  add_index "timeline_items", ["product_id"], :name => "index_timeline_items_on_product_id"
  add_index "timeline_items", ["rec_partner_comment_id"], :name => "index_timeline_items_on_rec_partner_comment_id"
  add_index "timeline_items", ["rec_product_comment_id"], :name => "index_timeline_items_on_rec_product_comment_id"
  add_index "timeline_items", ["recommend_partner_id"], :name => "index_timeline_items_on_recommend_partner_id"
  add_index "timeline_items", ["recommend_product_id"], :name => "index_timeline_items_on_recommend_product_id"
  add_index "timeline_items", ["user_id"], :name => "index_timeline_items_on_user_id"
  add_index "timeline_items", ["wish_product_comment_id"], :name => "index_timeline_items_on_wish_product_comment_id"
  add_index "timeline_items", ["wish_product_id"], :name => "index_timeline_items_on_wish_product_id"

  create_table "timeline_readers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "timeline_item_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "timeline_readers", ["timeline_item_id"], :name => "index_timeline_readers_on_timeline_item_id"
  add_index "timeline_readers", ["user_id"], :name => "index_timeline_readers_on_user_id"

  create_table "user_badges", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "badge_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_badges", ["badge_id"], :name => "index_user_badges_on_badge_id"
  add_index "user_badges", ["user_id"], :name => "index_user_badges_on_user_id"

  create_table "user_cards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "card_flag_id"
    t.string   "secure_code"
    t.string   "logradouro"
    t.string   "numero"
    t.string   "complemento"
    t.string   "bairro"
    t.string   "cidade"
    t.string   "estado"
    t.string   "cep"
    t.string   "telefone"
    t.string   "key"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
    t.string   "card_number"
    t.string   "cpf"
    t.string   "birthdate"
    t.boolean  "save_card"
  end

  add_index "user_cards", ["card_flag_id"], :name => "index_user_cards_on_card_flag_id"
  add_index "user_cards", ["user_id"], :name => "index_user_cards_on_user_id"

  create_table "user_credits", :force => true do |t|
    t.integer  "user_id"
    t.string   "reason"
    t.decimal  "value",         :precision => 10, :scale => 0
    t.decimal  "current_value", :precision => 10, :scale => 0
    t.boolean  "active"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "user_credits", ["user_id"], :name => "index_user_credits_on_user_id"

  create_table "user_mail_privacies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "mail_privacy_id"
    t.boolean  "choice"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "user_mail_privacies", ["mail_privacy_id"], :name => "index_user_mail_privacies_on_mail_privacy_id"
  add_index "user_mail_privacies", ["user_id"], :name => "index_user_mail_privacies_on_user_id"

  create_table "user_privacies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "privacy_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "nowon",      :default => false, :null => false
    t.boolean  "twitter"
    t.boolean  "facebook"
  end

  add_index "user_privacies", ["privacy_id"], :name => "index_user_privacies_on_privacy_id"
  add_index "user_privacies", ["user_id"], :name => "index_user_privacies_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                                     :null => false
    t.string   "email",                                    :null => false
    t.date     "dob"
    t.string   "gender"
    t.boolean  "active",                 :default => true
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
  end

  create_table "wish_product_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "wish_product_id"
    t.text     "opinion"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "wish_product_comments", ["user_id"], :name => "index_wish_product_comments_on_user_id"
  add_index "wish_product_comments", ["wish_product_id"], :name => "index_wish_product_comments_on_wish_product_id"

  create_table "wish_products", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.text     "opinion"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "wish_products", ["product_id"], :name => "index_wish_products_on_product_id"
  add_index "wish_products", ["user_id"], :name => "index_wish_products_on_user_id"

end
