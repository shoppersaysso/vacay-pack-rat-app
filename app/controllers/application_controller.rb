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
       redirect '/users/home'
     else
       erb :index
     end
   end

end
