crumb :root do
  link t('breadcrumbs.home'), root_path
end

crumb :user do |user|
  link t('breadcrumbs.user'), user_path(user)
end

# ================
# VariableFields
# ================
crumb :user_variable_fields do |user|
  link t('breadcrumbs.variable_fields'), user_variable_fields_path
  parent :user, user
end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).