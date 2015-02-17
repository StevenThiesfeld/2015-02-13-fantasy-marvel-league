require 'pry'
require 'sqlite3'
DATABASE = SQLite3::Database.new('database/f_m_l.db')
require 'marvelite'
require_relative "database/db_setup"
require_relative "helper_modules/model_helper"
require_relative "helper_modules/main_helper"
require_relative "database/database_methods"
require "sinatra"
require_relative "models/wishlist"
require_relative "models/user"
require_relative "models/team"
require_relative "models/search_engine"
require_relative "models/character"


enable :sessions


get "/" do
  erb :login
end

get "/logout" do
  session[:user] == nil
  erb :login
end

get "/user_verification" do
  user_check = User.login(params)
  if user_check == nil
    @error = "Invalid Login Info" 
    erb :login
  else
    session[:user] = user_check
    erb :"user/user_profile"
  end
end

get "/user_setup" do
  erb :"user/user_setup"
end

get "/confirm_creation" do
  @new_user = User.new(params)
  erb :"user/confirm_creation"
end

before "/user_profile" do
  if request.referrer.include?("confirm_creation")
    session[:user] = User.new(params)
    session[:user].insert("users")
    session[:user].user_setup
  end
end

get "/user_profile" do
  erb :"user/user_profile"
end

before "/teams" do
  if request.referrer.include?("create_team")
    new_team = Team.new(params)
    new_team.insert("teams")
  end
end

get "/teams" do
  @teams = Team.search_where("teams", "user_id", session[:user].id)
  if @teams == []  
    redirect "/create_team"
  else
    erb :"team/teams"
  end
end

get "/create_team" do 
  erb :"team/create_team"
end  

get "/wishlist" do
  result = Wishlist.search_where("wishlists", "user_id", session[:user].id)
  @wishlist = result[0]
  erb :"wishlist"
end

get "/search" do
  erb :"search"
end

get "/search_results" do
  result = SearchEngine.new(params)
  @character = result.create_character(params["user_search"])
  @character.insert("characters")
  erb :"search_results"
end
    
      
  
