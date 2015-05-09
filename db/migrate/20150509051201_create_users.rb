class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps null: false
	  t.string   "first_name",          limit: 255
	  t.string   "last_name",           limit: 255
	  t.string   "email",               limit: 255
	  t.string   "phone_number",        limit: 10
	  t.string   "address",             limit: 255
	  t.string   "vehicle_number",      limit: 255
	  t.string   "crypted_password",    limit: 255
	  t.string   "password_salt",       limit: 255
	  t.string   "persistence_token",   limit: 255
	  t.string   "single_access_token", limit: 255
	  t.string   "perishable_token",    limit: 255
	  t.boolean  "deliverer",           limit: 1,   default: false
	  t.datetime "created_at"
	  t.datetime "updated_at"
    end
    add_index :users, :email
    add_index :users, :phone_number
  end
end