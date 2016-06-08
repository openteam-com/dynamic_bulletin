class UsersController < ApplicationController
  def update
    if current_user.update(user_params)
      flash[:notice] = 'Информация обновлена'
    end
    respond_with current_user,
      location: -> { edit_user_path(current_user) }
  end

  def user_params
    params.require(:user).permit(:name, :phone)
  end


end
