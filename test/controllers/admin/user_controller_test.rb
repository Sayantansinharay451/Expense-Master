require "test_helper"

class Admin::UserControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_user_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_user_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_user_create_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_user_destroy_url
    assert_response :success
  end
end
