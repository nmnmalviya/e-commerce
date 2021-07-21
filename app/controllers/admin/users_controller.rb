class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    @users = User.all
  end

  private

  def authorize_admin
    redirect_to root_path unless current_user.has_role?(:admin)
  end
end
