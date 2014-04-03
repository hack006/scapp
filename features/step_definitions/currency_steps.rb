And(/^Following currencies exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:name, :code, :symbol]
  table.hashes.each do |c|
    Currency.create(name: c[:name], code: c[:code], symbol: c[:symbol])
  end
end