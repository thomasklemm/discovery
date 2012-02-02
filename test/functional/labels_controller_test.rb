require 'test_helper'

class LabelsControllerTest < ActionController::TestCase
  setup do
    @label = labels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:labels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create label" do
    assert_difference('Label.count') do
      post :create, label: @label.attributes
    end

    assert_redirected_to label_path(assigns(:label))
  end

  test "should show label" do
    get :show, id: @label.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @label.to_param
    assert_response :success
  end

  test "should update label" do
    put :update, id: @label.to_param, label: @label.attributes
    assert_redirected_to label_path(assigns(:label))
  end

  test "should destroy label" do
    assert_difference('Label.count', -1) do
      delete :destroy, id: @label.to_param
    end

    assert_redirected_to labels_path
  end
end
