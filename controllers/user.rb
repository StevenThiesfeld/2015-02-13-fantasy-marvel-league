#------------------------------------------------------------------------------
#LOGIN/USER ROUTES
#------------------------------------------------------------------------------    
get "/" do
  erb :"user/login", :layout => :"layout_login"
end

get "/logout" do
  session.clear
  redirect "/"
end

get "/user_verification" do
  user_check = User.login(params)
  if user_check == nil
    @error = "Invalid Login Info" 
    erb :"user/login", :layout => :"layout_login"
  else
    session[:user] = user_check
    redirect "/user_profile"
  end
end

get "/user_setup" do
  erb :"user/user_setup", :layout => :"layout_login" 
end

get "/confirm_creation" do
  @new_user = User.new(params)
  erb :"user/confirm_creation", :layout => :"layout_login"
end

get "/create_profile" do
  session[:user] = User.new(params)
  session[:user].insert("users")
  session[:user].user_setup
  redirect "/user_profile"
end

get "/user_profile" do
  @unviewed_messages = Message.get_unviewed_messages(session[:user].id)
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