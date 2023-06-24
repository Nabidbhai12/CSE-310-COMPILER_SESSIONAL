%option noyywrap

%x STRINGS
%x SINGLECMNT
%x AFTERSLASH
%x MULTICOMMENT
%x SASLASH
%{
#include<iostream>
#include<string>
#include<fstream>
#include<cstring>
#include<cstdlib>
#include"1905013_symbolInfo.h"

using namespace std;

int line_count=1;
int linst;
int errorc=0;
int noclose=0;
ofstream logfile;
ofstream tokenfile;
string buff;
string scmnt;
string mcmnt;
string buff2;
symbolTable st(10,logfile);
int flag1;
int flag2;
bool cmntflag=false;
string toconvert(string s)
{
    for(int i=0;i<s.length();i++)
    {
        s[i]=toupper(s[i]);

    }
    return s;

}
string lconvert(string s)
{
	s=yytext[1];
	if(s=="\\")
	{
		if(yytext[2]=='t')
		s='\t';
		else if(yytext[2]=='n')
		s='\n';
		else if(yytext[2]=='a')
		s='\a';
		else if(yytext[2]=='f')
		s='\f';
		else if(yytext[2]=='r')
		s='\r';
		else if(yytext[2]=='b')
		s='\b';
		else if(yytext[2]=='v')
		s='\v';
		else if(yytext[2]=='0')
		s='\0';
	}
	else{
		s=yytext[1];
	}
	return s;
}
string cnabid(string str)
{
	string rtr="";
	for(int i=0;i<str.length();i++)
	{
		if(str[i]!='\\')
		rtr+=str[i];

	}
	cout<<rtr<<endl;

}
string makestring(string src,string tar)
{
	
	
	switch(src[1])
	{
		case 'n':
		tar+='\n';
		break;
		case 't':
		tar+='\t';
		break;
		case 'a':
		tar+='\a';
		break;
		case 'r':
		tar+='\r';
		break;
		case 'f':
		tar+='\f';
		break;
		case 'b':
		tar+='\b';
		break;
		case 'v':
		tar+='\v';
		break;
		case '"':
		tar+='\"';
		break;
		case '\'':
		tar+='\'';
		break;
		default:
		break;

	}
	return tar;
}




%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n
IDENTIFIER [A-Z_a-z][A-Z_a-z0-9]*
ALPHANUM [A-Za-z0-9]
CHARLIT \'((\\n)|(\\t)|(\\a)|(\\f)|(\\r)|(\\b)|(\\v)|(\\\')|(\\\")|{ALPHANUM})\'
CHARLIT2 ((\\n)|(\\t)|(\\a)|(\\f)|(\\r)|(\\b)|(\\v)|(\\\')|(\\\")|{ALPHANUM}|{WHITESPACE})
DECIMAL_ERROR {DIGIT}+\.{DIGIT}+\.(\.|{DIGIT})*
INV_IDN {DIGIT}+{ALPHANUM}+
MUL_CHAR \'{CHARLIT2}{CHARLIT2}+\'
UNF_CHAR \'{CHARLIT2}*|\'\\
UNREC .
EMPCHAR \'\'
FLOAT ({DIGIT}+\.?{DIGIT}*|\.{DIGIT}+)([Ee][+-]?{DIGIT}+)?
ILL_NUM ({DIGIT}+\.?{DIGIT}*|\.{DIGIT}+)[Ee][+-]?{DIGIT}*\.({DIGIT}+)*




%%

{NEWLINE} {line_count++;}

"if"	{
			
            tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
		}
		
"else"	{
             tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}
"for"	{
              tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}
"while"	{
            tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}
"do"	{
             tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}
"break"	{
            tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}
"int"	{
             tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}   
"char"	{
           tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		} 
"float"	{
            tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}   
"double"	{
            tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}
"void"	{
            tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}
"return" {
              tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
			
		} 
"switch"	{
			 tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
            
			
		}  
"case"	{
            tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}
"default"	{
           tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}
"continue"	{
            tokenfile<<"<"<<toconvert(yytext)<<", "<<yytext<<"> "<<endl;
            logfile<<"Line# "<< line_count <<": Token " <<"<"<<toconvert(yytext)<< ">"<<" Lexeme "<<yytext<<" found"<<endl;
			
		}
{DIGIT}+ {
            tokenfile<<"<CONST_INT, "<<yytext<<"> "<<endl;
				logfile<<"Line# "<< line_count <<": Token " <<"<CONST_INT>"<<" Lexeme "<<yytext<<" found"<<endl;
        }
{FLOAT} {
            tokenfile<<"<CONST_FLOAT, "<<yytext<<"> "<<endl;
			logfile<<"Line# "<< line_count <<": Token " <<"<CONST_FLOAT>"<<" Lexeme "<<yytext<<" found"<<endl;
			

        }
{CHARLIT} {
			
			tokenfile<<"<CONST_CHAR, "<<lconvert(yytext)<<"> "<<endl;
			logfile<<"Line# "<< line_count <<": Token " <<"<CONST_CHAR>"<<" Lexeme "<<lconvert(yytext)<<" found"<<endl;

		}		

			
"+"|"-"	{
			tokenfile << "<ADDOP, " << yytext << "> "<<endl;
			logfile << "Line# " << line_count << ": Token <ADDOP> Lexeme " << yytext << " found" << endl;
			
		}
"*"|"/"|"%"	{
			tokenfile << "<MULOP, " << yytext << "> "<<endl;
			logfile << "Line# " << line_count << ": Token <MULOP> Lexeme " << yytext << " found" << endl;
			
		}
"++"|"--"	{
			tokenfile << "<INCOP, " << yytext << "> "<<endl;
			logfile << "Line# " << line_count << ": Token <INCOP> Lexeme " << yytext << " found" << endl;
			
		}
"<"|"<="|">"|">="|"=="|"!="	{
			tokenfile << "<RELOP, " << yytext << "> "<<endl;
			logfile << "Line# " << line_count << ": Token <RELOP> Lexeme " << yytext << " found" << endl;
			
		}
"="	{
			tokenfile << "<ASSIGNOP, " << yytext << "> "<<endl;
			logfile << "Line# " << line_count << ": Token <ASSIGNOP> Lexeme " << yytext << " found" << endl;
			
		}
"&&"|"||"	{
			tokenfile << "<LOGICOP, " << yytext << "> "<<endl;
			logfile << "Line# " << line_count << ": Token <LOGICOP> Lexeme " << yytext << " found" << endl;
			
		}
"&"|"|"|"^"|"<<"|">>"	{
			tokenfile << "<BITOP, " << yytext << "> "<<endl;
			logfile << "Line# " << line_count << ": Token <BITOP> Lexeme " << yytext << " found" << endl;
			
		}
"!"	{
		tokenfile << "<NOT, " << yytext << "> "<<endl;
		logfile << "Line# " << line_count << ": Token <NOT> Lexeme " << yytext << " found" << endl;
		
	}
"("	{
		tokenfile << "<LPAREN, " << yytext << "> "<<endl;
		logfile << "Line# " << line_count << ": Token <LPAREN> Lexeme " << yytext << " found" << endl;
		
	}
")"	{
		tokenfile << "<RPAREN, " << yytext << "> "<<endl;
		logfile << "Line# " << line_count << ": Token <RPAREN> Lexeme " << yytext << " found" << endl;
		
	}
"{"	{
		tokenfile << "<LCURL, " << yytext << "> "<<endl;
		logfile << "Line# " << line_count << ": Token <LCURL> Lexeme " << yytext << " found" << endl;
		st.enterScope(logfile);
		
	}
"}"	{
		tokenfile << "<RCURL, " << yytext << "> "<<endl;
		logfile << "Line# " << line_count << ": Token <RCURL> Lexeme " << yytext << " found" << endl;
		st.exitScope();
	}
"["	{
		tokenfile << "<LSQUARE, " << yytext << "> "<<endl;
		logfile << "Line# " << line_count << ": Token <LSQUARE> Lexeme " << yytext << " found" << endl;
		
	}
"]"	{
		tokenfile << "<RSQUARE, " << yytext << "> "<<endl;
		logfile << "Line# " << line_count << ": Token <RSQUARE> Lexeme " << yytext << " found" << endl;
		
	}
","	{
		tokenfile << "<COMMA, " << yytext << "> "<<endl;
		logfile << "Line# " << line_count << ": Token <COMMA> Lexeme " << yytext << " found" << endl;
		
	}
";"	{
	   	tokenfile << "<SEMICOLON, " << yytext << "> "<<endl;
		logfile << "Line# " << line_count << ": Token <SEMICOLON> Lexeme " << yytext << " found" << endl;
	
	}
{IDENTIFIER} {
          tokenfile << "<ID, " << yytext << "> "<<endl;
		  logfile << "Line# " << line_count << ": Token <ID> Lexeme " << yytext << " found" << endl;
		  symbolInfo *ns=new symbolInfo(yytext,"ID");
		  if(st.insert(*ns,logfile))
		  st.printAll(logfile);
		 
    }

\" {
	BEGIN(STRINGS);
	noclose=0;
	linst=line_count;
	buff="";
	buff2="";
	flag1=0;
	//logfile<<"string state"<<endl;
	//logfile<<line_count<<endl;
	}
<STRINGS>\\\" {
	buff+="\\\"";
	
}
<STRINGS>(\\t|\\a|\\b|\\r|\\v|\\f|\'|\\n) {
//	tokenfile<<"sp"<<endl;

//	logfile<<"sp"<<endl;
	buff=makestring(yytext,buff);
	//buff2=makestring(yytext,buff);
	
	

}


<STRINGS>[\r]?\n {

	//logfile<<"hiii"<<endl;
	if(noclose==1){
	//buff=makestring(yytext,buff);
	buff+='\n';
	//buff2+="p";
	noclose=0;
	}
	else
	{
		logfile<<"Error at line# "<<line_count<<": UNFINISHED_STRING \""<<buff<<endl;
		errorc++;
		line_count++;
		//logfile<<"line = "<<line_count<<endl;
		BEGIN(INITIAL);
	}
	
	//line_count++;

}

<STRINGS>\" {
//	logfile<<" quote founded founded"<<endl;

	if(flag1==0){
	tokenfile << "<SINGLE LINE STRING, " << buff << "> "<<endl;
		  logfile << "Line# " << linst << ": Token <SINGLE LINE STRING> Lexeme \"" << buff << "\" found" << endl;
	}
	else
	{
		//cnabid(buff);
			tokenfile << "<MULTI LINE STRING, " << buff2 << "> "<<endl;
		  logfile << "Line# " << linst << ": Token <MULTI LINE STRING> Lexeme \"" << buff << "\" found" << endl;

	}
		  buff="";
		  buff2="";
		  flag1=0;
		  BEGIN(INITIAL);
		 



}
<STRINGS>\\ {
	//logfile<<"slash "<<line_count<<endl;
	buff=buff+'\\';
flag1=1;
noclose=1;
line_count++;

	
		
}
<STRINGS>. {
//	logfile<<".. = "<<yytext<<" ";
buff+=yytext;
buff2+=yytext;


}

\/\/ {
BEGIN(SINGLECMNT);
scmnt="//";
linst=line_count;
//logfile<<"cmnt started"<<endl;

}
<SINGLECMNT>\\ {
scmnt+="\\";
//scmnt+="\n";

BEGIN(AFTERSLASH);	
}
<AFTERSLASH>\n {
	scmnt+="\n";
	line_count++;
	BEGIN(SINGLECMNT);

}

<SINGLECMNT>[\r]?\n  {
//logfile<<"hello"<<endl;
	//tokenfile << "<SINGLE LINE COMMENT, " << scmnt << "> "<<endl;
		  logfile << "Line# " << linst << ": Token <SINGLE LINE COMMENT> Lexeme " << scmnt << " found" << endl;
		  scmnt="";
		  line_count++;
BEGIN(INITIAL);



}
<SINGLECMNT>. {
scmnt+=yytext;
//logfile<<yytext<<endl;
}
\/\* {
	BEGIN(MULTICOMMENT);
	mcmnt="/*";
	cmntflag=true;
	linst=line_count;

}
<MULTICOMMENT>\n {
	mcmnt+="\n";
	line_count++;

}

<MULTICOMMENT>\*\/ {
	cmntflag=false;
	mcmnt+="*/";
	//tokenfile << "<MULTI LINE COMMENT, " << mcmnt << "> "<<endl;
		  logfile << "Line# " << linst << ": Token <MULTI LINE COMMENT> Lexeme " << mcmnt << " found" << endl;
		  BEGIN(INITIAL);
		  mcmnt="";
}
	
<MULTICOMMENT>. {
	mcmnt+=yytext;
	

}
<MULTICOMMENT><<EOF>> {

	if(cmntflag==true)
	{
			  logfile<<"Error at line# "<<line_count<<": UNFINISHED_COMMENT "<<mcmnt<<endl;
		errorc++;
			  st.printAll(logfile);
	logfile<<"Total lines: "<<line_count<<endl;
	logfile<<"Total errors: "<<errorc<<endl;


	
		return 0;
	}

}
<INITIAL><<EOF>> {
		st.printAll(logfile);
	logfile<<"Total lines: "<<line_count<<endl;
	logfile<<"Total errors: "<<errorc<<endl;

	return 0;
}
{ILL_NUM} {
	  logfile<<"Error at line# "<<line_count<<": ILLFORMED_NUMBER "<<yytext<<endl;
	  errorc++;  
}
{DECIMAL_ERROR} {
	  logfile<<"Error at line# "<<line_count<<": TOO_MANY_DECIMAL_POINTS "<<yytext<<endl;
	  errorc++;  
}

{INV_IDN} {
	 logfile<<"Error at line# "<<line_count<<": INVALID_ID_SUFFIX_NUM_PREFIX "<<yytext<<endl;
	  errorc++;  

}
{MUL_CHAR} {

	 logfile<<"Error at line# "<<line_count<<": MULTICHAR_CONST_CHAR "<<yytext<<endl;
	  errorc++;  
}
{UNF_CHAR} {
	 logfile<<"Error at line# "<<line_count<<": UNFINISHED_CONST_CHAR "<<yytext<<endl;
	  errorc++; 
}
{EMPCHAR} {
	logfile<<"Error at line# "<<line_count<<": EMPTY_CONST_CHAR "<<yytext<<endl;
	  errorc++; 
}

{WHITESPACE}	{/* ignore them */}
{UNREC} {
	 logfile<<"Error at line# "<<line_count<<": UNRECOGNIZED_CHAR "<<yytext<<endl;
	  errorc++; 
}





%%

int main(int argc, char** argv) {
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	logfile.open("1905013_log.txt",ios::out);
	tokenfile.open("1905013_token.txt",ios::out);
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	
	yyin= fin;
	yylex();
	//st.print();
	fclose(yyin);
	
	return 0;
}
