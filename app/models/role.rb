class Role < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  # =================== VALIDATIONS ==================================

  # =================== EXTENSIONS ===================================
  scopify

  # =================== GETTERS / SETTERS ============================

  # =================== METHODS ======================================

end
