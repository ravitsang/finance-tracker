class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    # @user_stocks = current_user.user_stocks
    @user_stocks = current_user.stocks
  end

  def my_friends
    @friendships = current_user.friends
  end

  def search
    if params[:search_param].blank?
      flash.now[:danger] = "You have entered an empty search string"
    else
      #debugger
      @users = User.search(params[:search_param])
      @users = current_user.except_current_user(@users)
      flash.now[:danger] = "No users match this search criteria " if @users.blank?
    end
    respond_to do |format|
      format.js { render partial: 'friends/result'}
    end
  end

  def show
    @user = User.find(params[:id])
    @user_stocks = @user.stocks

  end
end
