require "spec_helper"

describe VariableFieldCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/variable_field_categories").should route_to("variable_field_categories#index")
    end

    it "routes to #new" do
      get("/variable_field_categories/new").should route_to("variable_field_categories#new")
    end

    it "routes to #show" do
      get("/variable_field_categories/1").should route_to("variable_field_categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/variable_field_categories/1/edit").should route_to("variable_field_categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/variable_field_categories").should route_to("variable_field_categories#create")
    end

    it "routes to #update" do
      put("/variable_field_categories/1").should route_to("variable_field_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/variable_field_categories/1").should route_to("variable_field_categories#destroy", :id => "1")
    end

  end
end
