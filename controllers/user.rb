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

post "/user/verification" do
  if User.login(params) 
    session[:user] = User.login(params)
    redirect "/user/profile"
  else
    @error = "Invalid Login Info"
    erb :"user/login", :layout => :"layout_login"
  end
end

get "/user/setup" do
  
  erb :"user/setup", :layout => :"layout_login" 
end

post "/user/confirm_creation" do #error check goes here
  new_user = User.new(params)
   @errors = new_user.error_check
  if @errors == {}
    erb :"user/confirm_creation", :layout => :"layout_login"
  else
    erb :"user/setup", :layout => :"layout_login" 
  end
end

post "/user/create_profile" do
  session[:user] = User.new(params)
  session[:user].insert("users")
  session[:user].user_setup
  redirect "/user/profile"
end

get "/user/profile" do
  @unviewed_messages = Message.get_unviewed_messages(session[:user].id)
  erb :"user/profile"
end

get "/user/edit_profile" do
  erb :"user/edit_profile"
end

post "/user/confirm_edit" do
  session[:user].edit_object(params)
  session[:user].save("users")
  redirect "/user_profile"
end

get "/user/delete_profile" do
  erb :"user/delete_profile"
end

get "/user/confirm_delete" do
  session[:user].delete_user
  redirect "/logout"
end