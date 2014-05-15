And(/^Following currencies exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:name, :code, :symbol]
  table.hashes.each do |c|
    Currency.create(name: c[:name], code: c[:code], symbol: c[:symbol])
  end
end

When(/^I fill all required fields for currency$/) do |table|
  # table is a table.hashes.keys # => [:name, :code, :symbol]
  c = table.hashes.first

  fill_in 'currency_name', with: c[:name]
  fill_in 'currency_code', with: c[:code]
  fill_in 'currency_symbol', with: c[:symbol]
end

And(/^I click New currency in action box$/) do
  within('#action-box') do
    click_link  'New currency'
  end
end