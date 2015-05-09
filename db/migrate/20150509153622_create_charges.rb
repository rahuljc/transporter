class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.decimal :deliverer_rate, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :requester_rate, :precision => 10, :scale => 2, :default => 0.0
    end
  end
end
