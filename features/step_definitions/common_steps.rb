Then(/^I should see "([^"]*)" message$/) do |message|
  find('.alert').should have_content message
end