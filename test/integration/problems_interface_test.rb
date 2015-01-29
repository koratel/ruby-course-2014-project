require 'test_helper'

class ProblemsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "problems interface" do
    log_in_as(@user)
    get user_path(users(:michael))
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Problem.count' do
      post problems_path, problem: { name: "" }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    name = "Nice problem name"
    assert_difference 'Problem.count', 1 do
      post problems_path, problem: { name: name }
    end
    assert_redirected_to root_url
    follow_redirect!
    follow_redirect!
    assert_match name, response.body
    # Delete a problem.
    assert_select 'a', text: 'delete'
    first_problem = @user.problems.paginate(page: 1).first
    assert_difference 'Problem.count', -1 do
      delete problem_path(first_problem)
    end
    # Visit a different user.
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end
