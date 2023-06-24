%{

#include<iostream>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<fstream>
#include<vector>
#include<string>
#include<sstream>
#include "1905013_symbolInfo.h"

using namespace std;
bool firstlabel=false;
int fakelabel=0;
bool returncalled=false;
vector<string> argnamelist;
int fakelabelmap[1000];
int yyparse(void);
int yylex(void);
extern FILE *yyin;
bool fortrue=false;
bool whiletrue=false;
string loopid="";
int parmanent_offset=0;
stack<int> forstack;
stack<int> whilestack;
stack<int> ifstack;
int line_count=1;
int par_offset=0;
int ttmp=2;
int detectvoid=0;
stack<int> forexit;
stack<int> whileexit;
int forexitcount=0;
int ifarr[100];
int carr=0;
int forarr[100];
int farr=0;
int detectif=0;
stack<int> stackif;
int detectFOR=0;
int detectwhile=0;
int startwhile=0;
int whilearr[100];
int warr=0;
int detectdecop=0;
string newlinestr="new_line proc\n    push ax\n    push dx\n    mov ah,2\n    mov dl,cr\n    int 21h\n    mov ah,2\n    mov dl,lf\n    int 21h\n    pop dx\n    pop ax\n    ret\nnew_line endp\n";
// string printstr="print_output proc  ;print what is in ax\n    push ax\n    push bx\n    push cx\n    push dx\n    push si\n    lea si,number\n    mov bx,10\n    add si,4\n    cmp ax,0\n    jnge negate\n    print:\n    xor dx,dx\n    div bx\n    mov [si],dl\n    add [si],'0'\n    dec si\n    cmp ax,0\n    jne print\n    inc si\n    lea dx,si\n    mov ah,9\n    int 21h\n    pop si\n    pop dx\n    pop cx\n    pop bx\n    pop ax\n    ret\n    negate:\n    push ax\n    mov ah,2\n    mov dl,'-'\n    int 21h\n    pop ax\n    neg ax\n    jmp print\nprint_output endp\n";
string printstr="PRINT_OUTPUT PROC\n	PUSH AX\n	PUSH BX\n	PUSH CX\n	PUSH DX\n\n	; dividend has to be in DX:AX\n	; divisor in source, CX\n	MOV CX, 10\n	XOR BL, BL ; BL will store the length of number\n	CMP AX, 0\n	JGE STACK_OP ; number is positive\n	MOV BH, 1; number is negative\n	NEG AX\n\nSTACK_OP:\n	XOR DX, DX\n	DIV CX\n	; quotient in AX, remainder in DX\n	PUSH DX\n	INC BL ; len++\n	CMP AX, 0\n	JG STACK_OP\n\n	MOV AH, 02\n	CMP BH, 1 ; if negative, print a '-' sign first\n	JNE PRINT_LOOP\n	MOV DL, '-'\n	INT 21H\n\nPRINT_LOOP:\n	POP DX\n	XOR DH, DH\n	ADD DL, '0'\n	INT 21H\n	DEC BL\n	CMP BL, 0\n	JG PRINT_LOOP\n\n	POP DX\n	POP CX\n	POP BX\n	POP AX\n	RET\nPRINT_OUTPUT ENDP\n";
bool checklabel=false;
int labelcount=1;
symbolTable *table;
FILE *fp,*fp2,*fp3;
int ifnum=0;
int finaloffset=0;
int finaloffset2=0;
string current_function_name;
string deflt=".MODEL SMALL\n\
.STACK 1000H\n\
.Data\n\
	CR EQU 0DH\n\
	LF EQU 0AH\n\
	number DB \"00000$\"\n";
ofstream logfile,tempasm,asmfile,optimizeasm;
string dataseg="";
class varinfo{
	string var_name;
	string var_type;
	int var_size;
	int var_scope;
	int offset;
	string scope_name;
	public:
	varinfo()
	{

	}
	varinfo(string name,int size)
	{
		this->var_name=name;
		this->var_size=size;
		if(size==-1)
		this->var_type="VARIABLE";
		else
		this->var_type="ARRAY";


	}
	void setscope_name(string name)
	{
		this->scope_name=name;
	}
	string getscope_name()
	{
		return this->scope_name;
	}
	void setname(string var_name)
	{
		this->var_name=var_name;

	}
	string getname(){return this->var_name;}

	void setType(string var_type){
		this->var_type=var_type;
	}
	string getType(){
		return this->var_type;
	}
	void setsize(int size)
	{
		this->var_size=size;

	}
	int getsize()
	{
		return this->var_size;
	}
	void setscope(int scope)
	{
		this->var_scope=scope;
	}
	int getscope()
	{
		return this->var_scope;
	}
	void setoffset(int t)
	{
		this->offset=t;
	}
	int getoffset(){return offset;}


};
vector<varinfo*> varlist;
vector<varinfo*> storevar;
vector<varinfo*> storepar;
void yyerror(char *s)
{
	logfile<<"error"<<endl;
	//write your code
//	logfile<<(string)s<<endl;
}
void printlabel(ofstream &fileptr)
{
	// if(firstlabel==true){
	fileptr<<"L"<<labelcount<<":\n";
	labelcount++;

	// }
	// else
	// {
	// 	firstlabel=true;
	// }
	

}
void makevarasmcode(vector<varinfo*> valist)
{
	if(current_function_name.compare("main")==0){
	asmfile<<"\tPUSH BP"<<endl;
		asmfile<<"\tMOV BP, SP"<<endl;
	}
		
		for(int i=0;i<valist.size();i++)
		{
			if(valist[i]->getsize()==-1)
			asmfile<<"\tSUB SP, 2"<<" ;int "<<valist[i]->getname()<<endl;
			else
			{
				asmfile<<"\tSUB SP, "<<valist[i]->getsize()*2<<" ;int "<<valist[i]->getname()<<" []"<<endl;
			}
		}



}
string makedataseg(vector<varinfo*> valist,string& ans)
{

		for(int i=0;i<valist.size();i++)
		{
			ans=ans+"\t"+valist[i]->getname()+" DW 1 DUP (0000H)\n";
		}
return ans;

}
void createfinal()
{
	
	asmfile<<deflt;
	asmfile<<dataseg;
	asmfile<<".CODE"<<endl;
	
	// asmfile<<"main PROC"<<endl;
	// asmfile<<"\tMOV AX, @DATA"<<endl;
	// asmfile<<"\tMOV DS, AX"<<endl;
	ifstream ini("myoutput/1905013_temp_asm.asm");
	string line;
	while(getline(ini,line))
	asmfile<<line<<'\n';
}
void writefnc(string name)
{
	if(name.compare("main")==0)
	{
		tempasm<<name<<" PROC"<<endl;
		tempasm<<"\tMOV AX, @DATA"<<endl;
		tempasm<<"\tMOV DS, AX"<<endl;

	}
	else
	{
		tempasm<<name<<" PROC"<<endl;
		 tempasm<<"\tPUSH BP"<<endl;
		 tempasm<<"\tMOV BP, SP"<<endl;

	}
	
		ifstream ini("myoutput/1905013_final_asm.asm");
	string line;
	int y=0,yy=0,yyy=0;
	while(getline(ini,line)){
		if(line.compare("JMP L backpatch")==0)
		{
tempasm<<"\tJMP L"<<ifarr[y++]<<endl;

		}else if(line.compare("JMP FORBACKPATCH")==0)
		{
			tempasm<<"\tJMP L"<<forarr[yy++]<<endl;
		}
		else if(line.compare("JMP WHILEBACKPATCH")==0)
		{
			tempasm<<"\tJMP L"<<whilearr[yyy++]<<endl;
		}
		else if(line.compare("JMP END backpatch")==0)
		{
			tempasm<<"\tJMP L"<<ifstack.top()<<endl;
			ifstack.pop();
		}
		else{
		if(line.find("JMP L fakelabel#")!=std::string::npos)
		{
			bool fflag=false;
			string ans="";
			for(int i=0;i<line.size();i++)
			{
				if(line[i]=='#')
				{
					fflag=true;
					continue;
				}
				if(fflag==true)
				{
					ans+=line[i];
				}
			}
			
			int p=stoi(ans);
			tempasm<<"\tJMP L"<<fakelabelmap[p]<<endl;

		}
		else 
	tempasm<<line<<'\n';
		}
	}
	tempasm<<name<<" ENDP"<<endl;
	asmfile.close();
	asmfile.open("myoutput/1905013_final_asm.asm");
	farr=0;
	carr=0;
	warr=0;
}
void generatemovcode(string trgt,string src)
{
	if(src.compare("AX")==0)
	{
		asmfile<<"\tMOV "<<trgt<<", AX"<<endl;
		asmfile<<"\tPUSH AX"<<endl;
		asmfile<<"\tPOP AX"<<endl;
		return;
	}

	asmfile<<"\tMOV AX, "<<src<<endl;
	asmfile<<"\tMOV "<<trgt<<", AX"<<endl;
	asmfile<<"\tPUSH AX"<<endl;
	asmfile<<"\tPOP AX"<<endl;
}
void generateprintcode(string name){
	asmfile<<"\tMOV AX, "<<name<<endl;
	asmfile<<"\tCALL print_output"<<endl;
	asmfile<<"\tCALL new_line"<<endl;

}
void generatemulcode(string var1,string var2)
{
	asmfile<<"\tPOP AX"<<endl;
	asmfile<<"\tMOV CX, AX"<<endl;
	asmfile<<"\tPOP AX"<<endl;
	asmfile<<"\tCWD"<<endl;
	asmfile<<"\tMUL CX"<<endl;
	asmfile<<"\tPUSH AX"<<endl;

	
}
void generatemulcode2(string var1)
{
	asmfile<<"\tPOP AX"<<endl;
	asmfile<<"\tMOV CX, "<<var1<<endl;
	asmfile<<"\tCWD"<<endl;
	asmfile<<"\tMUL CX"<<endl;
	asmfile<<"\tPUSH AX"<<endl;

	
}
void generatemulcode3(string var1,string var2)
{
	asmfile<<"\tMOV AX, "<<var2<<endl;
	asmfile<<"\tMOV CX, AX"<<endl;
	asmfile<<"\tMOV AX, "<<var1<<endl;
	asmfile<<"\tCWD"<<endl;
	asmfile<<"\tMUL CX"<<endl;
	asmfile<<"\tPUSH AX"<<endl;

}
void generateaddcode(string var1,string var2,string op)
{
	asmfile<<"\tPOP AX"<<endl;
	asmfile<<"\tMOV DX, AX"<<endl;
	asmfile<<"\tPOP AX"<<endl;
		if(op.compare("+")==0)
		asmfile<<"\tADD AX, DX"<<endl;
		else
		asmfile<<"\tSUB AX, DX"<<endl;
		asmfile<<"\tPUSH AX"<<endl;
	
}
void generateaddcode2(string var2,string op)
{
	asmfile<<"\tMOV AX, "<<var2<<endl;
	asmfile<<"\tMOV DX, AX"<<endl;
	asmfile<<"\tPOP AX"<<endl;
	if(op.compare("+")==0)
	asmfile<<"\tADD AX, DX"<<endl;
	else
	asmfile<<"\tSUB AX, DX"<<endl;
	asmfile<<"\tPUSH AX"<<endl;



}
void generateaddcode3(string var1,string var2,string op)
{
	asmfile<<"\tMOV AX, "<<var2<<endl;
	asmfile<<"\tMOV DX, AX"<<endl;
	asmfile<<"\tMOV AX, "<<var1<<endl;
	if(op.compare("+")==0)
	asmfile<<"\tADD AX, DX"<<endl;
	else
	asmfile<<"\tSUB AX, DX"<<endl;
	asmfile<<"\tPUSH AX"<<endl;
		
}
void generatemodcode(string var1,string var2)
{
	asmfile<<"\tPOP AX"<<endl;
	asmfile<<"\tMOV CX, AX"<<endl;
	asmfile<<"\tPOP AX"<<endl;
	asmfile<<"\tCWD"<<endl;
	asmfile<<"\tDIV CX"<<endl;
	asmfile<<"\t PUSH DX"<<endl;
	


}
void generatemodcode2(string var1)
{
	asmfile<<"\tMOV AX, "<<var1<<endl;
	asmfile<<"\tMOV CX, AX"<<endl;
	asmfile<<"\tPOP AX"<<endl;
	asmfile<<"\tCWD"<<endl;
	asmfile<<"\tDIV CX"<<endl;
	asmfile<<"\tPUSH DX"<<endl;

}
void generatemodcode3(string var1,string var2)
{
	asmfile<<"\tMOV AX, "<<var2<<endl;
	asmfile<<"\tMOV CX, AX"<<endl;
	asmfile<<"\tMOV AX, "<<var1<<endl;
	asmfile<<"\tCWD"<<endl;
	asmfile<<"\tDIV CX"<<endl;
	asmfile<<"\t PUSH DX"<<endl;
	

}
void generaterelcode(string var1,string var2,string var3)
{
	string ans;
	if(var3.compare("<=")==0)
	ans="JLE";
	else if(var3.compare("!=")==0)
	ans="JNE";
	else if(var3.compare("==")==0)
	ans="JE";
	else if(var3.compare("<")==0)
	ans="JL";
	else if(var3.compare(">")==0)
	ans="JG";
	else if(var3.compare(">=")==0)
	ans="JGE";

	asmfile<<"\tPOP AX"<<endl;
	asmfile<<"\tMOV DX, AX"<<endl;
	asmfile<<"\tPOP AX"<<endl;
	asmfile<<"\tCMP AX, DX"<<endl;
if(loopid.compare("FOR")==0)
	{
		
		asmfile<<"\t"<<ans<<" L"<<to_string(labelcount+1)<<endl;

	}
	else if(loopid.compare("WHILE")==0)
	{
		asmfile<<"\t"<<ans<<" L"<<to_string(labelcount)<<endl;
	}
	
	else{
	asmfile<<"\t"<<ans<<" L"<<to_string(labelcount)<<endl;
	
	}
	if(detectwhile==0)
	labelcount++;

}
void generaterelcode2(string var1,string var3)
{
	string ans;
	if(var3.compare("<=")==0)
	ans="JLE";
	else if(var3.compare("!=")==0)
	ans="JNE";
	else if(var3.compare("==")==0)
	ans="JE";
	else if(var3.compare("<")==0)
	ans="JL";
	else if(var3.compare(">")==0)
	ans="JG";
	else if(var3.compare(">=")==0)
	ans="JGE";
	asmfile<<"\tMOV AX, "<<var1<<endl;
	asmfile<<"\tMOV DX, AX"<<endl;
	asmfile<<"\tPOP AX"<<endl;
		asmfile<<"\tCMP AX, DX"<<endl;

	if(loopid.compare("FOR")==0)
	{
		
		asmfile<<"\t"<<ans<<" L"<<to_string(labelcount+1)<<endl;

	}
	else if(loopid.compare("WHILE")==0)
	{
		asmfile<<"\t"<<ans<<" L"<<to_string(labelcount)<<endl;
	}
	
	else{
	asmfile<<"\t"<<ans<<" L"<<to_string(labelcount)<<endl;
	
	}
	if(detectwhile==0)
	labelcount++;
	

}
void generaterelcode3(string var1,string var2,string var3)
{
		string ans;
	if(var3.compare("<=")==0)
	ans="JLE";
	else if(var3.compare("!=")==0)
	ans="JNE";
	else if(var3.compare("==")==0)
	ans="JE";
	else if(var3.compare("<")==0)
	ans="JL";
	else if(var3.compare(">")==0)
	ans="JG";
	else if(var3.compare(">=")==0)
	ans="JGE";


	
	asmfile<<"\tMOV AX, "<<var2<<endl;
	asmfile<<"\tMOV DX, AX"<<endl;
	asmfile<<"\tMOV AX, "<<var1<<endl;
	asmfile<<"\tCMP AX, DX"<<endl;
if(loopid.compare("FOR")==0)
	{
		
		asmfile<<"\t"<<ans<<" L"<<to_string(labelcount+1)<<endl;

	}
	else if(loopid.compare("WHILE")==0)
	{
		asmfile<<"\t"<<ans<<" L"<<to_string(labelcount)<<endl;
	}
	
	else{
	asmfile<<"\t"<<ans<<" L"<<to_string(labelcount)<<endl;
	
	}
	if(detectwhile==0)
	labelcount++;
	


}
void generaterelmovecode(string var1,string var2)
{
	asmfile<<"\tJMP L"<<to_string(labelcount+1)<<endl;
	asmfile<<"L"<<to_string(labelcount-1)<<":"<<endl;
	asmfile<<"\tMOV AX, 1"<<endl;
	asmfile<<"\tJMP L"<<to_string(labelcount)<<endl;
	asmfile<<"L"<<to_string(labelcount+1)<<":"<<endl;
	asmfile<<"\tMOV AX, 0"<<endl;
	printlabel(asmfile);
	labelcount++;

}

void generatelogicode(string var1,string var2,string var3)
{
	string ans;
	if(var3.compare("&&")==0)
	ans="AND";
	if(var3.compare("||")==0)
	ans="OR";
	if(ans.compare("OR")==0)
	{
		asmfile<<"\tMOV AX, "<<var1<<endl;
		asmfile<<"\tCMP AX, 0"<<endl;
		asmfile<<"\tJNE L"<<to_string(labelcount+1)<<endl;
		asmfile<<"\tJMP L"<<to_string(labelcount)<<endl;

		asmfile<<"L"<<to_string(labelcount)<<":"<<endl;
		asmfile<<"\tMOV AX, "<<var2<<endl;
		asmfile<<"\tCMP AX, 0"<<endl;
		asmfile<<"\tJNE L"<<to_string(labelcount+1)<<endl;
		asmfile<<"\tJMP L"<<to_string(labelcount+3)<<endl;
		labelcount++;

		asmfile<<"L"<<to_string(labelcount)<<":"<<endl;
		asmfile<<"\tMOV AX, 1"<<endl;
		asmfile<<"\tJMP L"<<to_string(labelcount+1)<<endl;
		labelcount++;

		asmfile<<"L"<<to_string(labelcount+1)<<":"<<endl;
		asmfile<<"\tMOV AX, 0"<<endl;
		asmfile<<"L"<<to_string(labelcount)<<":"<<endl;
		labelcount++;
		labelcount++;
	}
	else
	{
		asmfile<<"\tMOV AX, "<<var1<<endl;
		asmfile<<"\tCMP AX, 0"<<endl;
		asmfile<<"\tJNE L"<<to_string(labelcount)<<endl;
		asmfile<<"\tJMP L"<<to_string(labelcount+3)<<endl;

		asmfile<<"L"<<to_string(labelcount)<<":"<<endl;
		labelcount++;
		asmfile<<"\tMOV AX, "<<var2<<endl;
		asmfile<<"\tCMP AX, 0"<<endl;
		asmfile<<"\tJNE L"<<to_string(labelcount)<<endl;
		asmfile<<"\tJMP L"<<to_string(labelcount+2)<<endl;

		asmfile<<"L"<<to_string(labelcount)<<":"<<endl;
		labelcount++;
		asmfile<<"\tMOV AX, 1"<<endl;
		asmfile<<"\tJMP L"<<to_string(labelcount)<<endl;
		asmfile<<"L"<<to_string(labelcount+1)<<":"<<endl;
		asmfile<<"\tMOV AX, 0"<<endl;
		asmfile<<"L"<<to_string(labelcount)<<":"<<endl;
		labelcount++;
		labelcount++;


	}
}
void generateincopcode(string var1)
{
	asmfile<<"\tMOV AX, "<<var1<<endl;
	asmfile<<"\tPUSH AX"<<endl;
	asmfile<<"\tINC AX"<<endl;
	asmfile<<"\tMOV "<<var1<<", AX"<<endl;
	asmfile<<"\tPOP AX"<<endl;

}
void generateaddopcode(string var1,string var2)
{
	asmfile<<"\tMOV AX, "<<var2<<endl;
	asmfile<<"\tNEG AX"<<endl;
	asmfile<<"\tPUSH AX"<<endl;
	asmfile<<"\tPOP AX"<<endl;
}
void generatereturncode()
{
	asmfile<<"L"<<to_string(labelcount)<<":"<<endl;
	labelcount++;
	asmfile<<"\tMOV AX, 0"<<endl;
	asmfile<<"\tJMP L"<<to_string(labelcount)<<endl;
	
	asmfile<<"L"<<to_string(labelcount)<<":"<<endl;
	labelcount++;
	asmfile<<"\tADD SP, "<<to_string(finaloffset-2)<<endl;
	asmfile<<"\tPOP BP"<<endl;
	asmfile<<"\tMOV AX,4CH"<<endl;
	asmfile<<"\tINT 21H"<<endl;
	returncalled=true;
	
}
void generatereturncode2(string name)
{
	int ans=0;
	for(int i=0;i<storevar.size();i++)
	{
		if(storevar[i]->getscope()==table->getcurrentScopeId())
		{
			ans+=2;
		}

	}
	asmfile<<"L"<<to_string(labelcount)<<":"<<endl;
	labelcount++;
	if(name.compare("AX")==0){
	// asmfile<<"\tPOP AX"<<endl;
	}
	else
asmfile<<"\tMOV AX, "<<name<<endl;
asmfile<<"\tJMP L"<<to_string(labelcount)<<endl;
asmfile<<"L"<<to_string(labelcount)<<":"<<endl;	
labelcount++;
if(ans!=0)
 asmfile<<"\tADD SP, "<<ans<<endl;
asmfile<<"\tPOP BP"<<endl;
if(storepar.size()!=0)
asmfile<<"\tRET "<<storepar.size()*2<<endl;
else
asmfile<<"\tRET"<<endl;
}
void generatedeccode(string varname)
{
	asmfile<<"\tMOV AX, "<<varname<<endl;
	asmfile<<"\tPUSH AX"<<endl;
	asmfile<<"\tDEC AX"<<endl;
	asmfile<<"\tMOV "<<varname<<", AX"<<endl;
	asmfile<<"\tPOP AX"<<endl;

}
void generatefunctioncallcode(string name)
{
	if(argnamelist.size()!=0)
	{
		for(int i=0;i<argnamelist.size();i++){
		asmfile<<"\tMOV AX, "<<argnamelist[i]<<endl;
		asmfile<<"\tPUSH AX"<<endl;
		}
		argnamelist.clear();
	}
	asmfile<<"\tCALL "<<name<<endl;
	asmfile<<"\tPUSH AX"<<endl;
	// asmfile<<"\tPOP AX"<<endl;

}
string prevline;
bool optimizepush(string line,string ins,ifstream &ini,int i)
{
	bool flag=false;
	string des1="",des2="";
	i++;
	while(line.size()!=i)
	{
		des1+=line[i];
		i++;
	}
prevline=line;
			getline(ini,line);
			cout<<prevline<<endl;
		 	cout<<line<<endl;	
			i=0;
			ins="";
		while(line[i]!=32)
		{
			ins+=line[i];
			i++;
		}
		if(ins.compare("\tPOP")==0)
		{
			i++;
	while(line.size()!=i)
	{
		des2+=line[i];
		i++;
	}
	if(des1.compare(des2)==0)
	{
		cout<<"optimized"<<endl;
		flag=true;
	}
	
	}
	if(flag==false)
	{
		cout<<prevline<<endl;
		cout<<line<<endl;
		optimizeasm<<prevline<<endl;
		optimizeasm<<line<<endl;
	}
	else
	{
		
		
	}
return flag;
}

bool optimizemov(string line,string ins,ifstream &ini,int i)
{
	bool flag=false;
	string src1="",src2="",des1="",des2="";
			i++;
			while(line[i]!=',')
			{
				src1+=line[i];
				i++;
			}
			
			i++;
			i++;
			while(i!=line.size())
			{
				des1+=line[i];
				i++;
			}
			

			prevline=line;
			
			getline(ini,line);
			
			i=0;
			ins="";
		while(line[i]!=32)
		{
			ins+=line[i];
			i++;
		}
		if(ins.compare("\tMOV")==0)
		{
			i++;
			while(line[i]!=',')
			{
				src2+=line[i];
				i++;
			}
		
			i++;
			i++;
			while(i!=line.size())
			{
				des2+=line[i];
				i++;
			}
			if(src1.compare(des2)==0 && des1.compare(src2)==0)
			{
				flag=true;
				cout<<"optimized"<<endl;
			}
			//MOV src1,des1
			//MOV src2,des2
			
		}
		else if(ins.compare("\tPUSH")==0)
		{
			optimizepush(line,ins,ini,i);
			return true;
		}
		if(flag==false){
		// cout<<prevline<<endl;
		// 	cout<<line<<endl;
			optimizeasm<<prevline<<endl;
			optimizeasm<<line<<endl;
		}
		else
		{
			optimizeasm<<prevline<<endl;

		}
		return flag;

}






bool optimizeadd(string line,string ins,ifstream &ini,int i)
{
	bool flag=false;
	string src1="",des1="";
			i++;
			while(line[i]!=',')
			{
				src1+=line[i];
				i++;
			}
			
			i++;
			i++;
			while(i!=line.size())
			{
				des1+=line[i];
				i++;
			}
			if(des1.compare("0")==0)
			{
				flag=true;
			}
	return flag;

}
void generateoptimizedcode()
{
	ifstream ini("myoutput/1905013_final_asm.asm");
	string line;
	int i=0;
	while(getline(ini,line)){
		string ins="";
		i=0;
		while(line[i]!=32)
		{
			ins+=line[i];
			i++;
		}
		
		if(ins.compare("\tMOV")==0)
		{
			bool flag=optimizemov(line,ins,ini,i);
			// if(flag==false){
			// optimizeasm<<prevline<<endl;
			// optimizeasm<<line<<endl;
			// }
		}
		else if(ins.compare("\tPUSH")==0)
		{
			bool flag=optimizepush(line,ins,ini,i);
			// if(flag==false){
			// optimizeasm<<prevline<<endl;
			// optimizeasm<<line<<endl;
			// }
		}
		else if(ins.compare("\tADD")==0)
		{
			bool flag=optimizeadd(line,ins,ini,i);
			if(flag==false)
			optimizeasm<<line<<endl;
		}
		else 
		{
			optimizeasm<<line<<endl;
		}

		
	}

}



%}
%token CONST_INT CONST_FLOAT ID
%token INT FLOAT VOID IF ELSE FOR WHILE PRINTLN RETURN
%token ASSIGNOP NOT INCOP DECOP LOGICOP RELOP ADDOP MULOP
%token LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON 


%code requires
{
	#include "1905013_symbolInfo.h"
	#define YYSTYPE symbolInfo*
}


//%left 
//%right

//%nonassoc 

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%nonassoc ageage
%nonassoc porepore
%%

start : program
	{
		//write your code in this block in all the similar blocks below
		logfile<< "start : program" <<endl;
		logfile<<"Total Lines: "<<line_count<<endl;
		createfinal();
		asmfile<<newlinestr;
		asmfile<<printstr;
		asmfile<<"END main"<<endl;
		generateoptimizedcode();
		
	
	}
	;

program : program unit {
	
	logfile<<"program : program unit" << endl;


}

	| unit {
		
		
		logfile<< "program : unit" <<endl;
	

	}
	;
	
unit : var_declaration {
	
	logfile << "unit : var_declaration" <<endl;
	


}

     | func_declaration {
	
		logfile<< "unit : func_declaration" <<endl;
		

	 }
     | func_definition
	 {
		
		logfile<< "unit : func_definition" <<endl;
	

	 }
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
	logfile<<"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON" << endl;


	
		



}
		| type_specifier ID LPAREN RPAREN SEMICOLON 
		{
			logfile<< "func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON" << endl;
			
			
			
		
		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN{ current_function_name=$2->getname();
int q=4;
for(int i=storepar.size()-1;i>=0;i--)
{
	storepar[i]->setoffset(q);
	q++;
	q++;

}



} compound_statement {
	par_offset=0;
	finaloffset=0;
	parmanent_offset+=finaloffset2;
	finaloffset2=0;
if($1->getname().compare("VOID")==0)
{


	printlabel(asmfile);
	asmfile<<"\tPOP BP"<<endl;
	asmfile<<"\tRET"<<endl;
}

	
		logfile<< "func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement" << endl;
	writefnc($2->getname());
	storepar.clear();
	//storevar.clear();
	firstlabel=false;
		

	


}
		| type_specifier ID LPAREN RPAREN compound_statement{
			par_offset=0;
	finaloffset=0;
	parmanent_offset+=finaloffset2;
	finaloffset2=0;
			if($1->getname().compare("VOID")==0)
{
	
	printlabel(asmfile);
	asmfile<<"\tPOP BP"<<endl;
	asmfile<<"\tRET"<<endl;
}
	logfile<<"func_definition : type_specifier ID LPAREN RPAREN compound_statement" <<endl;
	if(current_function_name.compare("main")==0)
	{
		if(returncalled==false)
		{
			cout<<"Return zero not used"<<endl;
			asmfile<<"\tMOV AX,4CH"<<endl;
	asmfile<<"\tINT 21H"<<endl;
	returncalled=true;

		}
	}
	writefnc($2->getname());
	storepar.clear();
	//storevar.clear();
	firstlabel=false;
	
		}
		
 		;
					


parameter_list  : parameter_list COMMA type_specifier ID {

	 
	 logfile<<"parameter_list  : parameter_list COMMA type_specifier ID" << endl;
	 
	varinfo *par=new varinfo($4->getname(),-1);
			par->setType($3->getname());
			par->setscope(table->getcurrentScopeId());
			par->setscope_name(current_function_name);
			par_offset+=2;
			par->setoffset(par_offset+2);
			finaloffset2+=2;
			
			
		

			storepar.push_back(par);


}
		| parameter_list COMMA type_specifier {
			
			logfile<<"parameter_list  : parameter_list COMMA type_specifier"<<endl;
				
		}
 		| type_specifier  ID {
			varinfo *par=new varinfo($2->getname(),-1);
			par->setType($1->getname());
			par->setscope(table->getcurrentScopeId());
			par->setscope_name(current_function_name);
			par_offset=par_offset+2;
			
			par->setoffset(par_offset+2);
		finaloffset2+=2;
	

			storepar.push_back(par);


		

			logfile<< "parameter_list  : type_specifier ID" <<endl;
			




		}
		| type_specifier {
			logfile<<"parameter_list : type_specifier" <<endl;
	

		}
		

 		;

 		
compound_statement : LCURL enterscope statements RCURL {
		


	logfile<<"compound_statement : LCURL statements RCURL" <<endl;
	vector<varinfo*> tmp;
	for(int i=0;i<storevar.size();i++)
	{
		if(storevar[i]->getscope()!=table->getcurrentScopeId())
		{
			tmp.push_back(storevar[i]);
		}
	}
	storevar.clear();
	for(int i=0;i<tmp.size();i++)
	{
		storevar.push_back(tmp[i]);
	}

	table->exitScope();

}
 		    | LCURL enterscope RCURL {
			
				logfile<<"compound_statement : LCURL RCURL" <<endl;
				

			}
 		    ;
			enterscope :
		{
			table->enterScope();
			
				
			for(int i=0;i<storepar.size();i++)
			{
				storepar[i]->setscope(table->getcurrentScopeId());
				storepar[i]->setscope_name(current_function_name);
				
				
			
			}
			
			
		

			}
//			parlist.clear();
			//table->printCurrent(logfile);

		
			
 		    
var_declaration : type_specifier declaration_list SEMICOLON {
	
//inserting the declared variable in a local list.
symbolInfo *tmp1;
if(finaloffset==0)
ttmp=2;
else
ttmp=finaloffset;
				 for(int i=0;i<varlist.size();i++)
				 {
					tmp1=new symbolInfo(varlist[i]->getname(),(string)$1->getname());
					tmp1->setvsize(varlist[i]->getsize());
					if(varlist[i]->getsize()!=-1)
					tmp1->settype2("ARRAY");
					bool testing=table->insert(*tmp1);
					varlist[i]->setscope(table->getcurrentScopeId());
					varlist[i]->setoffset(ttmp);
					varlist[i]->setscope_name(current_function_name);
					storevar.push_back(varlist[i]);
					if(varlist[i]->getsize()==-1){
					if(table->getcurrentScopeId()!=1)	
					ttmp+=2;
					}
					else
					{
						ttmp=ttmp+varlist[i]->getsize()*2;
					}

				 }
				 finaloffset=ttmp;
//creating assembly
if(table->getcurrentScopeId()==1)
{
	//variable is declared in the global scope.
	dataseg=makedataseg(varlist,dataseg);


}
else
{
	//variable is declared in local scope.
	printlabel(asmfile);
	makevarasmcode(varlist);
}
varlist.clear();

} 
 		 ;
 		 
type_specifier	: INT {
	   $$ = new symbolInfo("INT", "INT");	
       logfile<<  "type_specifier\t: INT"<< endl;
           
}
 		| FLOAT {
			 $$ = new symbolInfo("FLOAT", "FLOAT");

       logfile<<  "type_specifier\t: FLOAT"  << endl;
	  


		}
 		| VOID {
			 $$ = new symbolInfo("VOID", "VOID");
			 
       logfile<<  "type_specifier\t: VOID"   << endl;
		}
 		;
 		
declaration_list : declaration_list COMMA ID {
	
	  logfile<<"declaration_list : declaration_list COMMA ID" <<endl;
	   varinfo *va=new varinfo($3->getname(),-1);
	  
			 varlist.push_back(va);
			

}
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
		  {
			 logfile<<"declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE"<<endl;
			  varinfo *va=new varinfo($3->getname(),stoi($5->getname()));
			 varlist.push_back(va);	
		

		  }

 		  | ID    {
			$$ = new symbolInfo($1->getname(), $1->gettype());
			 logfile << "declaration_list : ID"<< endl;
			 varinfo *va=new varinfo($1->getname(),-1);
			 varlist.push_back(va);
			
			

		  }
		
 		  | ID LTHIRD CONST_INT RTHIRD { 
			//array 
			$$ = new symbolInfo($1->getname(), $1->gettype());
			 varinfo *va=new varinfo($1->getname(),stoi($3->getname()));
			 varlist.push_back(va);			
			logfile<< "declaration_list : ID LSQUARE CONST_INT RSQUARE" << endl;

		  }
 		  ;
 		  
statements : statement {


	checklabel=false;
	logfile<<"statements : statement" <<endl;



}
	   | statements statement {
		
		checklabel=false;
            logfile<< "statements : statements statement"  << endl;


	   }
	   ;
	   
statement : var_declaration {
	
            logfile<<"statement : var_declaration"<< endl;


}

	  | expression_statement {

            logfile<<"statement : expression_statement"<< endl;
			
			


	  }
	  | compound_statement {
            logfile<<"statement : compound_statement"<< endl;
			
			

	  }
	  | FOR{detectFOR+=1;fortrue=true;
	  loopid="FOR";
	  } LPAREN expression_statement{
		asmfile<<"L"<<labelcount<<":"<<endl;
		labelcount++;
		asmfile<<";FOR LOOP"<<endl;

	  } expression_statement{
		asmfile<<"JMP FORBACKPATCH"<<endl;
		asmfile<<";JMP IF NOT TRUE"<<endl;
		// asmfile<<"\tPOP AX"<<endl;
		if(detectwhile>0)
		labelcount++;
		asmfile<<"L"<<labelcount-1<<":"<<endl;
	  } expression RPAREN{
		checklabel=false;
		asmfile<<"\tJMP L"<<labelcount-2<<endl;
		// forexit=labelcount-1;
		forexit.push(labelcount-1);
		asmfile<<";INCREMENT"<<endl;
		
		} statement {
		loopid="";

            logfile<< "statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement" <<endl;
			
			asmfile<<"\tJMP L"<<forexit.top()<<endl;
			forexit.pop();
			asmfile<<";FOR LOOP EXIT"<<endl;
			// asmfile<<labelcount<<":"<<endl;
			if(detectFOR>1)
			{
				//nested
				forstack.push(labelcount);
			}
			else{
			forarr[farr++]=labelcount;
			while(forstack.size()>0)
			{
				forarr[farr++]=forstack.top();
				forstack.pop();
			}
			}
			
			detectFOR--;
			if(detectFOR==0)
			fortrue=false;
			asmfile<<"L"<<labelcount<<":"<<endl;
			labelcount++;
			
			

	  }
	  | IF LPAREN setif expression RPAREN nabid statement %prec LOWER_THAN_ELSE {
		  logfile << "statement : IF LPAREN expression RPAREN statement %prec THEN" << endl;
		  loopid="";
		  $4 = new symbolInfo("IF", "IF");
			fakelabelmap[$6->getfalselist()]=labelcount;
			
		  
		  detectif--;
		  


		  }
	 
	  
	  | IF LPAREN setif expression RPAREN nabid statement ELSE {
			// asmfile<<"L"<<labelcount<<":"<<endl;
			// labelcount++;
			$4 = new symbolInfo("IF", "IF");
			fakelabelmap[$6->getfalselist()]=labelcount;
			
			// ifarr[carr++]=labelcount;
			// asmfile<<"JMP END backpatch"<<endl;
			asmfile<<"JMP L fakelabel#"<<fakelabel<<endl;
			$4->settruelist(fakelabel);
			fakelabel++;
			asmfile<<";IF EXECUTED NOW IF EXIT"<<endl;

	  } statement
	  {
		loopid="";
		
	
		// ifarr[carr++]=labelcount;
		// ifstack.push(labelcount);
		fakelabelmap[$4->gettruelist()]=labelcount;
				logfile<< "statement : IF LPAREN expression RPAREN statement ELSE statement" <<endl;
				

	

		
	  }
	  | WHILE{detectwhile+=1;

	whiletrue=true;
	loopid="WHILE";
	  asmfile<<"L"<<labelcount<<":"<<endl;
	  asmfile<<";WHILE LOOP"<<endl;
	  	whileexit.push(labelcount);
	  labelcount++;
	//   startwhile=labelcount;

	detectdecop=0;
	
		
		

	  } LPAREN expression {
		  if(detectdecop==1){
		detectdecop=0;
		 asmfile<<"\tCMP AX, 0"<<endl;
		 asmfile<<"\tJNE L"<<labelcount<<endl;
		
	  }
		asmfile<<"JMP WHILEBACKPATCH"<<endl;
		asmfile<<";JMP IF NOT TRUE"<<endl;
	//asmfile<<labelcount<<":"<<endl;
	 
		printlabel(asmfile);

	  }RPAREN statement {
	
		
loopid="";
		logfile <<"statement : WHILE LPAREN expression RPAREN statement"<< endl;
		asmfile<<"\tJMP L"<<whileexit.top()<<endl;
		whileexit.pop();
		asmfile<<";WHILE LOOP EXIT"<<endl;
		
		// whilearr[warr++]=labelcount;
		if(detectwhile>1)
			{
				//nested
				whilestack.push(labelcount);
			}
			else{
			 whilearr[warr++]=labelcount;
			while(whilestack.size()>0)
			{
				whilearr[warr++]=whilestack.top();
				whilestack.pop();
			}
			}
		detectwhile--;
		if(detectwhile==0)
		whiletrue=false;
		asmfile<<"L"<<labelcount<<":"<<endl;
			labelcount++;
	
            
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON {
		logfile <<"statement : PRINTLN LPAREN ID RPAREN SEMICOLON"<<endl;
		string name;
		for(int i=0;i<storevar.size();i++)
		{
			
			if(storevar[i]->getname().compare($3->getname())==0)
			{
				if(storevar[i]->getscope()==1)
				{
					name=$3->getname();
				}
				else
				{
					name="[BP-"+to_string(storevar[i]->getoffset())+"]";

				}
			}
		}
		if(checklabel==false)
		{
			printlabel(asmfile);
	checklabel=true;
		}
		generateprintcode(name);
		
	  }
	  | RETURN expression SEMICOLON {
		logfile <<"statement : RETURN expression SEMICOLON"<< endl;
		
		

		if(current_function_name.compare("main")==0){
			// 
		generatereturncode();

		}
		else
		{
			
		generatereturncode2($2->getname());
		
		
		}
		checklabel=false;
		
	

	  }

	  ;
	  nabid :
	  {
		// asmfile<<"JMP L backpatch"<<endl;
		
		asmfile<<"JMP L fakelabel#"<<fakelabel<<endl;
		$$=new symbolInfo("IF","IF");
		$$->setfalselist(fakelabel);
		fakelabel++;
		
		asmfile<<";if false then we go to"<<endl;
		asmfile<<"L"<<labelcount-1<<":"<<endl;
	  } 
	  setif:
	  {
		loopid="IF";
		detectif+=1;
	  }

	  
	  
expression_statement 	: SEMICOLON	{
	logfile<< "expression_statement : SEMICOLON"<< endl;


}		
			| expression SEMICOLON {
				logfile<< "expression_statement : expression SEMICOLON" <<endl;
			

			}
			;
	
variable : ID {
	if(checklabel==false){
	printlabel(asmfile);
	checklabel=true;
	}
	
	
	logfile<< "variable : ID"<< endl;
	varinfo *tmp=NULL;
	bool param=false;
	//checking whether it is a parameter or not
	for(int i=0;i<storepar.size();i++)
	{
		
		if(storepar[i]->getname().compare($1->getname())==0)
		{
			
			tmp=storepar[i];
			
			param=true;
			break;
			
		}

	}
	
	if(tmp==NULL){
		
	for(int i=0;i<storevar.size();i++)
	{
		if(storevar[i]->getname().compare($1->getname())==0)
		{
			if(tmp==NULL || tmp->getscope()==1){
			tmp=storevar[i];
			
			}
			
		}
	}
	// 
	}

	


	
	if(tmp->getscope()==1)
	{
		
		$$=new symbolInfo(tmp->getname(),tmp->getType());

	}
	else
	{
		
		
		if(current_function_name.compare(tmp->getscope_name())==0){
			if(param==true)
			$$=new symbolInfo("[BP+"+to_string(tmp->getoffset())+"]",tmp->getType());
			else{
				
		$$=new symbolInfo("[BP-"+to_string(tmp->getoffset())+"]",tmp->getType());
			}
		}
		

	}
	

	


}		
	 | ID LTHIRD expression RTHIRD {
		             logfile<<"variable : ID LSQUARE expression RSQUARE"<< endl;
					 	if(checklabel==false){
	printlabel(asmfile);
	checklabel=true;
	}
	varinfo *tmp=NULL;
	if(tmp==NULL){
	
	for(int i=0;i<storevar.size();i++)
	{
		if(storevar[i]->getname().compare($1->getname())==0)
		{
			if(tmp==NULL || tmp->getscope()==1){
			tmp=storevar[i];
			
			}
			
		}
	}
	
	}
	if(tmp->getscope()==1)
	{
		
		$$=new symbolInfo(tmp->getname(),tmp->getType());

	}
	else
	{
		
		
		if(current_function_name.compare(tmp->getscope_name())==0){
			
				
		$$=new symbolInfo("[BP-"+ to_string(tmp->getoffset()+2*stoi(($3->getname())) ) +"]",tmp->getType());
			
		}
		

	}
		

	 }
	 ;
	 
 expression : logic_expression	{

	logfile<<"expression \t: logic_expression"<< endl;
	$$=$1;
	
	
	
 }

 | variable ASSIGNOP logic_expression 	{
	if($3->getname().compare("AX")==0)
	{
		if($3->gettype().compare("rel")==0)
		{
			generaterelmovecode($1->getname(),"AX");

		}
		generatemovcode($1->getname(),"AX");
	}
	else
	generatemovcode($1->getname(),$3->getname());
	


		logfile<< "expression \t: variable ASSIGNOP logic_expression" <<endl;


	   }
	   ;
			
logic_expression : rel_expression 	{
	$$=$1;
	logfile<<"logic_expression : rel_expression" <<endl;

		if($1->gettype().compare("MULOP")==0)
	asmfile<<"\tPOP AX"<<endl;
	else if($1->gettype().compare("ADDOP")==0)
	asmfile<<"\tPOP AX"<<endl;
	else if($1->gettype().compare("FUNCTION_CALL")==0)
	asmfile<<"\tPOP AX"<<endl;
	
	
	

}

		 | rel_expression LOGICOP rel_expression 	{
		
		generatelogicode($1->getname(),$3->getname(),$2->getname());
			logfile<< "logic_expression : rel_expression LOGICOP rel_expression" <<endl;
			$$=new symbolInfo("AX","AX");

		 }

		 ;
			
rel_expression	: simple_expression {
	$$=$1;
	
	logfile<< "rel_expression\t: simple_expression" <<endl;

	


}

		| simple_expression RELOP simple_expression	{
			
			 if($1->getname().compare("AX")==0 && $3->getname().compare("AX")==0){
				
			 generaterelcode($1->getname(),$3->getname(),$2->getname());
			  
			 }
			 else if($1->getname().compare("AX")==0)
			 {
			
				generaterelcode2($3->getname(),$2->getname());

			 }
			 else if($3->getname().compare("AX")==0)
			 {
				
				generaterelcode2($1->getname(),$2->getname());

			 }
			 else{
				
			generaterelcode3($1->getname(),$3->getname(),$2->getname());
			 }

			logfile<<"rel_expression\t: simple_expression RELOP simple_expression" <<endl;
			$$=new symbolInfo("AX","rel");
		
			 

		}
		;
				
simple_expression : term {
	$$=$1;
	
	logfile<<"simple_expression : term" <<endl;




}
		  | simple_expression ADDOP term 
		  {
			
			

			logfile<< "simple_expression : simple_expression ADDOP term" << endl;
			if($3->getname().compare("AX")==0 && $1->getname().compare("AX")==0)
			{
				generateaddcode($1->getname(),$3->getname(),$2->getname());

			}
			else if($1->getname().compare("AX")==0)
			{
				generateaddcode2($3->getname(),$2->getname());

			}
			else if($3->getname().compare("AX")==0)
			{
				generateaddcode2($1->getname(),$2->getname());

			}
			else
			{
			generateaddcode3($1->getname(),$3->getname(),$2->getname());
			}
				
			
			$$=new symbolInfo("AX","ADDOP");
		
			
		
			

			
			

		  }
		  
		  ;
					
term :	unary_expression
{
$$=$1;
	
	logfile<< "term :\tunary_expression" <<endl;


}
     |  term MULOP unary_expression
	 {

			 
logfile<< "term :\tterm MULOP unary_expression" << endl;
if($2->getname()=="*")
{
	if($1->getname().compare("AX")==0 && $3->getname().compare("AX")==0)
	generatemulcode($1->getname(),$3->getname());
	else if($1->getname().compare("AX")==0)
	generatemulcode2($3->getname());
	else if($3->getname().compare("AX")==0)
	{
		generatemulcode2($1->getname());

	}
	else
	{
		generatemulcode3($1->getname(),$3->getname());
	}
	$$=new symbolInfo("AX","MULOP");

}
else
{
	

	// generatemodcode($1->getname(),$3->getname());
	// $$=new symbolInfo("AX","MULOP");
	if($1->getname().compare("AX")==0 && $3->getname().compare("AX")==0)
	generatemodcode($1->getname(),$3->getname());
	else if($1->getname().compare("AX")==0)
	generatemulcode2($3->getname());
	else if($3->getname().compare("AX")==0)
	{
		generatemodcode2($1->getname());

	}
	else
	{
		generatemodcode3($1->getname(),$3->getname());
	}
	$$=new symbolInfo("AX","MULOP");

}



	 }
     ;

unary_expression : ADDOP unary_expression  
{
	
	generateaddopcode($1->getname(),$2->getname());
	$$=new symbolInfo("AX","ADDOP_UNARY");

logfile<< "unary_expression : ADDOP unary_expression" <<endl;
	
		

}
		 | NOT unary_expression 
		 {
			$$=$1;
			logfile<< "unary_expression : NOT unary_expression" << endl;

		 }
		 | factor {
			$$=$1;
		
			
			logfile<<"unary_expression : factor" << endl;

		 }
		 ;
	
factor	: variable {

	logfile<< "factor\t: variable" <<endl;
	
		$$=$1;
	
	

}
	| ID LPAREN argument_list RPAREN
	{
	
		
		logfile<< "factor\t: ID LPAREN argument_list RPAREN" << endl;
		if(checklabel==false){
		printlabel(asmfile);
		checklabel=true;
		}
		generatefunctioncallcode($1->getname());
		
		$$=new symbolInfo("AX","FUNCTION_CALL");	
	

		

	}
	| LPAREN expression RPAREN{
		logfile<< "factor\t: LPAREN expression RPAREN" << endl;
		

	}
	| CONST_INT {
		$$=new symbolInfo($1->getname(),"CONST_INT");
		logfile<< "factor\t: CONST_INT" << endl;
	 

	}
	| CONST_FLOAT {
				$$=new symbolInfo($1->getname(),"FLOAT");

		logfile<< "factor\t: CONST_FLOAT" <<endl;
		
	}
	| variable INCOP {
		
		logfile<< "factor\t: variable INCOP" <<endl;
		generateincopcode($1->getname());

		

	}
	| variable DECOP {
		$$=$1;
		logfile<< "factor\t: variable DECOP" <<endl;
		generatedeccode($1->getname());
		detectdecop=1;
	

	}
	;
	
argument_list : arguments 
{
	logfile<<"argument_list : arguments"<<endl;

	

			}
			
			| {
				
				logfile<<"argument_list : "<<endl;
	

			  }
			  ;
	
arguments : arguments COMMA logic_expression 
{
	
	logfile<<"arguments : arguments COMMA logic_expression"<<endl;
		argnamelist.push_back($3->getname());
		
			;
		
	

}
	      | logic_expression 
		  {
			
			

			
			logfile<<"arguments : logic_expression"<<endl;
			argnamelist.push_back($1->getname());
		


		  }
	      ;
 

%%
int main(int argc,char *argv[])
{

	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	logfile.open("myoutput/1905013_logfile.txt",ios::out);

	asmfile.open("myoutput/1905013_final_asm.asm",ios::out);
	tempasm.open("myoutput/1905013_temp_asm.asm",ios::out);
	optimizeasm.open("myoutput/1905013_optimized_asm.asm",ios::out);

	

	if(logfile.is_open()==false)
	{
		cout<<"sorry!file can't be opened.."<<endl;

	}
	if(asmfile.is_open()==false)
	{
		cout<<"sorry!file can't be opened.."<<endl;
	}
	if(tempasm.is_open()==false)
	{
		cout<<"sorry!can't be opended.."<<endl;
	}
	if(optimizeasm.is_open()==false)
	{
		cout<<"sorry!can't be opended.."<<endl;
	}
	
	
table=new symbolTable(11);
	yyin=fp;
	yyparse();
	

	fclose(yyin);
	logfile.close();
	asmfile.close();
	tempasm.close();
	optimizeasm.close();
	
	return 0;
}