require 'sinatra'
require 'yaml'
#find leaveMessage
class LeMess
  	attr_accessor :id, :author, :content, :time
  	def initialize(i, w, l, t)
  	  @id, @author, @content, @time = i, w, l, t
  	end
end

configure do
  $num = 0
  if File::exists?('storeLeaveMessage.yml') and !File.zero?("storeLeaveMessage.yml")
    $arrStore = []
    con = YAML.load(File.open('storeLeaveMessage.yml'))
  	  con.each do |p|
  	  $arrStore << p
    end
  else 
    $arrstore = []
  end
end

get '/' do
  erb :inquery
end

get '/posts' do
  id_t = params[:find_id].to_s
  author_t = params[:find_author].to_s
  @arr = []
  len = $arrStore.length
  if len == 0
    @language = "no content"
    erb :error
    #judge if it hasn't parameters,if it hasn't parameters,it show all the data
  elsif id_t.empty? and author_t.empty?
    @arr = $arrStore
    erb :seeMess
    #show the specified author data
  elsif id_t.empty?
    #find author
    i = 0
    @arr.clear
    len.times{
    #puts $arrStore[i]["author"]
      if author_t.eql?($arrStore[i]["author"].to_s)
      #puts $arrStore[i]["author"]
        @arr << $arrStore[i]
        i += 1
      else i += 1
      end
    }
    if @arr.length == 0
      @language = "this file hasn't haved the author"
      erb :error
    else
      erb :seeMess
    end
    #show the specified id data
  elsif author_t.empty?
    #find id
    i = 0
    @arr.clear
    len.times{
      if $arrStore[i]["id"].to_s.eql?(id_t)
        @arr << $arrStore[i]
        break
      else i += 1
      end
    }
    #judge whether it has the id
    if i == len
      @language = "the id isn't existed"
      erb :error
      else erb :seeMess
    end
    #when it transfers two parameters,it will show the error data
  else
    @language = "You have inputed two options"
    erb :error
  end
end

#尝试删除对应ID的留言，向用户返回操作结果
get '/delete/:id' do
  id_s = params[:id].to_s
  len = $arrStore.length
  i = 0
  #judge whether the id is existed
  len.times{
    if $arrStore[i]['id'].to_s.eql?(id_s)
      $arrStore.delete_at(i)
      redirect '/posts?find_id=&find_author='
      break
    else i += 1
    end
  }
end
#enter the leave message page
get '/add' do
  erb :addMess
end

post '/add' do
  #if the file is vacancy
  if $arrStore.length == 0
    $num == 0
  else 
    $num = $arrStore[$arrStore.length-1]["id"].to_i
  end
  $num = $num+1
  id_f = $num
  writer_f = params[:awriter].to_s
  leaveMes_f = params[:content].to_s
  time_f = Time.new
  #because the $num is global variable,so when the submit button is on click,it will add one
  if writer_f.empty?
  	@language = "the length of author is zero"
  	erb :error 
  elsif leaveMes_f.length < 10
  	@language = "the length of content is less than 10"
  	erb :error
  else
  	message = LeMess.new(id_f, writer_f.chomp, leaveMes_f.chomp, time_f.strftime("%Y-%m-%d %H:%M:%S"))
    mess1 = Hash["id" => message.id, "author" => message.author, "content" => message.content, "time" => message.time]
    $arrStore << mess1
    redirect '/'
  end
end
#edit
get '/modify/:id' do
  id_t = params[:id].to_s
  puts id_t
  i = 0
  len = $arrStore.length
  @arr = []
  #traverse the array
  len.times do |i|
    if $arrStore[i]["id"].to_s.eql?(id_t)
    	puts "enter"
      @arr << $arrStore[i]
      break
    end
  end
  erb :updated
end

post '/modify/:id' do
  id_t = params[:id].to_s
  author_t = params[:writer].to_s
  con_t = params[:content].to_s
  i = 0
  len = $arrStore.length
  #traverse the array
  len.times do |i|
    if $arrStore[i]["id"].to_s.eql?(id_t)
      $arrStore[i]["author"] = author_t
      $arrStore[i]["content"] = con_t
      break
    end
  end
  redirect to ('/')
end
#save result
File.open('storeLeaveMessage.yml', 'w') do |os|
  YAML::dump($arrStore, os)
end