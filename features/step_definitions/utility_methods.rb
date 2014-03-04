### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :name => "test1", :email => "example@example.com",
                 :password => "changeme", :password_confirmation => "changeme" }
end

def create_visitor2
  @visitor2 ||= { :name => "test2", :email => "example2@example.com",
                 :password => "changeme", :password_confirmation => "changeme" }
end

def find_user
  @user ||= User.first conditions: {:email => @visitor[:email]}
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  visit '/signout'
end

def create_user
  if @user.blank?
    create_visitor
    delete_user
    @user = FactoryGirl.create(:player, email: @visitor[:email], name: @visitor[:name])
  end
end

def create_user2
  if @user2.blank?
    create_visitor2
    delete_user2
    @user2 = FactoryGirl.create(:player, email: @visitor2[:email], name: @visitor2[:name])
  end
end

def delete_user
  @user ||= User.first conditions: {:email => @visitor[:email]}
  @user.destroy unless @user.nil?
end

def delete_user2
  @user2 ||= User.first conditions: {:email => @visitor2[:email]}
  @user2.destroy unless @user2.nil?
end

def sign_up
  delete_user
  visit '/users/sign_up'
  fill_in "Name", :with => @visitor[:name]
  fill_in "Email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
  click_button "Sign up"
  find_user
end

def sign_in
  visit '/signin'
  fill_in "Email", :with => @visitor[:email]
  fill_in "Password", :with => @visitor[:password]
  click_button "Sign me in"
end

def add_coach_role
  @user.add_role :coach
end