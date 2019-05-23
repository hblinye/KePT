require 'test_helper'

class MeetingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get meeting_index_url
    assert_response :success
  end

  test "should get show" do
    get meeting_show_url
    assert_response :success
  end

  test "should get create" do
    get meeting_create_url
    assert_response :success
  end

end
