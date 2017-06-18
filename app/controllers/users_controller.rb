class UsersController < ApplicationController

  get "/home" do
    if logged_in?
      @user = current_user
      erb :"/users/home"
    else
      redirect '/login'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @lists = @user.lists
    erb :"/users/home"
  end

end
