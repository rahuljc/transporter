class CreateEngagedDeliverers < ActiveRecord::Migration
  def change
    create_table :engaged_deliverers do |t|
      t.integer :request_id
      t.integer :device_id
      t.timestamps
    end
  end
end
