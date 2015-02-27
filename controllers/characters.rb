#------------------------------------------------------------------------------
#CHARACTER AND SEARCH ROUTES
#------------------------------------------------------------------------------
post "/characters/add" do
  @char = Character.new(params)
  @char.insert("characters")
  redirect "/characters"
end

post "/characters/swap_user" do
  char = Character.find("characters", params["id"])
  char.user_id = session[:user].id
  char.team_id = 0
  char.save("characters")
  redirect "/characters"
end
  

get "/characters" do
  @characters = session[:user].get_characters("user_id")
  erb :"characters/characters"
end

get "/characters/all" do
  @users = User.all("users")
  erb :"characters/all"
end

get "/characters/delete/:id" do
  char =  Character.find("characters", params["id"])
  char.user_id = 0
  char.team_id = 0
  char.save("characters")
  redirect "/characters"
end  