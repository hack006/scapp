class VariableField < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :user
  belongs_to :variable_field_category
  has_many :variable_field_measurements, dependent: :restrict_with_exception
  has_many :variable_field_optimal_values, dependent: :destroy

  # =================== VALIDATIONS ==================================
  validates :name, length: 1..64
  validates_uniqueness_of :name, scope: [:variable_field_category_id, :user_id]
  validates :variable_field_category, presence: true

  # =================== EXTENSIONS ===================================
  attr_accessor :modification_confirmation
  scope :global_or_owned_by, ->(user) { where("variable_fields.is_global = true or variable_fields.user_id = ?", user) }
  scope :with_measurements_for, ->(user) { joins(:variable_field_measurements).where(variable_field_measurements: {measured_for_id: user}) }
  scope :order_by_categories, -> { joins('LEFT JOIN variable_field_categories ON variable_fields.variable_field_category_id = variable_field_categories.id').order('variable_field_categories.name DESC') }

  # =================== GETTERS / SETTERS ============================

  # =================== METHODS ======================================
  def latest_measurement(user = nil)
    if user.kind_of? User
      lm = self.variable_field_measurements.order(measured_at: :desc).where(measured_for_id: user).first
    else
      lm = self.variable_field_measurements.order(measured_at: :desc).first
    end

    lm
  end

  # Todo: include higher_is_better
  def best_measurement(user = nil)
    raise 'Not a numeric variable field. Can\'t take best value!' unless self.is_numeric

    bm = self.variable_field_measurements.order(int_value: (self.higher_is_better? ? :desc : :asc) )
    bm = bm.where(measured_for_id: user) if user.kind_of?(User)

    bm.first
  end

  # Todo: include higher_is_better
  def worst_measurement(user = nil)
    raise 'Not a numeric variable field. Can\'t take best value!' unless self.is_numeric

    bm = self.variable_field_measurements.order(int_value: (self.higher_is_better? ? :asc : :desc) )
    bm = bm.where(measured_for_id: user) if user.kind_of?(User)

    bm.first
  end

  # Get latest measurements
  #
  # _User_ can be specified to limit result for only his records. Paging supported by combination of _page_ and _limit_.
  #
  # @param [int] page Page number
  # @param [int] limit Row fetch count
  # @param [User|int] user Limit result for records of _user_ (or user_id)
  #
  # @return [ActiveRecord::Relation] query result
  def latest_measurements(page = 1, limit = 20, user = nil)
    paged_measurements :measured_at, user, page, limit, :desc
  end

  def has_to_confirm_edit?
    (variable_field_measurements.count > 0) ? true : false
  end

  def confirmation_token
    Digest::MD5.hexdigest(attributes.to_s).gsub(/[^[0-9]]/, "")[0..5]
  end


  private

  def paged_measurements(sort_by, user, page = 1, limit = 20, direction = :asc)
    raise Exception, 'Column you want to sort by is not available!' unless self.variable_field_measurements.first.has_attribute?(sort_by)

    # TODO: self modifying where!() seems to doesn't work :/
    res =  self.variable_field_measurements
    .limit(limit)
    .offset((page - 1) * limit)
    .order("#{sort_by}" => direction)
    .where(measured_for_id: user)

    res = res.where(measured_for_id: user) unless user.kind_of?(User) || user.kind_of?(Fixnum)

    res
  end
end
