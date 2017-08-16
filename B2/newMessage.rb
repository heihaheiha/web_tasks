#newMessage.rb
require 'mysql2'
require 'sinatra'
require 'active_record'
require 'yaml'
require 'digest/sha1'
dbconfig = YAML::load(File.open('db/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)
#创建表
ActiveRecord::Schema.define do
  #drop_table :users
  if !table_exists? :users
  	create_table :users do |t|
  	  t.column :username, :string
  	  t.column :password, :string
  	end
  end
  #drop_table :messages
  if !table_exists? :messages
  	create_table :messages do |t|
      t.column :content, :string
      t.column :user_id, :string
      t.column :created_at, :date
  	end
  	add_foreign_key :messages, :user
  end
end

class User < ActiveRecord::Base
  self.table_name = "users"
  validates :username, length: { minimum: 2 }
  validates :password, length: { minimum: 6 }
  has_many :messages, dependent: :destroy
end

class Message < ActiveRecord::Base
  self.table_name = "messages"
  validates :content, length: { minimum: 10 }
  belongs_to :user
end

configure do
  enable :sessions
end

get '/signup' do
  erb :register
end
#注册
post '/signup' do
  if session['name'] != nil
    userSign_name = params[:userSignName]
    userSign_pass = params[:userSignPass].to_s
    userSignCon_pass = params[:userSignConPass].to_s  
    if !User.find_by(username: userSign_name)
      if userSign_pass.eql?(userSignCon_pass)
        "name = " << session['name'].inspect
  	    session['name'] = userSign_name
  	    @user1 = User.new(username: userSign_name, password: userSign_pass)
        @user1.valid?
        if @user1.errors.size != 0
          erb :register
        else 
          @user1.save
          @user1.update(password: Digest::SHA1.hexdigest(userSign_pass))
          redirect '/'
        end
      else
        @language = "Two input password must be consistent"
        erb :register
      end
    else
      @language = "the username has existed"
      erb :register
    end
  else
    @language = "you have to login"
    erb :error
  end
end

get '/login' do
  if session['name'] == nil
    erb :login
  else 
    @language = "you have logined"
    erb :error
  end
end
#登录
post '/login' do
  if session['name'] != nil
    userLogin_name = params[:userLoginName]
    userLogin_pass = params[:userLoginPass]
    loginUser = User.find_by(username: userLogin_name)
    if !loginUser
      @language = "the username hasn't existed"
      erb :error 
    else
      if loginUser.password == Digest::SHA1.hexdigest(userLogin_pass)
        "userLogin_name =" << session['name'].inspect
        session['name'] = userLogin_name
        redirect '/'
      else
        @language = "the password id wrong"
        erb :error
      end
    end
  else
    @language = "you have to login"
    erb :error
  end
end

get '/' do
  erb :inquery
end
#查看个人信息
get '/look' do
  if session['name'] != nil
    @arr =[]
    @arr.clear
    user = User.find_by(username: session['name'])
    @arr = user.messages
    if @arr.empty?
      @message = "the author doesn't leave messages"
    end
    erb :ownInfo
  else
    redirect to '/login'
  end
end
#查看所有人的留言
get '/posts' do
  if session['name'] != nil
    id_t = params[:find_id].to_s
    author_t = params[:find_author].to_s
    infomations = Message.all
    @arr = []
    len = infomations.length
    i = 0
    len.times do |i|
      infomations[i].user_id = User.find_by(id: infomations[i].user_id).username
    end
    if len == 0
      @language = "no content"
      erb :error
      #judge if it hasn't parameters,if it hasn't parameters,it show all the data
    elsif id_t.empty? and author_t.empty?
      @arr.clear
      @arr = infomations
      erb :seeMess
      #show the specified author data
    elsif id_t.empty?
      #find author
      i = 0
      @arr.clear
      user = User.find_by(username: author_t)
      if !user
        @language = "this file hasn't haved the author"
        erb :error
      else 
        @arr = user.messages
        if @arr.empty?
          @message = "the author doesn't leave messages"
        end
        erb :seeMess
      end
      #show the specified id data
    elsif author_t.empty?
      #find id
      i = 0
      @arr.clear
      len.times{
        if infomations[i].id.to_s.eql?(id_t)
          @arr << infomations[i]
          break
        else 
          i += 1
        end
      }
      #judge whether it has the id
      if i == len
        @language = "the id isn't existed"
        erb :error
      else 
        erb :seeMess
      end
      #when it transfers two parameters,it will show the error data
    else
      @language = "You have inputed two options"
      erb :error
    end
  else
    redirect '/login'
  end
end

#尝试删除对应ID的留言，向用户返回操作结果
get '/deleteid/:id' do
  if session['name'] != nil
    id_s = params[:id].to_s
    infomations = Message.all
    len = infomations.length
    i = 0
    #judge whether the id is existed
    len.times{
      if infomations[i].id.to_s.eql?(id_s)
        infomations[i].destroy
        redirect '/posts?find_id=&find_author='
        break
      else i += 1
      end
    }
  else 
    redirect to '/login'
  end
end

#尝试删除对应user and 留言，
get '/deleteau/:author' do
  if session['name'] != nil
    author_s = params[:author].to_s
    user = User.find_by(username: author_s)
    if !user
      @language = "the author name is wrong"
      erb :error
    else
      user.messages.each do |m|
        m.destroy
      end
      redirect '/posts'
    end
  else 
    redirect to '/login'
  end
end

#enter the leave message page
get '/add' do
  if session['name'] != nil
    erb :addMess
  else
    redirect to '/login'
  end
end

post '/add' do
  if session['name'] != nil
    user1 = User.find_by(username: session['name'])
    leaveMes_f = params[:content].to_s
    message = user1.messages.new(content: leaveMes_f)
    message.valid?
    #because the $num is global variable,so when the submit button is on click,it will add one
    if message.errors.size != 0
      @language = "the length of content is less than 10"
      erb :error
    else
      message.save
      redirect '/'
    end
  else
    @language = "you have to login"
    erb :error
  end
end
#退出
get '/back' do
  session['name'] = nil
  redirect to '/' 
end

get '/change' do 
  if session['name'] != nil
    erb :changePass
  else
    redirect to '/login'
  end
end
#更改密码
post '/change' do 
  if session['name'] != nil
    userLogin_name = session['name']
    userOld_pass = params[:userOldPass].to_s
    userNew_pass = params[:userNewPass].to_s
    userNewCon_pass = params[:userNewConPass].to_s
    loginUser = User.find_by(username: userLogin_name)
    if loginUser.password == Digest::SHA1.hexdigest(userOld_pass)
      if userNew_pass.eql?(userNewCon_pass)  
        loginUser.update(password: userNew_pass)
        if loginUser.errors.size != 0
          @user1 = User.new
          @user1 = loginUser
          erb :changePass
        else
          loginUser.update(password: Digest::SHA1.hexdigest(userNew_pass))
          @language = "modify password successfully"
          erb :error
        end
      else
        @language = "Two input new password must be consistent"
        erb :changePass
      end
    else
      @language = "the password id wrong"
      erb :changePass
    end
  else
    @language = "you have to login"
    erb :error
  end
end