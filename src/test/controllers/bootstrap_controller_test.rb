require 'test_helper'

class BootstrapControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get join_frame" do
    get :join_frame
    assert_response :success
  end

  test "should get new_frame" do
    get :new_frame
    assert_response :success
  end

end
