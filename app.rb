require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:troybook.sqlite3"
set :sessions, true
require './models'
get '/' do
  if session[:user_id]!=nil
    redirect '/wall'
  else
    erb :login
  end
end
post '/login' do
  username=params[:username]
  password=params[:password]
  user=User.where(username: username).first

  if password==user[:password]
    session[:user_id] = user.id
    redirect '/'
  else
    redirect '/'
  end
end



get '/create_account' do
  erb :create_account
end

get '/profile' do
    @user = User.find(session[:user_id])
    @friendships = Friendship.where(user_id: @user.id)
	@posts = @user.posts
	erb :profile
end
post '/profile' do
  title=params[:title]
  content=params[:content]
  userid=session[:user_id]
  Post.create(title: title, content: content, user_id: userid)
  redirect '/profile'
end
get '/sign_up' do
  erb :sign_up
end
post '/sign_up' do
  username=params[:username]
  password=params[:password]
  repassword=params[:repassword]
  if password != repassword
    @error="Passwords do not match. Please Re-enter Your Information."

    redirect '/sign_up'

  elsif !User.where(username: username)
    @error="Username already exists. Choose another one."
    redirect '/sign_up'
  else
    user=User.create(username: username, password: password, name: params[:name])
    session[:user_id]=user.id
    redirect '/profile'
  end
end

get '/post/:id' do
    post_id=params[:id]
    @post=Post.find(post_id)
    session[:post_id]=post_id
    @comments=Comment.where(user_id: session[:user_id], post_id: post_id)
    erb :post
end

post '/post' do
    user=User.find(session[:user_id])
    post=Post.find(session[:post_id])
    Comment.create(content: params[:comment], user_id: session[:user_id], post_id: session[:post_id])
    redirect '/post/' + session[:post_id]
end
get '/search' do
  users=User.all
friends=Friendship.all
@notfriends=[]
myfriends=Friendship.where("user_id= ? or friend_id= ?", session[:user_id], session[:user_id])
users.each do |user|
  boolean=true
  myfriends.each do |myfriend|
    if myfriend.user_id==user.id || myfriend.friend_id==user.id
      boolean=false
    end 

  end
  if boolean==true
    @notfriends.push(user)
  end
end

  erb :search
end

get '/logout' do
    session[:user_id] = nil
    erb :login
end





get '/friend_requests' do
    @requests = Request.where(user_id: session[:user_id])
    erb :friend_requests
end

post '/friend_requests' do
    response = params[:response]
    if response == "Accept"
        Friendship.create(user_id: session[:user_id], friend_id: params[:friend_id])
        Friendship.create(user_id: params[:friend_id], friend_id: session[:user_id])
    end
    Request.find(params[:request_id]).delete
    redirect '/friend_requests'
end


post '/request' do
  Request.create(user_id: params[:user_id], requester_id: session[:user_id])
  redirect '/search'
end

get '/edit_profile' do
    @user = User.find(session[:user_id])
    erb :edit_profile
end

post '/edit_profile' do
    @user = User.find(session[:user_id])
    @user.name = params[:new_name]
    @user.username = params[:new_username]
    @user.age = params[:new_age]
    @user.city = params[:new_city]
    @user.save

    redirect '/edit_profile'
end

post '/friendship' do
    friends = Friendship.where(user_id: session[:user_id], friend_id: params[:friend_id]).first
    reversefriends= Friendship.where(user_id: params[:friend_id], friend_id: session[:user_id]).first
    friends.delete
    reversefriends.delete

    redirect '/profile'
end

get '/wall' do
    friends=Friendship.where(user_id: session[:user_id])
    @posts=[]
    friends.each do |friend|
        @posts.push(Post.where(user_id: friend.friend_id))

    end
    @posts=@posts.flatten
    erb :wall
end
post '/addfile' do
  file=params[:file]
 
 s = File.open('philly-homeless-01.jpg', 'rb') { |io| io.read }
  s.force_encoding('ASCII-8BIT')
  redirect '/profile'
  Cat.create(user_id: session[:user_id], file: s)
end
