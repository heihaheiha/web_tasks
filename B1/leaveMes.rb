require 'sinatra'
require 'yaml'
#find leaveMessage
#显示所有留言，留言按照倒叙的方式输出，每条留言后面有删除按钮，表单有两个
#输入框和提交框，使用ID或者是author俩筛选，进入 /?id=1 或者 /?author=some 
#的页面
$num = 0
$arr = []
get '/' do
  erb :inquery
end

#enter the show data page
get '/posts' do
  id_t = params[:find_id].to_s
  author_t = params[:find_author].to_s
  arrStore = []
  if File::exists?('storeLeaveMessage.yml')
  	con = YAML.load(File.open('storeLeaveMessage.yml'))
  	con.each do |p|
  	  arrStore << p
  	end
    len = arrStore.length
    if len == 0
      @language = "no content"
      erb :error
      break
    #judge if it hasn't parameters,if it hasn't parameters,it show all the data
    elsif id_t.empty? and author_t.empty?
    $arr = arrStore
    erb :seeMess
    #show the specified author data
    elsif id_t.empty?
    #find author
    i = 0
    puts "enter id_t.empty?"
    puts author_t
    $arr.clear
    len.times{
      puts arrStore[i]["author"]
      if author_t.eql?(arrStore[i]["author"].to_s)
        puts arrStore[i]["author"]
        $arr << arrStore[i]
        i += 1
      else i += 1
      end
    }
    puts $arr
    if $arr.length == 0
      @language = "this file hasn't haved the author"
      erb :error
    else
      erb :seeMess
    end
    #show the specified id data
    elsif author_t.empty?
    #find id
    i = 0
    #puts "enter author_t.empty?"
    #puts len
    $arr.clear
    len.times{
      if arrStore[i]["id"].to_s.eql?(id_t)
        $arr << arrStore[i]
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
      puts "enter the else"
      @language = "You have inputed two options"
      erb :error
    end
  #when the file doesn't existed,it will show the error page
  else 
    puts "1"
  	@language = "you haven't downloaded the file called storeLeaveMessage.yml"
  	erb :error
  end
end
#enter the leave message page
get '/add' do
  erb :addMess
end
#尝试删除对应ID的留言，向用户返回操作结果
get '/delete/:id' do
  id_s = params[:id].to_s
  puts id_s
  if id_s.empty?
  	@language = "the length of id is zero"
  	erb :error
  else
    puts "enter"
    arrStore = []
    con = YAML.load(File.open('storeLeaveMessage.yml'))
    con.each do |p|
      arrStore << p
    end
    len = arrStore.length
    puts len
    i = 0
    #judge whether the id is existed
    len.times{
      #puts i
      if arrStore[i]['id'].to_s.eql?(id_s)
        arrStore.delete_at(i)
        File.open('storeLeaveMessage.yml', 'w') do |os|
          YAML::dump(arrStore, os)
        end
        redirect '/posts?find_id=&find_author='
        break
      else i += 1
      end
    }
    if i == len 
      @language = "id isn't existed in the file"
      erb :error
    end
  end
end
#form表单传送message和author信息，收到前先验证数据，保证内容不为空，然后插
#入数据，并且返回主页，若失败，则是因为插入的内容为空，那么就返回错误
#信息，信息上有一个前往主页的链接
post '/add' do
  class LeMess
  	attr_accessor :id, :author, :content, :time
  	def initialize(i, w, l, t)
  	  @id, @author, @content, @time = i, w, l, t
  	end
  end
  arrStore = []
  if File::exists?('storeLeaveMessage.yml') and $num == 0
  	con = YAML.load(File.open('storeLeaveMessage.yml'))
  	con.each do |p|
  	  arrStore << p
  	end
  	$num = arrStore[arrStore.length-1]["id"]
  	$num = $num+1
  	id_f = $num
  else
    $num = $num+1
    id_f = $num  
  end
  writer_f = params[:awriter].to_s
  leaveMes_f = params[:content].to_s
  time_f = Time.new
  puts writer_f
  puts leaveMes_f
  #arr1 = []
  if leaveMes_f.length <= 10
  	@language = "the length of content is less than 10"
  	erb :error
  elsif writer_f.empty?
  	@language = "the length of author is zero"
  	erb :error
  else
  	message = LeMess.new(id_f, writer_f.chomp, leaveMes_f.chomp, time_f.strftime("%Y-%m-%d %H:%M:%S"))
    mess1 = Hash["id" => message.id, "author" => message.author, "content" => message.content, "time" => message.time]
    con = YAML.load(File.open('storeLeaveMessage.yml'))
    con.each do |p|
      arrStore << p
    end
      arrStore << mess1
      File.open('storeLeaveMessage.yml', 'w') do |os|
        YAML::dump(arrStore, os)
      end
    redirect '/'
  end
end