class SessionsController < ApplicationController
  def new
  end

  # Corresponds to login_path
  def create
    session = params[:session]
    @user = User.find_by(email: session[:email].downcase)
    if @user && @user.authenticate(session[:password])
      log_in @user
      session[:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
