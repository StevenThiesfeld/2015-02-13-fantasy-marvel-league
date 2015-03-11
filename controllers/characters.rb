#------------------------------------------------------------------------------
#CHARACTER AND SEARCH ROUTES
#------------------------------------------------------------------------------
post "/characters/add" do
  @char = Character.create(params)
  redirect "/characters"
end

post "/characters/swap_user" do
  char = Character.find(params["id"])
  char.update({user_id: @current_user.id, team_id: 0})
  redirect "/characters"
end
  

get "/characters" do
  @characters = @current_user.characters
  erb :"characters/characters"
end

get "/characters/all" do
  @users = User.all
  erb :"characters/all"
end

get "/characters/delete/:id" do
  char =  Character.find(params["id"])
  char.update({team_id: 0, user_id: 0})
  redirect "/characters"
end  