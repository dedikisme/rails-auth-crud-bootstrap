class SessionsController < ApplicationController
  def login

  end

  def home
  	@session=session[:user_id]
  end

  def profile
  	authenticate_user
  end

  def setting
  end
  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    if authorized_user
    session[:user_id] = authorized_user.id
      flash[:notice] = "Wow Welcome again, you logged in as #{authorized_user.username}"
      redirect_to(:action => 'home')
    else
      flash[:notice] = "Invalid Username or Password"
      flash[:color]= "invalid"
      render "login"	
    end
  end

  def show
  end
  def logout
  session[:user_id] = nil
  redirect_to :action => 'login'
end
end
