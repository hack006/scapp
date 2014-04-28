class Payment < ActiveRecord::Base
  belongs_to :currency
  belongs_to :received_by
end
