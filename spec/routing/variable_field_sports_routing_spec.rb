require "spec_helper"

describe VariableFieldSportsController do
  describe "routing" do

    it "routes to #index" do
      get("/variable_field_sports").should route_to("variable_field_sports#index")
    end

    it "routes to #new" do
      get("/variable_field_sports/new").should route_to("variable_field_sports#new")
    end

    it "routes to #show" do
      get("/variable_field_sports/1").should route_to("variable_field_sports#show", :id => "1")
    end

    it "routes to #edit" do
      get("/variable_field_sports/1/edit").should route_to("variable_field_sports#edit", :id => "1")
    end

    it "routes to #create" do
      post("/variable_field_sports").should route_to("variable_field_sports#create")
    end

    it "routes to #update" do
      put("/variable_field_sports/1").should route_to("variable_field_sports#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/variable_field_sports/1").should route_to("variable_field_sports#destroy", :id => "1")
    end

  end
end
