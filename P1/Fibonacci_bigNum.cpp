#include <iostream>
#include<cstring>
using namespace std;

const int length=200;//����쳲����������������Ϊ������200 
void Fibonacci(int num1[],int num2[],int c[]){
	for(int i=length-1;i>=1;i--){
		c[i-1]=(num1[i]+num2[i]+c[i-1])/10;//��¼��λ 
		c[i]=(num1[i]+num2[i]+c[i])%10;//��¼��ȷ�ĸ�λ���ϵ����� 
	} 
}

int main()
{
 	int f[200][length];
	 memset(f,0, sizeof(f));
	f[1][length-1]=f[2][length-1]=1;
	cout<<f[1][length-1]<<endl<<f[2][length-1]<<endl;
	for(int i=3;i<=100;i++){
		Fibonacci(f[i-2],f[i-1],f[i]);
		for(int j=0;j<length;j++)
			{
				if(f[i][j]!=0)
				for(;j<length;j++)
					cout<<f[i][j];
			}
	cout<<endl;
	} 
return 0;
}
