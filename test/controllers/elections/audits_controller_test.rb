require 'test_helper'

class Elections::AuditsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @election = elections(:one)
    @voter = voters(:one)
    @answer = answers(:one)
    @question = questions(:one)
  end

  test "should get index" do
    get election_audits_url(@election)
    assert_response :success
  end
end
