require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:seulgi)
  end

  test 'index including pagination' do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination' # confirm that pagination shows up

    # Confirm that each entry in the first page matches actual user info
    User.paginate(page: 1,  per_page: 10).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end
