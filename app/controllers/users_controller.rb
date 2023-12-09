class UsersController < ApplicationController
  def update
    @user = current_user
    if @user.update_columns(user_params.to_h)
      redirect_to @user, notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  private

  def user_params
    # params.require(:user).permit(:address, :city, :province, :postal_code)
    params.require(:user).permit(:address, :city, :province_id, :postal_code)
  end
end
