class CreateRequests < ActiveRecord::Migration
  def up
	create_table :requests do |t|
      t.integer :requester_id
      t.integer :device_id
      t.integer :pickup_location_id
      t.integer :drop_location_id
      t.decimal :distance, :precision => 15, :scale => 2, :default => 0.0
      t.string  :status
      t.text    :nearest_deliverers
      t.timestamps
    end
  end
end
