class CreateReceivers < ActiveRecord::Migration
  def up
    create_table :receivers do |t|
      t.integer :request_id
      t.string  :name
      t.string :phone_number, :limit => 10
      t.string  :passcode, :limit => 6
      t.string  :order_id

      t.timestamps
    end
  end
end
