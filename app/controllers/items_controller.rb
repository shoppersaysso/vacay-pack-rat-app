class ItemsController < ApplicationController


    get "/items" do
      if logged_in?
        @user = current_user
        erb :"/items/index"
      else
        redirect '/login'
      end
    end

    get "/items/:id" do
      @user = current_user
      @item = Item.find_by_id(params[:id])
      @list = List.find_by_id(params[:id])
      if !logged_in?
        redirect '/login'
      else
        erb :"/items/edit"
      end
    end

    get "/items/:id/edit" do
      if logged_in?
        @item = Item.find_by_id(params[:id])
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
      if params[:name] == ""
        flash[:notice] = "Name can't be blank!"
        redirect "/items/#{params[:id]}/edit"
      else
        @item = Item.find(params[:id])
        @item.update(name: params[:name])
        redirect "/items"
      end
    end

    delete "/items/:id/delete" do
      @user = current_user
      @item = Item.find_by_id(params[:id])
      if logged_in? && @item.user_id == session[:user_id]
        @item.delete
        redirect "/lists"
      elsif !logged_in? || @item.user_id != session[:user_id]
        erb :'/items/error'
      else
        erb :'/items/error'
      end
    end

end
