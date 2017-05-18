require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:troybook.sqlite3"
set :sessions, true
require './models'

get '/' do
    erb :login
end

post '/login' do
    username=params[:username]
    password=params[:password]
    user=User.where(username: username).first

    if password==user[:password]
        session[:user_id] = user.id
        redirect '/profile'
    else
        redirect '/'
    end]
end

get '/create_account' do
    erb :create_account
end

get '/profile' do
    @user = User.find(session[:user_id])
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
        user=User.create(username: username, password: password)
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

get '/logout' do
    session[:user_id] = nil
    erb :login
end

get 'friend_requests' do
    @requests = Request.where(user_id: session[:user_id])
end
