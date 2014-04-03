Time.class_eval do
  # Return time without seconds
  #
  # @return [String] hh:mm
  def short
    self.to_formatted_s(:time)
  end

  # Return time with seconds
  #
  # @return [String] hh:mm:ss
  def full
    self.to_formatted_s(:time_full)
  end
end