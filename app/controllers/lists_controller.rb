class ListsController < ApplicationController

  get "/lists/new" do
      if logged_in?
        erb :"/lists/new"
      else
        redirect '/login'
      end
    end

    post "/lists/new" do
      if logged_in? && params[:name] != ""
        @list = current_user.lists.create(:name => params[:name], :privacy => params[:privacy])
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
        @lists = current_user.lists
        erb :"/lists/index"
      else
        redirect '/login'
      end
    end

    get "/lists/:id" do
      if !logged_in?
        redirect '/login'
      else
        @list = current_user.lists.find_by_id(params[:id])
        erb :"/lists/show"
      end
    end

    get "/lists/:id/edit" do
      if logged_in?
        if @list = current_user.lists.find_by_id(params[:id])
          erb :'/lists/edit'
        else
          redirect '/login'
        end
      else
        redirect '/login'
      end
    end

    patch "/lists/:id/edit" do
        @list = List.find_by_id(params[:id])
        @list.update(params[:list])
        redirect "/lists/#{@list.id}"
    end

    get "/lists/:id/add" do
        @items = Item.all
        @list = List.find_by_id(params[:id])
        if logged_in?
          erb :"/lists/add"
        else
          redirect '/login'
        end
      end

    post "/lists/:id/add" do
      @list = List.find_by(id: params[:id])
        if logged_in? && params[:name].empty?
          @item = Item.new(:name => params["suggest-name"], :list_id => params[:list_id], :user_id => session[:user_id])
        elsif logged_in? && !params[:name].empty?
          @item = Item.new(:name => params[:name], :list_id => params[:list_id], :user_id => session[:user_id])
        else
          flash[:notice] = "Please log in to proceed"
          redirect '/login'
        end
      @item.save
      redirect "/lists/#{@list.id}"
    end

    delete "/lists/:id/delete" do
      @list = List.find_by_id(params[:id])
      if logged_in? && @list.user == current_user
        @list.delete
        redirect "/lists"
      elsif !logged_in? || @list.user == current_user
        erb :'/lists/error'
      else
        erb :'/lists/error'
      end
    end

end
