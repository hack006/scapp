class Payment < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :currency
  belongs_to :received_by

  # =================== VALIDATIONS ==================================
  validates :currency_id, presence: true
  validates :received_by_id, presence: true

  # =================== EXTENSIONS ===================================

  # =================== GETTERS / SETTERS ============================

  # =================== METHODS ======================================

end