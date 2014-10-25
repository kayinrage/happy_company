class User::ProfileController < User::UserController
  defaults resource_class: User, instance_name: 'user'

  actions :edit, :update

  def update
    resource
    if @user.update_attributes(user_params)
      redirect_to edit_user_profile_path, notice: 'Profile has been updated'
    else
      render :edit
    end
  end

  protected

  def resource
    @user ||= current_user
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
