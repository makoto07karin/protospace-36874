class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])#1
    #@prototype = user.
  end
end

#1
#ここでUser.find(params[:id])の意味は、UserテーブルからIdを@userとういう箱に情報を入れている？