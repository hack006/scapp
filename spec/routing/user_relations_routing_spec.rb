require "spec_helper"

describe UserRelationsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_relations").should route_to("user_relations#index")
    end

    it "routes to #new" do
      get("/user_relations/new").should route_to("user_relations#new")
    end

    it "routes to #show" do
      get("/user_relations/1").should route_to("user_relations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_relations/1/edit").should route_to("user_relations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_relations").should route_to("user_relations#create")
    end

    it "routes to #update" do
      put("/user_relations/1").should route_to("user_relations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_relations/1").should route_to("user_relations#destroy", :id => "1")
    end

  end
end
