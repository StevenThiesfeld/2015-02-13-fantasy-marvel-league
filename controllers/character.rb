#------------------------------------------------------------------------------
#CHARACTER AND SEARCH ROUTES
#------------------------------------------------------------------------------
post "/char_add" do
  @char = Character.new(params)
  @char.insert("characters")
  erb :"character/confirm_add"
end

get "/char_swap_user/:id" do
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

get "/all_characters" do
  @users = User.all("users")
  erb :"character/all_characters"
end

get "/delete_char/:id" do
  char =  Character.find("characters", params["id"])
  char.user_id = 0
  char.team_id = 0
  char.save("characters")
  redirect "/characters"
end  