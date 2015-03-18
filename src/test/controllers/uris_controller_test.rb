require 'test_helper'

class UrisControllerTest < ActionController::TestCase
  setup do
    @uri = uris(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:uris)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create uri" do
    assert_difference('Uri.count') do
      post :create, uri: { host: @uri.host, is_external: @uri.is_external, local_id: @uri.local_id, name: @uri.name, port: @uri.port, slug: @uri.slug, uri_type: @uri.uri_type }
    end

    assert_redirected_to uri_path(assigns(:uri))
  end

  test "should show uri" do
    get :show, id: @uri
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @uri
    assert_response :success
  end

  test "should update uri" do
    patch :update, id: @uri, uri: { host: @uri.host, is_external: @uri.is_external, local_id: @uri.local_id, name: @uri.name, port: @uri.port, slug: @uri.slug, uri_type: @uri.uri_type }
    assert_redirected_to uri_path(assigns(:uri))
  end

  test "should destroy uri" do
    assert_difference('Uri.count', -1) do
      delete :destroy, id: @uri
    end

    assert_redirected_to uris_path
  end
end
