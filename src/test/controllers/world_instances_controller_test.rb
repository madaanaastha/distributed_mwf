require 'test_helper'

class WorldInstancesControllerTest < ActionController::TestCase
  setup do
    @world_instance = world_instances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:world_instances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create world_instance" do
    assert_difference('WorldInstance.count') do
      post :create, world_instance: { access_rules: @world_instance.access_rules, attrs: @world_instance.attrs, container_uri_id: @world_instance.container_uri_id, description: @world_instance.description, home_location_uri_id: @world_instance.home_location_uri_id, image: @world_instance.image, name: @world_instance.name, options: @world_instance.options, superclass_uri_id: @world_instance.superclass_uri_id, url: @world_instance.url, version: @world_instance.version, world_instance_uri_id: @world_instance.world_instance_uri_id }
    end

    assert_redirected_to world_instance_path(assigns(:world_instance))
  end

  test "should show world_instance" do
    get :show, id: @world_instance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @world_instance
    assert_response :success
  end

  test "should update world_instance" do
    patch :update, id: @world_instance, world_instance: { access_rules: @world_instance.access_rules, attrs: @world_instance.attrs, container_uri_id: @world_instance.container_uri_id, description: @world_instance.description, home_location_uri_id: @world_instance.home_location_uri_id, image: @world_instance.image, name: @world_instance.name, options: @world_instance.options, superclass_uri_id: @world_instance.superclass_uri_id, url: @world_instance.url, version: @world_instance.version, world_instance_uri_id: @world_instance.world_instance_uri_id }
    assert_redirected_to world_instance_path(assigns(:world_instance))
  end

  test "should destroy world_instance" do
    assert_difference('WorldInstance.count', -1) do
      delete :destroy, id: @world_instance
    end

    assert_redirected_to world_instances_path
  end
end
