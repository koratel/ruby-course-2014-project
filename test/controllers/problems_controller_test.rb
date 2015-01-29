require 'test_helper'

class ProblemsControllerTest < ActionController::TestCase

  def setup
    @problem = problems(:problem_a)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Problem.count' do
      post :create, problem: { name: "Lorem ipsum" }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Problem.count' do
      delete :destroy, id: @problem
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong problem" do
    log_in_as(users(:michael))
    problem = problems(:problem_b)
    assert_no_difference 'Problem.count' do
      delete :destroy, id: problem
    end
    assert_redirected_to root_url
  end

end
