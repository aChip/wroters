require 'test_helper'

class FingersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fingers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create finger" do
    assert_difference('Finger.count') do
      post :create, :finger => { }
    end

    assert_redirected_to finger_path(assigns(:finger))
  end

  test "should show finger" do
    get :show, :id => fingers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => fingers(:one).to_param
    assert_response :success
  end

  test "should update finger" do
    put :update, :id => fingers(:one).to_param, :finger => { }
    assert_redirected_to finger_path(assigns(:finger))
  end

  test "should destroy finger" do
    assert_difference('Finger.count', -1) do
      delete :destroy, :id => fingers(:one).to_param
    end

    assert_redirected_to fingers_path
  end
end
