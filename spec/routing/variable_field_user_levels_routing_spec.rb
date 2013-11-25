require "spec_helper"

describe VariableFieldUserLevelsController do
  describe "routing" do

    it "routes to #index" do
      get("/variable_field_user_levels").should route_to("variable_field_user_levels#index")
    end

    it "routes to #new" do
      get("/variable_field_user_levels/new").should route_to("variable_field_user_levels#new")
    end

    it "routes to #show" do
      get("/variable_field_user_levels/1").should route_to("variable_field_user_levels#show", :id => "1")
    end

    it "routes to #edit" do
      get("/variable_field_user_levels/1/edit").should route_to("variable_field_user_levels#edit", :id => "1")
    end

    it "routes to #create" do
      post("/variable_field_user_levels").should route_to("variable_field_user_levels#create")
    end

    it "routes to #update" do
      put("/variable_field_user_levels/1").should route_to("variable_field_user_levels#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/variable_field_user_levels/1").should route_to("variable_field_user_levels#destroy", :id => "1")
    end

  end
end
