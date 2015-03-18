require 'test_helper'

class WorldImportsControllerTest < ActionController::TestCase
  setup do
    @world_import = world_imports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:world_imports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create world_import" do
    assert_difference('WorldImport.count') do
      post :create, world_import: { import_from_uri_id: @world_import.import_from_uri_id, import_to_uri_id: @world_import.import_to_uri_id }
    end

    assert_redirected_to world_import_path(assigns(:world_import))
  end

  test "should show world_import" do
    get :show, id: @world_import
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @world_import
    assert_response :success
  end

  test "should update world_import" do
    patch :update, id: @world_import, world_import: { import_from_uri_id: @world_import.import_from_uri_id, import_to_uri_id: @world_import.import_to_uri_id }
    assert_redirected_to world_import_path(assigns(:world_import))
  end

  test "should destroy world_import" do
    assert_difference('WorldImport.count', -1) do
      delete :destroy, id: @world_import
    end

    assert_redirected_to world_imports_path
  end
end
