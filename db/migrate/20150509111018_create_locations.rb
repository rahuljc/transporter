class CreateLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.integer :request_id
      t.decimal :lattitude, :precision => 13, :scale => 10, :default => 0.0
      t.decimal :longitude, :precision => 13, :scale => 10, :default => 0.0
      t.string  :address
      t.timestamps
    end
  end
end
