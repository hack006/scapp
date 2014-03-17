crumb :root do
  link t('breadcrumbs.home'), root_path
end

# =====
# User
# =====
crumb :user do |user|
  link t('breadcrumbs.user'), user_path(user)
end

crumb :users do
  link t('breadcrumbs.users'), users_path
end

crumb :user_new do
  link t('breadcrumbs.new_user')
  parent :users
end

# ================
# VariableFields
# ================
crumb :variable_fields do
  link t('breadcrumbs.variable_fields'), variable_fields_path
end

crumb :variable_field do
  link t('breadcrumbs.variable_field_detail')
  parent :variable_fields
end

crumb :variable_field_edit do
  link t('breadcrumbs.edit_variable_field')
  parent :variable_fields
end

crumb :user_variable_fields do |user|
  link t('breadcrumbs.variable_fields'), user_variable_fields_path
  parent :user, user
end

crumb :user_variable_field_detail do |user|
  link t('breadcrumbs.variable_field')
  parent :user_variable_fields, user
end

crumb :variable_field_new do
  link t('breadcrumbs.new_variable_field'), new_variable_field_path
  parent :variable_fields
end

# ========================
# VariableFieldMeasurement
# ========================
crumb :variable_field_measurements do
  link t('breadcrumbs.vf_measurements'), variable_field_measurements_path
end

crumb :variable_field_user_measurements do |user|
  link t('breadcrumbs.vf_user_measurements'), variable_field_measurements_path
end

crumb :variable_field_measurement_new do
  link t('breadcrumbs.new_vf_measurement')
  parent :variable_field_measurements
end

crumb :variable_field_new_for_user do |user|
  link t('breadcrumbs.new_variable_field_measurement')
  parent :user_variable_fields, user
end

crumb :variable_field_measurement_detail do |user|
  link t('breadcrumbs.vf_measurement_detail')
  parent :variable_field_user_measurements, user
end

crumb :variable_field_measurement_edit do |user|
  link t('breadcrumbs.edit_vf_measurement')
  parent :variable_field_user_measurements, user
end

# ========================
# VariableFieldCategories
# ========================
crumb :variable_field_categories do
  link t('breadcrumbs.variable_field_categories'), variable_field_categories_path
end

crumb :variable_field_categories_new do
  link t('breadcrumbs.new_variable_field_category'), new_variable_field_category_path
  parent :variable_field_categories
end

# ========================
# VariableFieldUserLevels
# ========================
crumb :variable_field_user_levels do
  link t('breadcrumbs.variable_field_user_levels'), variable_field_user_levels_path
end

crumb :variable_field_user_levels_new do
  link t('breadcrumbs.new_variable_field_user_level'), new_variable_field_user_level_path
  parent :variable_field_user_levels
end

# ====================
# VariableFieldSports
# ====================
crumb :variable_field_sports do
  link t('breadcrumbs.variable_field_sports'), variable_field_sports_path
end

crumb :variable_field_sports_new do
  link t('breadcrumbs.new_variable_field_sport'), new_variable_field_sport_path
  parent :variable_field_sports
end

# ===========
# UserGroups
# ===========
crumb :user_groups do
  link (t('breadcrumbs.user_groups')), user_groups_path
end

crumb :user_groups_user_in do |user|
  link t('breadcrumbs.in_groups')
  parent :user, user
end

crumb :user_groups_new do
  link t('breadcrumbs.new_group')
  parent :user_groups
end

# ==============
# UserRelations
# ==============
crumb :user_relations do
  link t('breadcrumbs.user_relations'), user_relations_path
end

crumb :user_relations_user_has do |user|
  link (t('breadcrumbs.has_relations'))
  parent :user, user
end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).