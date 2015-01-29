require 'test_helper'

class ProblemTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # This code is not idiomatically correct.
    @problem = @user.problems.build(name: "Lorem ipsum", user_id: @user.id)
  end

  test "should be valid" do
    assert @problem.valid?
  end

  test "user id should be present" do
    @problem.user_id = nil
    assert_not @problem.valid?
  end

  test "name should be present " do
    @problem.name = "   "
    assert_not @problem.valid?
  end

  test "name should be at most 100 characters" do
    @problem.name = "a" * 101
    assert_not @problem.valid?
  end

  test "order should be most recent first" do
    assert_equal Problem.first, problems(:most_recent)
  end
end
