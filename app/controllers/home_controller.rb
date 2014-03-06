class HomeController < ApplicationController

  def index
    authorize! :index, HomeController

    if is_player?
      @my_latest_vf_measurements = VariableFieldMeasurement.latest_for_user(current_user, 8)
      @my_connected_coaches = current_user.get_my_relations_with_statuses 'accepted', :my_coaches
    end
  end
end
