class Controller < ApplicationController

  get "/items/new" do
      @user = current_user
      if logged_in?
        erb :"/items/new"
      else
        redirect '/login'
      end
    end

    post "/new" do
      if logged_in? && params[:name] != ""
        @user = current_user
        @item = Item.create(name: params["name"], user_id: params[:user_id])
        @item.save
        erb :"//show"
      elsif logged_in? && params[:name] == ""
        flash[:notice] = "Your item name is blank!"
        redirect '/items/new'
      else
        flash[:notice] = "Please log in to proceed"
        redirect '/login'
      end
    end

    get "/" do
      if logged_in?
        @user = current_user
        erb :"/items/index"
      else
        redirect '/login'
      end
    end

    get "//:id" do
      @user = current_user
      @item = Item.find_by_id(params[:id])
      if !logged_in?
        redirect '/login'
      else
        erb :"/items/show"
      end
    end

    get "/items/:id/edit" do
      if logged_in?
        @item = item.find(params[:id])
        if @item.user_id == session[:user_id]
        erb :'/items/edit'
        else
          redirect '/login'
        end
      else
        redirect '/login'
      end
    end

    patch "/items/:id" do
      if params[:content] == ""
        flash[:notice] = "Please enter content to proceed"
        redirect "//#{params[:id]}/edit"
      else
        @item = Item.find(params[:id])
        @item.update(content: params[:content])
        redirect "//#{@item.id}"
      end
    end

    delete "/items/:id/delete" do
      @user = current_user
      @item = Item.find_by_id(params[:id])
      if logged_in? && @item.user_id == session[:user_id]
        @item.delete
        erb :'//delete'
      elsif !logged_in? || @item.user_id != session[:user_id]
        erb :'//error'
      else
        erb :'//error'
      end
    end

end
