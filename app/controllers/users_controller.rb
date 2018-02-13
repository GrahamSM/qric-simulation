class UsersController < ApplicationController

  def new
      @user = User.new
  end

   def create
  	@user = User.new(user_params)
    @user.team_id = 1
  	if @user.save
      session[:user_id] = @user.id
    else
    end
    redirect_to properties_path, notice: "Welcome!"
  end

  def show
    @user = User.find(session[:user_id])
    @team = Team.find(@user.team_id)
    @properties = Property.where(team_id: @team.id).order(:id)
    @totalPropertyValue = @team.calcTotalPropertyValue()
  end

  def develop
    @property = Property.find(params[:id])
    # Safeguard against players manually entering the url
    if @property.team_id != User.find(session[:user_id]).team_id
      redirect_to users_path, alert: "You don't have permission to do that"
    # Ensure property can still be developed
    elsif @property.development && @property.development.used
      redirect_to users_path, alert: "You have already developed this property"
    # Make sure team has enough available cash
    elsif !(Team.find(current_user.team_id).can_drop_cash_balance(@property.development.cost))
      redirect_to users_path, alert: "You cannot afford to develop this property"
    else
      if @property.development
        # Call develop method in properties model and store returned message
        message = @property.develop(current_user.team_id)
        @development = @property.development
        @development.save!
        redirect_to users_path, notice: "Development was succesfully initiated"
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

end
