require "spec_helper"

describe VariableFieldMeasurementsController do
  describe "routing" do

    it "routes to #index" do
      get("/variable_field_measurements").should route_to("variable_field_measurements#index")
    end

    it "routes to #new" do
      get("/variable_field_measurements/new").should route_to("variable_field_measurements#new")
    end

    it "routes to #show" do
      get("/variable_field_measurements/1").should route_to("variable_field_measurements#show", :id => "1")
    end

    it "routes to #edit" do
      get("/variable_field_measurements/1/edit").should route_to("variable_field_measurements#edit", :id => "1")
    end

    it "routes to #create" do
      post("/variable_field_measurements").should route_to("variable_field_measurements#create")
    end

    it "routes to #update" do
      put("/variable_field_measurements/1").should route_to("variable_field_measurements#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/variable_field_measurements/1").should route_to("variable_field_measurements#destroy", :id => "1")
    end

  end
end
