#-*-coidng:utf-8-*-

import urllib
import urllib2
import re
import sys

reload(sys)
sys.setdefaultencoding('UTF-8')
url="http://www.bxwx9.org/b/62/62724/11455540.html"
url2="http://www.bxwx9.org/binfo/62/62724.htm"
def getHtml(url):
	page=urllib.urlopen(url)
	html=page.read().decode('UTF-8')
	return html
def get_name_content(html):
	re1=re.compile('<title>.+?</title>')
	re2=re.compile('<div id="content"><div id="adright">.+?</div>')
	s1=re1.findall(html)
	s2=re2.findall(html)
	if len(s1)>0 and len(s2)>0:
		name=s1[0].replace('<title>',"")
		name=name.replace('TXT下载</title>',"")
		content=s2[0].replace('<div id="content"><div id="adright">',"")
		content=content.replace('</div>',"")
		content=content.replace('<br /><br />  ','\n\t')
		content=content.replace(' ',"")
	else:
		name=''
		content=''
	return name,content
def write_novel(i,file1):
	file1.writelines('\n\r')
	s=383+i;
	html=getHtml(url2)
	name,content=get_name_content(html).decode('utf-8','ingore')
	file1.writelines(name)
	file1.writelines('\n\t')
	file1.writelines(content)
	file1.writelines('\n\n\n')

file1=open('dazhuzai.txt','w+')
[write_novel(i,file1)for i in range(50)]
file1.close()


