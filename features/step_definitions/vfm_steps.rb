When(/^Following measurements exists$/) do |table|
  # table is a | vf_name | int_value | str_value | locality | measured_at | for_user |
  table.hashes.each do |r|
    vf = VariableField.where(name: r[:vf_name]).first
    for_user = User.where(name: r[:for_user]).first
    by_user = User.where(name: r[:measured_by]).first

    FactoryGirl.create :variable_field_measurement, { int_value: r[:int_value], string_value: r[:str_value],
                                                      locality: r[:locality], measured_at: r[:measured_at],
                                                      variable_field: vf, measured_for: for_user, measured_by: by_user}
  end
end