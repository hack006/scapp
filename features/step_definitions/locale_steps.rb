And(/^Locale "([^"]*)" exists$/) do |code|
  Locale.create!(name: "Locale #{code}", code: code)
end