And(/^I should see measurement with value "([^"]*)"$/) do |vf_value|
  found = false
  all(:css, '.vfm td.value').each do |v|
    if v.has_text? vf_value
      found = true
      break
    end
  end

  found.should be_true
end

And(/^I shouldn't see measurement with value "([^"]*)"$/) do |vf_value|
  found = false
  all(:css, '.vfm td.value').each do |v|
    if v.has_text? vf_value
      found = true
      break
    end
  end

  found.should be_false
end