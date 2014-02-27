# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Scapp::Application.initialize!

# Require menu - made this way because of need translations
require File.dirname(__FILE__) + '/initializers_late/advanced_menu'
