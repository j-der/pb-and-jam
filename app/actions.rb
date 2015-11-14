include FileUtils::Verbose
use RouteDowncaser::DowncaseRouteMiddleware

helpers do
  def current_user
    if session[:id] and @user = User.find(session[:id])
      @user
    end
  end
end

get '/foo' do
  "Hello"
end

get "/" do
   if @user = current_user
     redirect "/main"
   else
     erb :index
   end
end

post "/" do
   if @user = User.find_by_username(params[:username].upcase) and @user.authenticate(params[:password])
     session[:id] = @user.id
     redirect "/main"
   else
     @error = "Wrong email/password"
     erb :index
   end
end

get '/posts/:id' do
  @Post = Post.find params[:id]
  erb :'main'
end

post '/posts' do
  @post = Post.new(
    content: params[:content],
    username:  current_user.username
    )
    @post.user_id = current_user.id
  if @post.save
    redirect '/main'
  else
    erb :'main'
  end
end

get '/main' do
  @posts = Post.all
  erb :'main'
end



get '/profile' do
  @user = current_user
  erb :'profile'
end

get "/logout" do
  session.clear
  redirect "/"
end

get '/register' do
  @user = User.new
  erb :register
end

post '/register' do
  @user = User.new(params[:user])
     @user.username.upcase!
  if @user.save
    session[:id] = @user.id
    if params[:file].present?
      tempfile = params[:file][:tempfile]
      filename = params[:file][:filename]
      cp(tempfile.path, "public/uploads/#{@user.id}")
      redirect '/profile'
    else
      redirect '/profile'
    end
  else
    erb :'/register'
  end
end



get '/users' do
  if params[:instrument].present? && params[:style].present?
    @users = User.where(instrument: params[:instrument].downcase, style: params[:style].downcase)
  elsif params[:instrument].present?
    @users = User.where(instrument: params[:instrument].downcase)
  elsif params[:style].present?
    @users = User.where(style: params[:style].downcase)
  else
    @users = User.all
  end
  erb :'users'
end

get '/users/:id' do
  @user = User.find params[:id]
  erb :'/show'
end





