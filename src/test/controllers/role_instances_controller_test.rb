require 'test_helper'

class RoleInstancesControllerTest < ActionController::TestCase
  setup do
    @role_instance = role_instances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:role_instances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create role_instance" do
    assert_difference('RoleInstance.count') do
      post :create, role_instance: { attrs: @role_instance.attrs, description: @role_instance.description, role_player_uri_id: @role_instance.role_player_uri_id, role_uri_id: @role_instance.role_uri_id, version: @role_instance.version, world_uri_id: @role_instance.world_uri_id }
    end

    assert_redirected_to role_instance_path(assigns(:role_instance))
  end

  test "should show role_instance" do
    get :show, id: @role_instance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @role_instance
    assert_response :success
  end

  test "should update role_instance" do
    patch :update, id: @role_instance, role_instance: { attrs: @role_instance.attrs, description: @role_instance.description, role_player_uri_id: @role_instance.role_player_uri_id, role_uri_id: @role_instance.role_uri_id, version: @role_instance.version, world_uri_id: @role_instance.world_uri_id }
    assert_redirected_to role_instance_path(assigns(:role_instance))
  end

  test "should destroy role_instance" do
    assert_difference('RoleInstance.count', -1) do
      delete :destroy, id: @role_instance
    end

    assert_redirected_to role_instances_path
  end
end
