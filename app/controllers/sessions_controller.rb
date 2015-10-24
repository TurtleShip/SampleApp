class SessionsController < ApplicationController
  def new
  end

  def create
    session = params[:session]
    user = User.find_by(email: session[:email].downcase)
    if user && user.authenticate(session[:password])
      # Log the user in and redirect to the user's show page
      redirect_to users_path user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # FILL ME
  end
end
