#------------------------------------------------------------------------------
#TEAM ROUTES
#------------------------------------------------------------------------------
get "/teams" do
  @teams = Team.search_where("teams", "user_id", session[:user].id)
    erb :"teams/teams"
end

get "/teams/all" do
  @users = User.all("users")
  erb :"teams/all"
end

get "/teams/details/:slug" do
  @team = Team.search_where("teams", "slug", params["slug"])[0]
  @team_chars = @team.get_characters("team_id")
  erb :"teams/details"
end

get "/teams/new" do 
  erb :"teams/new"
end  

post "/teams/create" do
  new_team = Team.new(params)
  new_team.insert("teams")
  redirect "/teams"
end


get "/teams/edit/:id" do 
  @team = Team.find("teams", params["id"])
  erb :"teams/edit"
end

get "/teams/confirm_edit" do
  team = Team.find("teams", params["id"])
  team.edit_object(params)
  team.set_slug
  team.save("teams")
  redirect "/teams"
end

get "/teams/delete/:id" do
  @team = Team.find("teams", params["id"])
  erb :"teams/confirm_delete"
end

get "/teams/confirm_delete/:id" do
  team = Team.find("teams", params["id"]) 
  team.delete
  redirect "/teams" 
end

post "/teams/assign" do
  char_to_assign = Character.find("characters", params["char_to_assign"])
  char_to_assign.team_id = params["team_id"]
  char_to_assign.save("characters")
  redirect "/teams"
end

get "/teams/unassign/:id" do
  char_to_unassign = Character.find("characters", params["id"])
  char_to_unassign.team_id = 0
  char_to_unassign.save("characters")
  redirect "/teams"
end
