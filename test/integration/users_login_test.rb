require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
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
end
