require 'test_helper'

class WorldsControllerTest < ActionController::TestCase
  setup do
    @world = worlds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:worlds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create world" do
    assert_difference('World.count') do
      post :create, world: { access_rules: @world.access_rules, attrs: @world.attrs, container_uri_id: @world.container_uri_id, description: @world.description, home_location_uri_id: @world.home_location_uri_id, image: @world.image, name: @world.name, options: @world.options, superclass_uri_id: @world.superclass_uri_id, url: @world.url, version: @world.version, world_uri_id: @world.world_uri_id }
    end

    assert_redirected_to world_path(assigns(:world))
  end

  test "should show world" do
    get :show, id: @world
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @world
    assert_response :success
  end

  test "should update world" do
    patch :update, id: @world, world: { access_rules: @world.access_rules, attrs: @world.attrs, container_uri_id: @world.container_uri_id, description: @world.description, home_location_uri_id: @world.home_location_uri_id, image: @world.image, name: @world.name, options: @world.options, superclass_uri_id: @world.superclass_uri_id, url: @world.url, version: @world.version, world_uri_id: @world.world_uri_id }
    assert_redirected_to world_path(assigns(:world))
  end

  test "should destroy world" do
    assert_difference('World.count', -1) do
      delete :destroy, id: @world
    end

    assert_redirected_to worlds_path
  end
end
