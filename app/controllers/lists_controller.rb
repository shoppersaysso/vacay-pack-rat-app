class ListsController < ApplicationController

  get "/lists/new" do
      @user = current_user
      if logged_in?
        erb :"/lists/new"
      else
        redirect '/login'
      end
    end

    post "/lists/new" do
      if logged_in? && params[:name] != ""
        @user = current_user
        @list = List.new(:name => params["list"]["name"], :public => params["list"]["public"])
        @list.save
        redirect "/lists/:id"
      elsif logged_in? && params[:name] == ""
        flash[:notice] = "Your list name is blank!"
        redirect '/lists/new'
      else
        flash[:notice] = "Please log in to proceed"
        redirect '/login'
      end
    end

    get "/lists" do
      if logged_in?
        @user = current_user
        @list = List.find(params[:id])
        @list.user_id == session[:user_id]
        erb :"/lists/index"
      else
        redirect '/login'
      end
    end

    get "/lists/:id" do
      @user = current_user
      @list = List.find_by_id(params[:id])
      # @items = @list.items.all
      if !logged_in?
        redirect '/login'
      else
        erb :"/lists/show"
      end
    end

    get "/lists/:id/edit" do
      if logged_in?
        @user = current_user
        @list = List.find(params[:id])
        if @list.user_id == session[:user_id]
        erb :'/lists/edit'
        else
          redirect '/login'
        end
      else
        redirect '/login'
      end
    end

    patch "/lists/:id/edit" do
      @user = current_user
      if params[:name] == ""
        flash[:notice] = "Please enter content to proceed"
        redirect "/lists/#{params[:id]}/edit"
      else
        @list = List.find(params[:id])
        @list.update(name: params[:name])
        redirect "/lists/#{@list.id}"
      end
    end

    get "/lists/:id/add" do
        @user = current_user
        @items = Item.all
        @list = List.find_by(id: params[:id])
        if logged_in?
          erb :"/lists/add"
        else
          redirect '/login'
        end
      end

    post "/lists/:id/add" do
      if logged_in? && params[:name] != ""
        @user = current_user
        @list = List.find_by(id: params[:id])
        @item = Item.create(:name => params["item"]["name"], :list_id => params[@list.id], :user_id => session[:user_id])
        @item.save
        erb :"/lists/show"
      # elsif logged_in? && params[:name] == ""
      #   flash[:notice] = "Your item name is blank!"
      #   redirect '/lists/add'
      else
        flash[:notice] = "Please log in to proceed"
        redirect '/login'
      end
    end

    delete "/lists/:id/delete" do
      @user = current_user
      @list = List.find_by_id(params[:id])
      if logged_in? && @list.user_id == session[:user_id]
        @list.delete
        erb :'/lists/delete'
      elsif !logged_in? || @list.user_id != session[:user_id]
        erb :'/lists/error'
      else
        erb :'/lists/error'
      end
    end

end
