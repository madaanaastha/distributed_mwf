require 'test_helper'

class RoleTypesControllerTest < ActionController::TestCase
  setup do
    @role_type = role_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:role_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create role_type" do
    assert_difference('RoleType.count') do
      post :create, role_type: { attrs: @role_type.attrs, description: @role_type.description, options: @role_type.options, parent_role_uri_id: @role_type.parent_role_uri_id, role_name: @role_type.role_name, role_player_uri_id: @role_type.role_player_uri_id, role_uri_id: @role_type.role_uri_id, version: @role_type.version, world_uri_id: @role_type.world_uri_id }
    end

    assert_redirected_to role_type_path(assigns(:role_type))
  end

  test "should show role_type" do
    get :show, id: @role_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @role_type
    assert_response :success
  end

  test "should update role_type" do
    patch :update, id: @role_type, role_type: { attrs: @role_type.attrs, description: @role_type.description, options: @role_type.options, parent_role_uri_id: @role_type.parent_role_uri_id, role_name: @role_type.role_name, role_player_uri_id: @role_type.role_player_uri_id, role_uri_id: @role_type.role_uri_id, version: @role_type.version, world_uri_id: @role_type.world_uri_id }
    assert_redirected_to role_type_path(assigns(:role_type))
  end

  test "should destroy role_type" do
    assert_difference('RoleType.count', -1) do
      delete :destroy, id: @role_type
    end

    assert_redirected_to role_types_path
  end
end
