require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test 'invalid form submission should not create a new user' do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path, user: { name: '',
                               email: 'user@invalid',
                               password: 'foo',
                               password_confirmation: 'bar' }
    end

    # Also check that a failed submission re-renders the new action
    assert_template 'users/new'

    # Check that a failed submission shows error message as well
    assert_template partial: 'shared/_error_messages'
  end
end
