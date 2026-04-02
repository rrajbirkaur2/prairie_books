require "test_helper"

class CheckoutControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get checkout_new_url
    assert_response :success
  end

  test "should get create" do
    get checkout_create_url
    assert_response :success
  end

  test "should get confirm" do
    get checkout_confirm_url
    assert_response :success
  end

  test "should get complete" do
    get checkout_complete_url
    assert_response :success
  end
end
