class CreatePresentCoaches < ActiveRecord::Migration
  def change
    create_table :present_coaches do |t|
      t.float :salary_without_tax
      t.references :vat, index: true
      t.references :currency, index: true
      t.references :user, index: true
      t.references :training_lesson_realization, index: true
      t.boolean :supplementation, default: false

      t.timestamps
    end
  end
end
