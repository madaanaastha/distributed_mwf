require 'test_helper'

class AssociationInstancesControllerTest < ActionController::TestCase
  setup do
    @association_instance = association_instances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:association_instances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create association_instance" do
    assert_difference('AssociationInstance.count') do
      post :create, association_instance: { association_uri_id: @association_instance.association_uri_id, attrs: @association_instance.attrs, description: @association_instance.description, source_role_player_uri_id: @association_instance.source_role_player_uri_id, target_role_player_uri_id: @association_instance.target_role_player_uri_id, version: @association_instance.version, world_uri_id: @association_instance.world_uri_id }
    end

    assert_redirected_to association_instance_path(assigns(:association_instance))
  end

  test "should show association_instance" do
    get :show, id: @association_instance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @association_instance
    assert_response :success
  end

  test "should update association_instance" do
    patch :update, id: @association_instance, association_instance: { association_uri_id: @association_instance.association_uri_id, attrs: @association_instance.attrs, description: @association_instance.description, source_role_player_uri_id: @association_instance.source_role_player_uri_id, target_role_player_uri_id: @association_instance.target_role_player_uri_id, version: @association_instance.version, world_uri_id: @association_instance.world_uri_id }
    assert_redirected_to association_instance_path(assigns(:association_instance))
  end

  test "should destroy association_instance" do
    assert_difference('AssociationInstance.count', -1) do
      delete :destroy, id: @association_instance
    end

    assert_redirected_to association_instances_path
  end
end
