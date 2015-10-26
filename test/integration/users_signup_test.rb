require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid form submission should not create a new user' do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path, user: {name: '',
                              email: 'user@invalid',
                              password: 'foo',
                              password_confirmation: 'bar'}
    end

    # Also check that a failed submission re-renders the new action
    assert_template 'users/new'

    # Check that a failed submission shows error message as well
    assert_template partial: 'shared/_error_messages'
  end

  test 'valid signup information with account activation' do
    get signup_path

    # Check that user is actually created
    assert_difference 'User.count', 1 do
      post users_path, user: {name: 'valid name',
                              email: 'valid@example.com',
                              password: 'very_safe_password_123_!@#',
                              password_confirmation: 'very_safe_password_123_!@#'}
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    # Trhy to log in before activation.
    log_in_as(user)
    assert_not is_logged_in? # shouldn't allow login
    assert_not flash.empty? # should display warning sign as well

    # Invalid activation token
    get edit_account_activation_path('invalid token')
    assert_not is_logged_in?

    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?

    # valid token and valid email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert is_logged_in?
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
  end
end
