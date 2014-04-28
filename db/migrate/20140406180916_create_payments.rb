class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.float :amount
      t.column :status, "ENUM('waiting_payment', 'paid')", default: 'waiting_payment', null: false
      t.references :currency, index: true, null: false
      t.integer :received_by_id

      t.timestamps
    end

    add_index :payments, :received_by_id
  end
end
