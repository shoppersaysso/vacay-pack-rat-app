class UsersController < ApplicationController

  get '/home' do
    if logged_in?
      @user = current_user
      @list = List.find_by_id(params[:id])
      erb :"/users/home"
    else
      redirect '/login'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    if logged_in? && current_user
      @list = List.find_by_id(params[:id])
      erb :"/users/home"
    else
      redirect '/users/:slug/public'
    end
  end

  get '/users/:slug/public' do
    @user = User.find_by_slug(params[:slug])
    @public_lists = []
    @user.lists.each do |list|
      if list.privacy == "Public"
        @public_lists << list
      end
    end
    erb :"/users/public"
  end

end
