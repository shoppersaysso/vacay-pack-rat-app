class UsersController < ApplicationController

  get "/home" do
    if logged_in?
      @user = current_user
      @list = List.find_by_id(params[:id])
      @my_lists = @user.lists
      erb :"/users/home"
    else
      redirect '/login'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @list = List.find_by_id(params[:id])
    erb :"/users/home"
  end

end
