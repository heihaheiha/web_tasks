#!/usr/bin/ruby -w
#coding=utf-8
#按照惯例，名称必须以大写字母开头，如果包含多个单词，每个单词首字母大写，但此间没有分隔符（例如：CamelCase）。
class Student
	#访问器方法
	attr_accessor :id, :name, :gender, :age
	#构造函数
	def initialize(id,na,sex,age)
		#等号右边的空格
		#@id, @name, @gender, @age =id, na, sex, age
		#正确
		@id, @name, @gender, @age = id, na, sex, age
	end
=begin
	#访问器方法
	def printId
		@id
	end

	def printName
		@name
	end

	def printGender
		@gender
	end

	def printAge
		@age
	end	
=end	
end

def newpass( len )
	chars = ("a".."z").to_a + ("A".."Z").to_a
	newpass = ""
	1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
	return newpass
end
#创建student对象
i = 1
#for i in 1..100
100.times{
	#生成年龄的随机数，范围在15-18岁之间
	$j = rand(15..20)
	#通过随机数来判断性别，如果是偶数，那么是奴性，如果是奇数，那么是男性
	if $j%2 == 0
	   sex = String.new("female")
    elsif sex = String.new("male")
    end
   #通过上面定义的方法，随机生成一个4位数字的名字
	$name = newpass(4)
   #实例化student对象
	student = Student.new(i, $name, sex, $j)
   #调用对象的方法,没有参数时括号可以省略,通常来说,只有在可能引起混淆或影响代码可读性的情况下才将参数放在括号里
=begin
如果没有定各写，那么多行注释起不到效果
	x = student.printId()
	y = student.printAge()
	z = student.printGender()
	q = student.printName()
=end
=begin
method1:
	x = student.printId
	y = student.printAge
	z = student.printGender
	q = student.printName
	#输出关于对象的数值
	puts "id : #{x}"
	puts "name : #{q}"
	puts "gender : #{z}"
	puts "age : #{y}"
=end

#method2
  puts student.id
  puts student.name
  puts student.gender
  puts student.age
  i = i+1
}