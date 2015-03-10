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
  if user = User.find_by(params)
    session[:user] = user
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
  new_user = User.create(params)
   @errors = new_user.errors
  if @errors == {}
    erb :"user/confirm_creation", :layout => :"layout_login"
  else
    erb :"user/setup", :layout => :"layout_login" 
  end
end

post "/user/create_profile" do
  session[:user] = User.create(params)
  session[:user].user_setup
  redirect "/user/profile"
end

get "/user/profile" do
  @unviewed_messages = Message.where(to_user_id: session[:user].id, viewed: "no").reverse_order
  erb :"user/profile"
end

get "/user/edit_profile" do
  erb :"user/edit_profile"
end

post "/user/confirm_edit" do
  session[:user].update(params)
  redirect "/user_profile"
end

get "/user/delete_profile" do
  erb :"user/delete_profile"
end

get "/user/confirm_delete" do
  session[:user].delete_user
  redirect "/logout"
end