And(/^Following VATs exists$/) do |table|
  # table is a table.hashes.keys # => [:name, :value, :is_time_limited, :start_of_validity, :end_of_validity]
  table.hashes.each do |f|
    Vat.create({name: f[:name], percentage_value: f[:value], is_time_limited: f[:is_time_limited],
                start_of_validity: f[:start_of_validity], end_of_validity: f[:end_of_validity]})
    end
end

And(/^I fill in all necessary VATs fields$/) do |table|
  # table is a table.hashes.keys # => [:name, :value, :is_time_limited, :start_of_validity, :end_of_validity]
  f = table.hashes.first
  fill_in 'vat_name', with: f[:name]
  fill_in 'Percentage value', with: f[:value]
  check 'Is time limited' if f[:is_time_limited] == 'true'
  fill_in 'Start of validity', with: f[:start_of_validity]
  fill_in 'End of validity', with: f[:end_of_validity]
end

And(/^I fill in all fields to change VATs fields$/) do |table|
  # table is a table.hashes.keys # => [:name, :value, :is_time_limited, :start_of_validity, :end_of_validity]
  f = table.hashes.first
  fill_in 'vat_name', with: f[:name] if f[:name]
  fill_in 'Percentage value', with: f[:value] if f[:value]
  check 'Is time limited' if f[:is_time_limited] && f[:is_time_limited] == 'true'
  fill_in 'Start of validity', with: f[:start_of_validity] if f[:start_of_validity]
  fill_in 'End of validity', with: f[:end_of_validity] if f[:end_of_validity]
end