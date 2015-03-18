require 'test_helper'

class GridControllerControllerTest < ActionController::TestCase
  test "should get join_grid_request," do
    get :join_grid_request,
    assert_response :success
  end

  test "should get join_grid_response" do
    get :join_grid_response
    assert_response :success
  end

end
