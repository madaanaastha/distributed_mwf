require 'test_helper'

class WorldAdminsControllerTest < ActionController::TestCase
  setup do
    @world_admin = world_admins(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:world_admins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create world_admin" do
    assert_difference('WorldAdmin.count') do
      post :create, world_admin: { admin_uri_id: @world_admin.admin_uri_id, world_uri_id: @world_admin.world_uri_id }
    end

    assert_redirected_to world_admin_path(assigns(:world_admin))
  end

  test "should show world_admin" do
    get :show, id: @world_admin
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @world_admin
    assert_response :success
  end

  test "should update world_admin" do
    patch :update, id: @world_admin, world_admin: { admin_uri_id: @world_admin.admin_uri_id, world_uri_id: @world_admin.world_uri_id }
    assert_redirected_to world_admin_path(assigns(:world_admin))
  end

  test "should destroy world_admin" do
    assert_difference('WorldAdmin.count', -1) do
      delete :destroy, id: @world_admin
    end

    assert_redirected_to world_admins_path
  end
end
