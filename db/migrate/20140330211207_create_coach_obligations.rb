class CreateCoachObligations < ActiveRecord::Migration
  def change
    create_table :coach_obligations do |t|
      t.float :hourly_wage_without_vat
      t.column :role, "ENUM('coach', 'head_coach')", null: false, default: 'coach'
      t.references :vat, index: true, null: false
      t.references :currency, index: true, null: false
      t.references :user, index: true, null: false
      t.references :regular_training, index: true, null: false

      t.timestamps
    end

    add_index :coach_obligations, [:user_id, :regular_training_id], unique: true
  end
end
