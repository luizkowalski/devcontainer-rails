require "test_helper"

class TopicsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get topics_show_url
    assert_response :success
  end

  test "should get search" do
    get topics_search_url
    assert_response :success
  end
end
