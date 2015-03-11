#------------------------------------------------------------------------------
#TEAM ROUTES
#------------------------------------------------------------------------------
get "/teams" do
  @teams = @current_user.teams
    erb :"teams/teams"
end

get "/teams/all" do
  @users = User.all
  erb :"teams/all"
end

get "/teams/details/:slug" do
  @team = Team.find_by(slug: params["slug"])[0]
  @team_chars = @team.characters
  erb :"teams/details"
end

get "/teams/new" do 
  erb :"teams/new"
end  

post "/teams/create" do
  @new_team = Team.create(params)
  if @new_team.errors == []
    redirect "/teams"
  else
    @error = "Please Enter a Name"
    erb :"teams/new"
  end
end


get "/teams/edit/:id" do 
  @team = Team.find(params["id"])
  erb :"teams/edit"
end

get "/teams/confirm_edit" do
  team = Team.find(params["id"])
  team.update(params)
  team.set_slug
  team.save
  redirect "/teams"
end

get "/teams/delete/:id" do
  @team = Team.find(params["id"])
  erb :"teams/confirm_delete"
end

get "/teams/confirm_delete/:id" do
  team = Team.find(params["id"]) 
  team.destroy
  redirect "/teams" 
end

post "/teams/assign" do
  char_to_assign = Character.find(params["char_to_assign"])
  char_to_assign.update(team_id: params["team_id"])
  redirect "/teams"
end

get "/teams/unassign/:id" do
  char_to_unassign = Character.find(params["id"])
  char_to_unassign.update(team_id: 0)
  redirect "/teams"
end
