require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
   use Rack::Flash


   configure do
     set :public_folder, 'public'
     set :views, 'app/views'
     enable :sessions
     set :session_secret, "pack_rat_secret"
   end

   get "/" do
     if logged_in?
       redirect '/home'
     else
       erb :index
     end
   end

   get "/login" do
    if logged_in?
      redirect '/home'
    else
      erb :"/users/login"
    end
  end

  get "/signup" do
    if logged_in?
      flash[:notice] = "You're already logged in! Redirecting..."
      redirect '/home'
    else
      erb :"/users/signup"
    end
  end


  post "/signup" do
    if params[:username] == "" || params[:password] == "" || params[:email] == ""
      flash[:error] = "You have missing required fields."
      redirect '/signup'
    else
      @user = User.create(username: params["username"], email: params["email"], password: params["password"])
      session[:user_id] = @user.id
      @user.save
      flash[:notice] = "Welcome, Pack Rat!"
      redirect '/home'
    end
  end


  post "/login" do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.username}!"
      redirect '/home'
    else
      flash[:error] = "Login failed!"
      redirect '/login'
    end
  end

   get "/logout" do
     if logged_in?
       session.clear
       redirect '/'
     else
       session.clear
       redirect '/'
     end
   end

   helpers do
     def current_user
       @current_user ||= User.find(session[:user_id]) if session[:user_id]
     end

     def logged_in?
       !!current_user
     end
   end
end
