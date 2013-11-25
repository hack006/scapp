require "spec_helper"

describe VariableFieldOptimalValuesController do
  describe "routing" do

    it "routes to #index" do
      get("/variable_field_optimal_values").should route_to("variable_field_optimal_values#index")
    end

    it "routes to #new" do
      get("/variable_field_optimal_values/new").should route_to("variable_field_optimal_values#new")
    end

    it "routes to #show" do
      get("/variable_field_optimal_values/1").should route_to("variable_field_optimal_values#show", :id => "1")
    end

    it "routes to #edit" do
      get("/variable_field_optimal_values/1/edit").should route_to("variable_field_optimal_values#edit", :id => "1")
    end

    it "routes to #create" do
      post("/variable_field_optimal_values").should route_to("variable_field_optimal_values#create")
    end

    it "routes to #update" do
      put("/variable_field_optimal_values/1").should route_to("variable_field_optimal_values#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/variable_field_optimal_values/1").should route_to("variable_field_optimal_values#destroy", :id => "1")
    end

  end
end
