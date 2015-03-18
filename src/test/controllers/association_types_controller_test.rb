require 'test_helper'

class AssociationTypesControllerTest < ActionController::TestCase
  setup do
    @association_type = association_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:association_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create association_type" do
    assert_difference('AssociationType.count') do
      post :create, association_type: { association_name: @association_type.association_name, association_uri_id: @association_type.association_uri_id, attrs: @association_type.attrs, description: @association_type.description, source_role_uri_id: @association_type.source_role_uri_id, target_role_uri_id: @association_type.target_role_uri_id, version: @association_type.version, world_uri_id: @association_type.world_uri_id }
    end

    assert_redirected_to association_type_path(assigns(:association_type))
  end

  test "should show association_type" do
    get :show, id: @association_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @association_type
    assert_response :success
  end

  test "should update association_type" do
    patch :update, id: @association_type, association_type: { association_name: @association_type.association_name, association_uri_id: @association_type.association_uri_id, attrs: @association_type.attrs, description: @association_type.description, source_role_uri_id: @association_type.source_role_uri_id, target_role_uri_id: @association_type.target_role_uri_id, version: @association_type.version, world_uri_id: @association_type.world_uri_id }
    assert_redirected_to association_type_path(assigns(:association_type))
  end

  test "should destroy association_type" do
    assert_difference('AssociationType.count', -1) do
      delete :destroy, id: @association_type
    end

    assert_redirected_to association_types_path
  end
end
