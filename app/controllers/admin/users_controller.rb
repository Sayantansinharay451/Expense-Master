class Admin::UsersController < ApplicationController
  layout "user"

  def index
    @users = User.get_users()
  end

  def new
    @user = User.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @user = User.invite_user(params[:user][:email])
    respond_to do |format|
      if @user && @user.save
        format.html {
          redirect_to admin_users_path, success: "Invitation sent to #{@user.email}!"
        }
        format.js { flash[:success] = "Invitation sent to #{@user.email}!" }
        UserMailer.with(user: @user).invitation_email.deliver_later
      else
        format.html {
          redirect_to admin_users_path
          flash[:alert] = "Failed to send invitation to #{params[:user][:email]}."
        }
        format.js { flash[:alert] = "Failed to send invitation to #{params[:user][:email]}." }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_path, error: "User has been successfully deleted." }
      format.js { render :layout => false }
    end
  end
end
