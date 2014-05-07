# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
Scapp::Application.initialize!

# Require menu - made this way because of need translations
require File.dirname(__FILE__) + '/initializers_late/advanced_menu'
