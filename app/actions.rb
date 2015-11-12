include FileUtils::Verbose

get '/' do
  erb :index
end

get '/posts' do
  @posts = Track.all
  erb :'tracks/index'
end

get '/posts/new' do
  @track = Post.new
  erb :'posts/new'
end

get '/posts/:id' do
  @Post = Post.find params[:id]
  erb :'posts/show'
end

post '/posts' do
  @Post = Post.new(
    title: params[:title],
    author:  params[:author],
  )
  if @post.save
    redirect '/posts'
  else
    erb :'posts/new'
  end
end

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
   #binding.pry
   if @user = User.find_by_email(params[:email]) #and @user.authenticate(params[:password])
     session[:id] = @user.id
     redirect "/posts"
   else
     @error = "Wrong email/password"
     redirect "/"
   end
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
    redirect '/'
  else
    erb :'/register'
  end
end
