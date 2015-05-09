class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :user_id
      t.string  :device_uuid
      t.timestamps
    end
  end
end
