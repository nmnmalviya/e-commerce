require "test_helper"

class CategorysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get categorys_index_url
    assert_response :success
  end
end
