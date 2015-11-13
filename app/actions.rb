include FileUtils::Verbose

get '/' do
  erb :index
end

# get '/posts' do
#   @posts = Track.all
#   erb :'tracks/index'
# end

# get '/posts/new' do
#   @track = Post.new
#   erb :'posts/new'
# end

# get '/posts/:id' do
#   @Post = Post.find params[:id]
#   erb :'posts/show'
# end

# post '/posts' do
#   @Post = Post.new(
#     title: params[:title],
#     author:  params[:author],
#   )
#   if @post.save
#     redirect '/posts'
#   else
#     erb :'posts/new'
#   end
# end

helpers do
  def current_user
    if session[:id] and user = User.find(session[:id])
      user
    end
  end
end

get "/" do
   if @user = current_user
     @posts = @user.posts
     erb :posts
   else
     erb :login
   end
end

get '/login' do
  erb :'login'
end


post "/login" do
   if @user = User.find_by_username(params[:username]) 
     session[:id] = @user.id
     redirect "/profile"
   else
     @error = "Wrong email/password"
     redirect "/"
   end
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
  if @user.save
    session[:id] = @user.id
    tempfile = params[:file][:tempfile]
    filename = params[:file][:filename]
    cp(tempfile.path, "public/uploads/#{@user.id}")
    redirect '/profile'
  else
    erb :'/register'
  end
end

get '/users' do
  @user = User.new
  erb :"/users"
end

post '/users' do
  # binding.pry
  if params[:instrument].present? && params[:style].present?
    @users = User.where(instrument: params[:instrument]).where(style: params[:style])
  elsif params[:instrument].present?
    @users = User.where(instrument: params[:instrument])
  elsif params[:style].present?
    @users = User.where(style: params[:style])
  end
  redirect "/results"
end

get '/results' do
  # binding.pry
  if params[:instrument].present? && params[:style].present?
    @users = User.where(instrument: params[:instrument]).where(style: params[:style])
  elsif params[:instrument].present?
    @users = User.where(instrument: params[:instrument])
  elsif params[:style].present?
    @users = User.where(style: params[:style])
  end
  erb :'results'
end

get '/users/:id' do
  @user = User.find params[:id]
  erb :'/show'
end





