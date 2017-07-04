#-*-coidng:utf-8-*-
import urllib
import urllib2
import re

import sys

reload(sys)
sys.setdefaultencoding('UTF-8')

'''
values={"seez-lz":"1","pn":"1"}
data=urllib.urlencode(values)
url="http://tieba.baidu.com/p/3138733512"
requset=urllib2.Request(url,data)
response=urllib2.urlopen(requset)
print response.read()
'''
#处理页面标签
class Tool:
	#去除img标签，7位长空格
	removeImg=re.compile('<img.*?>| {7}|')
	#删除超链接标签
	removeAddr=re.compile('<a.*?>|</a>')
	#把换行的标签换为\n
	replaceLine=re.compile('<tr>|<div>|</div>|</p>')
	#把表格制表<td>替换为\t
	replaceTD=re.compile('<td>')
	#把段落开头换为\n架空两格
	replacePara=re.compile('<p.*?>')
	#吧换行符或双换行符换成\n
	replaceBR=re.compile('<br><br>|<br>')
	#将其余标签剔除
	removeExtraTag=re.compile('<.*?>')
	def replace(self,x):
		x=re.sub(self.removeImg,"",x)
		x=re.sub(self.removeAddr,"",x)
		x=re.sub(self.replaceLine,"\n",x)
		x=re.sub(self.replaceTD,"\t",x)
		x=re.sub(self.replacePara,"\n   ",x)
		x=re.sub(self.replaceBR,"\n",x)
		x=re.sub(self.removeExtraTag,"",x)
		#strip()将前面多余内容删除
		return x.strip()
#贴吧爬虫类
class BDTB:
	#初始化，传入基地址，是否只看楼主楼层
	def __init__(self,baseUrl,seeLZ,floorTag):
		#base链接地址
		self.baseURL = baseUrl
		#是否只看楼主
		self.seeLZ = '?see_lz='+str(seeLZ)
		#HTML标签剔除工具类对象
		self.tool = Tool()
		#全局file变量，文件写入操作对象
		self.file = None
		#楼层标号，初始化为1
		self.floor = 1
		#默认的标题，若没有标题，那么成功获取就会应到这个标题
		self.defaultTitle = u"百度贴吧"
		#是否写入楼分隔符标记
		self.floorTag = floorTag
		#获取标题
		self.title = None


	#传入页码，获取该帖子的代码
	def getPage(self,pageNum):
	 	try:
			url=self.baseURL+self.seeLZ+'&pn='+str(pageNum)
			request=urllib2.Request(url)
			response=urllib2.urlopen(request)
			#print response.read()
			#使用UTF-8编码，不会乱码
			return response.read().decode('UTF-8')
	 	except urllib2.URLError, e:
			if hasattr(e,"reason"):
				print u"连接百度贴吧失败，错误原因",e.reason
				return None

	#获取帖子标题
	def getTitle(self,page):
		#page=self.getPage(1)
		#将标题的正则表达式通过compile方法编译匹配
		pattern=re.compile('<h1 class="core_title_txt.*?>(.*?)</h1>',re.S)
		result = re.search(pattern,page)
		if result:
			#print result.group(1)
			return result.group(1).strip()
		else:
			return None

	#获取帖子一共有多少页
	def getPageNum(self,page):
	#page=self.getPage(1)
	#将标题的正则表达式通过compile方法编译匹配
		pattern=re.compile('<li class="l_reply_num.*?</span.*?>(.*?)</span>',re.S)
		result=re.search(pattern,page)
		if result:
			#print result.group(1)
			return result.group(1).strip()
		else:
			return None

	#获取正文内容
	def getContent(self,page):
	#将正文内容的正则表达式通过compile来进行编译匹配
		pattern=re.compile('<div id="post_content_.*?>(.*?)</div>',re.S)
		items=re.findall(pattern,page)
		contents=[]
		for item in items:
		#将文本进行标签剔除处理，同时在前面加上换行符
			content="\n"+self.tool.replace(item)+"\n"
			contents.append(content.encode('UTF-8'))
			return contents

	def setFileTitle(self,title):
		#如果标题不为空，那么就成功获取标题
		if title is not None:
			self.file=open(title+".txt","w+")
		else:
			self.file=open(self.defaultTitle+".txt","w+")

	def writeData(self,contents):
		#向文件写入每一层楼的信息
		for item in contents:
			if self.floorTag=="1":
				floorLine="\n"+str(self.floor)+u"___________________________\n"
				self.file.write(item)
				self.floor+=1

	def start(self):
		indexPage=self.getPage(1)
		pageNum=self.getPageNum(indexPage)
		#title=self.getTitle(page)
		#self.setFileTitle(title)
		if pageNum==None:
			print "URL已经失效，请重试"
			return
		try:
			print u"该帖子共有" + str(pageNum) + u"页"
			for i in range(1,7):
			#for i in range(1,int(pageNum)+1):
				print u"正在写入第" + str(i) + u"页数据"
				page = self.getPage(i)
				title = self.getTitle(page)
				self.setFileTitle(title)
				contents = self.getContent(page)
				self.writeData(contents)
		#出现书写异常
		except IOError,e:
			print "写入异常，原因"+e.message
		finally:
			print "写入任务完成"

print u"请输入帖子代号"
baseURL="http://tieba.baidu.com/p/3138733512"
#+str(raw_input(u'http://tieba.baidu.com/p/'))
seeLZ = raw_input (unicode('是否只获取楼主信息，是输入1，否输入0:\n','utf-8').encode('gbk'))
floorTag = raw_input(unicode('是否写入楼主信息，是输入1，否输入0:\n','utf-8').encode('gbk'))
bdtb = BDTB(baseURL,seeLZ,floorTag)
bdtb.start()


