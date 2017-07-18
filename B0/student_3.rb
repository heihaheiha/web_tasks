#!/usr/bin/ruby
#coding=UTF-8

class Student
  #访问器方法
  attr_accessor :id, :name, :gender, :age
  #初始化方法
  def initialize(id, na, sex, year)
	@id, @name, @gender, @age = id, na, sex, year
  end
end
#随机生成姓名的函数
def randName (len)
  chars = ('a'..'z').to_a + ('A'..'Z').to_a
  randName = ""
  1.upto(len) { |i| randName << chars[rand(chars.size-1)] }
  return randName
end
#数组中每个元素来保存一个hash类型的元素，然后每一个Hash类型的元素来存放一个学生信息
arr = []
i = 1
100.times{
  j = rand(15..20)%2
  if j==0
    sex = String.new("female")
  elsif sex = String.new("male")
  end
  stu = Student.new(i, randName(4), sex, rand(15..20))
  stu2 = Hash["id" => stu.id, "name" => stu.name, "gender" => stu.gender, "age" => stu.age]
  arr << stu2
  i +=1
}
=begin
def saveFile
  aFile = File.new("studentMessage.yml","a+")
      if aFile
        aFile.syswrite(arr)
      elsif puts "Unable to open file!"
      end
end
=end
#将数据存放到yml文件中，不过从yml文件中读取数据有问题
#File.open("studentMessage1.yml")
if File::exists?("studentMessage1.yml")
  print "学生信息是：\n"
#  puts arr
elsif 
    aFile = File.new("studentMessage1.yml","a+")
      if aFile
        aFile.syswrite(arr)
      elsif puts "Unable to open file!"
      end
end 

#进行增删改查的操作
begin
  puts "请输入你想要做的事情[输入1：查询；输入2：删除；输入3：增加；输入4：修改；输入5：打印；输入6：退出]"
  val = gets
  case val.to_i(10)
  when 1
    puts "请输入你想要查找的ID值[范围是1-100]"
    val = gets
    i = 0
    len = arr.length
    case val.to_i(10)
  when 1..len
    len.times{
    if arr[i]['id'] == val.to_i(10)
      puts "学生信息：#{arr[i]}"
      break
    elsif i += 1 
    end
    #  puts arr[1]
    }
    if i == len
      puts "查无此人"
      else puts "查询成功"
    end
  else 
  puts "查无此人"
  end
    #puts "right1"
  when 2
    puts "请输入你想要删除的ID值"
    val = gets
    i = 0
    len = arr.length
  case val.to_i(10)
    when 1..len
    len.times{
      if arr[i]['id'] == val.to_i(10)
        arr.delete_at(i)
        break
      elsif i += 1 
      end
  #  puts arr[1]
    }
    if i == len
      puts "查无此人"
      else puts "删除成功"
    end
  else 
    puts "查无此人"
  end
  when 3
    puts "请输入学生的ID值"
    valId = gets
    puts "请输入学生的name值"
    valName = gets
    puts "请输入学生的gender值"
    valGender = gets
    puts "请输入学生的age值"
    valAge = gets
    stu = Hash["id" => valId.chomp, "name" => valName.chomp, "gender" => valGender.chomp, "age" => valAge.chomp]
    arr << stu
    #puts arr
    #puts "right3"
  when 4
    i = 0
    len = arr.length
    puts "请输入你想要修改的学生信息的ID值"
    val = gets
    case val.to_i(10)
    when 1..len
      len.times{
        if arr[i]['id'] == val.to_i(10)
        puts "该学生信息： #{arr[i]}"
        puts "请输入想要修改的学生的信息(输入1：id,输入2：name,输入3：gender,输入4：age中的一个)"
        info = gets
        #puts info
        case info.to_i(10)
        when 1
          puts "输入修改后的学生ID"
          valId = gets
          arr[i]['id'] = valId.chomp
          break
        when 2
          puts "输入修改后的学生name"
          valIdName = gets
          arr[i]['id'] = valName.chomp
          break
        when 3
          puts "输入修改后的学生gender"
          valGeder = gets
          arr[i]['id'] = valGender.chomp
          break
        when 4
          puts "输入修改后的学生age"
          valAge = gets
          arr[i]['id'] = valAge.chomp
          break
        else 
          puts "输入信息不对，已退出当前操作" 
          break
        end
        break
        elsif i += 1 
    end
    }
    if i == len
      puts "查无此人"
      else puts "修改成功"
    end
    else 
      puts "查无此人"
    end
    #puts arr
    #puts "right4"
  when 5
    puts arr
  when 6
    puts "退出"
    break
  else 
    puts "输入有误"
  end
  puts "是否退出(退出输入6，否则输入任意数字)"
  yesOrNo = gets
end until yesOrNo.to_i(10) == 6   
puts "操作结束"