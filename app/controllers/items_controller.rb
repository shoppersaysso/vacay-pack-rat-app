class ItemsController < ApplicationController


    get "/items" do
      if logged_in?

        erb :"/items/index"
      else
        redirect '/login'
      end
    end

    get "/items/:id" do
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
      @item = Item.find(params[:id])
      @item.update(name: params[:name])
      redirect "/lists/#{@item.list_id}"
    end

    delete "/items/:id/delete" do
      @item = Item.find_by_id(params[:id])
      @list = @item.lists
      @list = @item.list_id
      if logged_in? && @item.user_id == session[:user_id]
        @item.delete
        redirect '/lists'
      elsif !logged_in? || @item.user_id != session[:user_id]
        erb :'error'
      else
        erb :'error'
      end
    end

end
