require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:seulgi)
  end

  test 'login with invalid information' do
    get login_path

    assert_template 'sessions/new'
    post_via_redirect login_path, session: {
                                    email: '',
                                    password: ''
                                }

    # Verify that the new sessions form gets re-rendered
    assert_template 'sessions/new'

    # flash message appears
    assert_not_empty flash

    # visit another page
    get root_path

    # flash message should NOT appear on the new page
    assert_empty flash
  end

  test 'login with valid information followed by logout' do
    get login_path

    assert_template 'sessions/new'
    post login_path, session: {
                       email: @user.email,
                       password: 'password'
                   }

    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'

    # Verify that the login link disappears
    assert_select "a[href=?]", login_path, false

    # Verify that a logout link appears
    assert_select "a[href=?]", logout_path

    # Verify that a profile link appears
    assert_select "a[href=?]", user_path(@user)

    # user logsout
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!

    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, false
    assert_select "a[href=?]", user_path(@user), false
  end

  test 'login with valid information followed by logouts from multiple tabs' do
    get login_path

    assert_template 'sessions/new'
    post_via_redirect login_path, session: {
                       email: @user.email,
                       password: 'password'
                   }

    assert is_logged_in?

    # Logging out from the first browser tab
    delete logout_path
    assert_not is_logged_in?

    # Logging out from the second browser tab
    delete logout_path
    assert_not is_logged_in?
  end

end
