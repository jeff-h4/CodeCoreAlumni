class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if verify_recaptcha(:model => @user, :message => "Oh! It's error with reCAPTCHA!") && @user.save
      session[:user_id] = @user.id
      redirect_to new_session_path, notice: "Account Created"
    else
      render :new
      # flash[:alert] = @user.errors
    end
  end

  def edit
    @user = current_user
  end

  def update
   @user = current_user
    if @user.authenticate(params[:user][:current_password])
      if @user.update user_params
        redirect_to edit_users_path, notice: "Account updated"
      else
        flash[:alert] = "See errors below"
        render :edit
      end
    else
      flash[:alert] = "Wrong password"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :captcha, :captcha_key)
  end
end
