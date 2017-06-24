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
        @list = List.create(:name => params[:name], :privacy => params[:privacy], :user_id => session[:user_id])
        @list.save
        redirect("lists/#{@list.id}")
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
        @list = List.find_by_id(params[:id])
        erb :"/lists/index"
      else
        redirect '/login'
      end
    end

    get "/lists/:id" do
      if !logged_in?
        redirect '/login'
      else
        @user = current_user
        @list = List.find_by_id(params[:id])
        erb :"/lists/show"
      end
    end

    get "/lists/:id/edit" do
      if logged_in?
        @user = current_user
        @list = List.find_by_id(params[:id])
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
        @list = List.find_by_id(params[:id])
        @list.update(params[:list])
        @list.save
        redirect "/lists/#{@list.id}"
      end
    end

    get "/lists/:id/add" do
        @user = current_user
        @items = Item.all
        @list = List.find_by_id(params[:id])
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
        @item = Item.new(:name => params["item"]["name"], :list_id => params[:list_id], :user_id => session[:user_id])
        @item.save
        erb :"/lists/show"
      else
        flash[:notice] = "Please log in to proceed"
        redirect '/login'
      end
    end

    get "/lists/:id/print" do
      if !logged_in?
        redirect '/login'
      else
        @user = current_user
        @list = List.find_by_id(params[:id])
        erb :"/lists/print"
      end
    end

    delete "/lists/:id/delete" do
      @user = current_user
      @list = List.find_by_id(params[:id])
      if logged_in? && @list.user_id == session[:user_id]
        @list.delete
        redirect '/users/home'
      elsif !logged_in? || @list.user_id != session[:user_id]
        erb :'/lists/error'
      else
        erb :'/lists/error'
      end
    end

end
