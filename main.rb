require 'pry'
require 'sqlite3'
DATABASE = SQLite3::Database.new('database/f_m_l.db')
require 'marvelite'
require_relative "database/db_setup"
require_relative "helper_modules/main_helper"
require_relative "helper_modules/model_helper"
require_relative "database/database_methods"
require "sinatra"
require_relative "models/wishlist"
require_relative "models/user"
require_relative "models/team"
require_relative "models/search_engine"
require_relative "models/character"
require_relative "models/trade"


enable :sessions

helpers MainHelper, ModelHelper

#------------------------------------------------------------------------------
#LOGIN/USER ROUTES
#------------------------------------------------------------------------------    
get "/" do
  erb :login, :layout => :layout_login
end

get "/logout" do
  session[:user] == nil
  erb :login, :layout => :layout_login
end

get "/user_verification" do
  user_check = User.login(params)
  if user_check == nil
    @error = "Invalid Login Info" 
    erb :login, :layout => :layout_login
  else
    session[:user] = user_check
    erb :"user/user_profile"
  end
end

get "/user_setup" do
  erb :"user/user_setup", :layout => :layout_login 
end

get "/confirm_creation" do
  @new_user = User.new(params)
  erb :"user/confirm_creation", :layout => :layout_login
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

get "/edit_profile" do
  erb :"user/edit_profile"
end

get "/confirm_edit" do
  session[:user].edit_object(params)
  session[:user].save("users")
  redirect "/user_profile"
end

get "/delete_profile" do
  erb :"user/delete_profile"
end

get "/confirm_delete_user" do
  session[:user].delete_user
  redirect "/logout"
end

#------------------------------------------------------------------------------
#TEAM ROUTES
#------------------------------------------------------------------------------

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

get "/all_teams" do
  @users = User.all("users")
  erb :"team/all_teams"
end

get "/team_details" do
  @team = Team.find("teams", params["id"])
  @team_chars = @team.get_characters("team_id")
  erb :"team/team_details"
end

get "/create_team" do 
  erb :"team/create_team"
end  

get "/edit_team" do 
  @team = Team.find("teams", params["id"])
  erb :"team/edit_team"
end

get "/confirm_team_edit" do
  team = Team.find("teams", params["id"])
  team.edit_object(params)
  team.save("teams")
  redirect "/teams"
end

get "/delete_team" do
  @team = Team.find("teams", params["id"])
  erb :"team/confirm_delete_team"
end

get "/confirm_delete_team" do
  team = Team.find("teams", params["id"]) 
  team.delete
  redirect "/teams" 
end


#------------------------------------------------------------------------------
#WISHLIST ROUTES
#------------------------------------------------------------------------------

get "/wishlist" do
  @your_chars = session[:user].get_characters("user_id")
  @wishlist = Wishlist.search_where("wishlists", "user_id", session[:user].id)[0]
  @chars_on_wishlist = @wishlist.set_wishlist_chars(session[:user])
  erb :"wishlist/wishlist"
end

get "/all_wishlists" do
  @users = User.all("users")
  erb :"wishlist/all_wishlists"
end

get "/add_offer" do
  @wishlist = Wishlist.search_where("wishlists", "user_id", session[:user].id)[0]
  @wishlist.offer = params["name"]
  @wishlist.save("wishlists")
  redirect "/wishlist"
end

get "/add_to_wishlist" do
  wishlist = Wishlist.search_where("wishlists", "user_id", session[:user].id)[0]
  char = Character.search_where("characters", "name", params["name"])[0]
  wishlist.add_to_wishlist(char.id)
  redirect "/wishlist"
end

#------------------------------------------------------------------------------
#CHARACTER AND SEARCH ROUTES
#------------------------------------------------------------------------------
  

get "/search" do
  erb :"character/search"
end

get "/search_results" do
  results = SearchEngine.new(params)
  @char_results = results.create_character
  erb :"character/search_results"
end

get "/char_add" do
  char = Character.new(params)
  char.insert("characters")
  redirect "/characters"
end

get "/char_swap_user" do
  char = Character.find("characters", params["id"])
  char.user_id = session[:user].id
  char.team_id = 0
  char.save("characters")
  redirect "/characters"
end
  

get "/characters" do
  @characters = session[:user].get_characters("user_id")
  erb :"character/characters"
end

get "/assign" do
  char_to_assign = Character.find("characters", params["char_to_assign"])
  char_to_assign.team_id = params["team_id"]
  char_to_assign.save("characters")
  redirect "/teams"
end

get "/unassign" do
  char_to_unassign = Character.find("characters", params["id"])
  char_to_unassign.team_id = 0
  char_to_unassign.save("characters")
  redirect "/teams"
end

get "/delete_char" do
  char =  Character.find("characters", params["id"])
  char.user_id = 0
  char.team_id = 0
  char.save("characters")
  redirect "/characters"
end  

#------------------------------------------------------------------------------
#TRADE ROUTES
#------------------------------------------------------------------------------

get "/start_trade" do
  @user2 = User.find("users", params["id"])
  @trade = Trade.new("user1" => session[:user], "user2" => @user2)
  if @trade.valid_trade
    erb :"trade/start_trade"
  else erb :"trade/bad_trade"
  end
end

get "/confirm_trade" do
  char1 = Character.find("characters", params["char1_id"])
  char2 = Character.find("characters", params["char2_id"])
  char1.edit_object("team_id" => 0, "user_id" => params["user2_id"])
  char2.edit_object("team_id" => 0, "user_id" => session[:user].id)
  char1.save("characters")
  char2.save("characters")
  erb :"trade/trade_finished"
end
  
  
