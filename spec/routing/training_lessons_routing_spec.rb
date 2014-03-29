require "spec_helper"

describe TrainingLessonsController do
  describe "routing" do

    it "routes to #index" do
      get("/training_lessons").should route_to("training_lessons#index")
    end

    it "routes to #new" do
      get("/training_lessons/new").should route_to("training_lessons#new")
    end

    it "routes to #show" do
      get("/training_lessons/1").should route_to("training_lessons#show", :id => "1")
    end

    it "routes to #edit" do
      get("/training_lessons/1/edit").should route_to("training_lessons#edit", :id => "1")
    end

    it "routes to #create" do
      post("/training_lessons").should route_to("training_lessons#create")
    end

    it "routes to #update" do
      put("/training_lessons/1").should route_to("training_lessons#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/training_lessons/1").should route_to("training_lessons#destroy", :id => "1")
    end

  end
end
