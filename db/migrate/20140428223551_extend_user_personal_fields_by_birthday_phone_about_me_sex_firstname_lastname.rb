class ExtendUserPersonalFieldsByBirthdayPhoneAboutMeSexFirstnameLastname < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :sex, 'ENUM("male", "female")'
    add_column :users, :handedness, 'ENUM("left_handed", "right_handed", "universal")'
    add_column :users, :birthday, :date
    add_column :users, :phone, :string
    add_column :users, :about_me, :text
    add_column :users, :city, :string
    add_column :users, :street, :string
    add_column :users, :post_code, :string
  end
end
