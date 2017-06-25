#include <iostream>
#include <iomanip>
using namespace std;
 
double Fibonacci(int n){
	double result=0;
	if(n==0){
		double Fibonacci0=result+1;
		return Fibonacci0;
	}
	else if(n==1){
		double Fibonacci1=result+1;
		return Fibonacci1;
	}
	if(n>=2){
		result=Fibonacci(n-1)+Fibonacci(n-2);
//		cout<<":"<<Fibonacci(n-1)<<"->"<<Fibonacci(n-2);
		return result;
	} 

}
int main(){
	int n;//n是用来记录斐波那契函数的个数
	cin>>n; 
	for(int i=0;i<n;i++){
		double result=Fibonacci(i);
		cout<<setw(15)<<result;
		if(i!=0&&i%5==0) cout<<endl;
	} 
	return 0;
} 
