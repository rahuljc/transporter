class CreateDelivererPayments < ActiveRecord::Migration
  def change
    create_table :deliverer_payments do |t|
      t.integer :request_id
      t.integer :deliverer_id
      t.decimal :amount, :precision => 5, :scale => 2, :default => 0.0
      t.string  :status
      t.timestamps
    end
  end
end
