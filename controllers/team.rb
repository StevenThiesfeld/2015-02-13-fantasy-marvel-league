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
