class Settings < Settingslogic
  source "#{Rails.root}/config/scapp.yml"
  namespace Rails.env
end