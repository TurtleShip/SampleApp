require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:seulgi)
  end

  test 'unsuccessful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: {name: '',
                                   email: 'bad@invalid',
                                   password: 'one',
                                   password_confirmation: 'two'}
    assert_template 'users/edit'
  end

  test 'successful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Seulgi Two'
    email = 'seulgitwo@email.com'
    patch user_path(@user), user: {name: name,
                                   email: email,
                                   password: '',
                                   password_confimration: ''}

    # Flash should contain a success message
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

end
