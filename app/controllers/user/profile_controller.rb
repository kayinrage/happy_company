class User::ProfileController < User::UserController
  defaults resource_class: User, instance_name: 'user'

  actions :edit, :update

  def update
    resource
    if @user.update_attributes(params[:user], as: :user)
      redirect_to edit_user_profile_path, notice: 'Profile has been updated'
    else
      render :edit
    end
  end

  protected

  def resource
    @user ||= current_user
  end
end
