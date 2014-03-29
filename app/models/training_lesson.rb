class TrainingLesson < ActiveRecord::Base
  belongs_to :training_vat, class_name: Vat
  belongs_to :rental_vat, class_name: Vat
  belongs_to :regular_training
end
