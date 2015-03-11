#------------------------------------------------------------------------------
#LOGIN/USER ROUTES
#------------------------------------------------------------------------------ 


before do
  if request.path_info.include?("/login") == false
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    else
      redirect "/login"
    end
  end
end  

get "/login" do
  erb :"user/login", :layout => :"layout_login"
end

get "/logout" do
  session[:user_id] = nil
  redirect "/"
end

post "/login/user/verification" do
  binding.pry
  if user = User.find_by(name: params["name"])
    binding.pry
    if BCrypt::Password.new(user.password) == params["password"]
      session[:user_id] = user.id
      redirect "/user/profile"
    else
      @error = "invalid Password"
      erb :"user/login", :layout => :"layout_login"
    end
  else
    @error = "Invalid User Name"
    erb :"user/login", :layout => :"layout_login"
  end
end

get "/login/user/setup" do
  
  erb :"user/setup", :layout => :"layout_login" 
end

post "/login/user/confirm_creation" do #error check goes here
  new_user = User.create(params)
   @errors = new_user.errors
  if @errors == {}
    erb :"user/confirm_creation", :layout => :"layout_login"
  else
    erb :"user/setup", :layout => :"layout_login" 
  end
end

post "/login/user/create_profile" do
  params["password"] = BCrypt::Password.create(params["password"])
  @current_user = User.create(params)
  @current_user.user_setup
  session[:user_id] = @current_user.id
  redirect "/user/profile"
end

get "/user/profile" do
  @unviewed_messages = Message.where(to_user_id: @current_user.id, viewed: "no").reverse_order
  erb :"user/profile"
end

get "/user/edit_profile" do
  erb :"user/edit_profile"
end

post "/user/confirm_edit" do
  @current_user.update(params)
  redirect "/user_profile"
end

get "/user/delete_profile" do
  erb :"user/delete_profile"
end

get "/user/confirm_delete" do
  @current_user.delete_user
  redirect "/logout"
end