require "spec_helper"

describe VariableFieldsController do
  describe "routing" do

    it "routes to #index" do
      get("/variable_fields").should route_to("variable_fields#index")
    end

    it "routes to #new" do
      get("/variable_fields/new").should route_to("variable_fields#new")
    end

    it "routes to #show" do
      get("/variable_fields/1").should route_to("variable_fields#show", :id => "1")
    end

    it "routes to #edit" do
      get("/variable_fields/1/edit").should route_to("variable_fields#edit", :id => "1")
    end

    it "routes to #create" do
      post("/variable_fields").should route_to("variable_fields#create")
    end

    it "routes to #update" do
      put("/variable_fields/1").should route_to("variable_fields#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/variable_fields/1").should route_to("variable_fields#destroy", :id => "1")
    end

  end
end
