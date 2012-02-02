require 'test_helper'

class ReposControllerTest < ActionController::TestCase
  setup do
    @repo = repos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:repos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create repo" do
    assert_difference('Repo.count') do
      post :create, repo: @repo.attributes
    end

    assert_redirected_to repo_path(assigns(:repo))
  end

  test "should show repo" do
    get :show, id: @repo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @repo.to_param
    assert_response :success
  end

  test "should update repo" do
    put :update, id: @repo.to_param, repo: @repo.attributes
    assert_redirected_to repo_path(assigns(:repo))
  end

  test "should destroy repo" do
    assert_difference('Repo.count', -1) do
      delete :destroy, id: @repo.to_param
    end

    assert_redirected_to repos_path
  end
end
