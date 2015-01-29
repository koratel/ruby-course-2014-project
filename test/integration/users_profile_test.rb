require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_match @user.problems.count.to_s, response.body
    assert_select 'div.pagination'
    @user.problems.paginate(page: 1).each do |problem|
      assert_match problem.name, response.body
    end
  end
end
