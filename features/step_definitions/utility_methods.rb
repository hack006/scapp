### UTILITY METHODS ###


def create_visitor(id)
  @visitor ||= Array.new
  @visitor[id] ||= { :name => "test#{id}", :email => "example#{id}@example.com",
                 :password => "changeme", :password_confirmation => "changeme" }
end

def find_user(id)
  @user ||= Array.new
  @user[id] ||= User.first conditions: {:email => @visitor[id][:email]}
end

def create_unconfirmed_user(id)
  create_visitor(id)
  delete_user(id)
  sign_up(id)
  visit '/sign_out'
end

def create_user(id)
  @user ||= Array.new

  if @user[id].nil?
    create_visitor(id)
    delete_user(id)
    @user[id] = FactoryGirl.create(:player, email: @visitor[id][:email], name: @visitor[id][:name])
  end
end

def delete_user(id)
  @visitor ||= Array.new
  @user ||= Array.new
  @user[id] ||= User.first conditions: {:email => @visitor[id][:email]}
  @user[id].destroy unless @user[id].nil?
end

def sign_up(id)
  delete_user(id)
  visit '/sign_up'
  fill_in "Name", :with => @visitor[id][:name]
  fill_in "Email", :with => @visitor[id][:email]
  fill_in "user_password", :with => @visitor[id][:password]
  fill_in "user_password_confirmation", :with => @visitor[id][:password_confirmation]
  click_button "Sign up"
  find_user(id)
end

def sign_in(id)
  visit '/sign_in'
  fill_in "Email", :with => @visitor[id][:email]
  fill_in "Password", :with => @visitor[id][:password]
  click_button "Sign me in"
end

def add_coach_role(id)
  @user[id].add_role :coach
end