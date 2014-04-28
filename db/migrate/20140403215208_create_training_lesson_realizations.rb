class CreateTrainingLessonRealizations < ActiveRecord::Migration
  def change
    create_table :training_lesson_realizations do |t|
      t.string :slug
      t.date :date
      t.time :from
      t.time :until
      t.float :player_price_without_tax
      t.float :group_price_without_tax
      t.float :rental_price_without_tax
      t.string :calculation
      t.string :status
      t.text :note
      t.references :training_vat, index: true
      t.references :rental_vat, index: true
      t.references :currency, index: true
      t.references :training_lesson, index: true
      t.references :user, index: true

      t.timestamps
    end

    add_index :training_lesson_realizations, :slug, unique: true
  end
end
