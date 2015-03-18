require 'test_helper'

class ProxyWorldsControllerTest < ActionController::TestCase
  setup do
    @proxy_world = proxy_worlds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proxy_worlds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proxy_world" do
    assert_difference('ProxyWorld.count') do
      post :create, proxy_world: { proxy_world_uri_id: @proxy_world.proxy_world_uri_id, world_uri_id: @proxy_world.world_uri_id }
    end

    assert_redirected_to proxy_world_path(assigns(:proxy_world))
  end

  test "should show proxy_world" do
    get :show, id: @proxy_world
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @proxy_world
    assert_response :success
  end

  test "should update proxy_world" do
    patch :update, id: @proxy_world, proxy_world: { proxy_world_uri_id: @proxy_world.proxy_world_uri_id, world_uri_id: @proxy_world.world_uri_id }
    assert_redirected_to proxy_world_path(assigns(:proxy_world))
  end

  test "should destroy proxy_world" do
    assert_difference('ProxyWorld.count', -1) do
      delete :destroy, id: @proxy_world
    end

    assert_redirected_to proxy_worlds_path
  end
end
