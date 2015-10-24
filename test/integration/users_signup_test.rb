require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

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

  test 'valid signup should create a user' do
    get signup_path

    # Check that user is actually created
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {name: 'valid name',
                                           email: 'valid@example.com',
                                           password: 'very_safe_password_123_!@#',
                                           password_confirmation: 'very_safe_password_123_!@#'}
    end

    # Check that successful signup redirects to user info page
    assert_template 'users/show'

    # Check that user info page includes flash message
    assert_not_empty flash
  end
end
