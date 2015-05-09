class CreateCurrentLocations < ActiveRecord::Migration
  def up
    create_table :current_locations do |t|
      t.decimal :lattitude, :precision => 13, :scale => 10, :default => 0.0
      t.decimal :longitude, :precision => 13, :scale => 10, :default => 0.0
      t.integer :device_id
      t.timestamps
    end
  end
end
