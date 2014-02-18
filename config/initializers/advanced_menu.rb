require 'advanced_menu/advanced_menu'
AdvancedMenu::Menu.setup do |config|
  config.name = 'name'

  config.add_heading('User', '/users', 'users', nil, %w(fa fa-angle-double-right)) do |h|
    h.add_link('New user', '/users/new','users', 'new', %w(fa fa-plus), [:coach, :admin])
    h.add_link('My groups', '/user_groups/in', 'user_groups', 'in', %w(fa fa-group))
    h.add_link('My relations', '/user_relations/in', 'user_relations', 'in', %w(fa fa-random))
    h.add_link('Groups', '/user_groups', 'user_groups', nil, %w(fa fa-users), :admin)
    h.add_link('New group', '/user_groups/new', 'user_groups', 'new', %w(fa fa-plus), [:coach, :admin])
    h.add_link('Relations', '/user_relations', 'user_relations', nil, %w(fa fa-random), :admin)
    # h.add_link('New relation', '/relations/new', %w(fa fa-plus) :admin)
  end

end