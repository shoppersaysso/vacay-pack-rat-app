class ListsController < ApplicationController

  get "/lists/new" do
      @user = current_user
      if logged_in?
        erb :"/lists/new"
      else
        redirect '/login'
      end
    end

    post "/new" do
      if logged_in? && params[:name] != ""
        @user = current_user
        @list = List.create(name: params["name"], user_id: params[:user_id])
        @list.save
        erb :"/lists/show"
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
        erb :"/lists/index"
      else
        redirect '/login'
      end
    end

    get "/lists/:id" do
      @user = current_user
      @list = List.find_by_id(params[:id])
      if !logged_in?
        redirect '/login'
      else
        erb :"/lists/show"
      end
    end

    get "/lists/:id/edit" do
      if logged_in?
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

    patch "/lists/:id" do
      if params[:content] == ""
        flash[:notice] = "Please enter content to proceed"
        redirect "/lists/#{params[:id]}/edit"
      else
        @list = List.find(params[:id])
        @list.update(content: params[:content])
        redirect "/lists/#{@list.id}"
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
