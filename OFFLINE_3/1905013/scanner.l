%option noyywrap
%{
#include<iostream>
#include<stdlib.h>
#include<string.h>
#include "1905013_symbolInfo.h"
#include "y.tab.h"

using namespace std;

extern YYSTYPE yylval;

void yyerror(char *);
extern int  fstart,ffinish,startlincount=-1;
extern int line_count;
extern int error;
extern symbolTable *table;
extern bool defined;
extern ofstream logfile,errorfile,parsefile;
extern int pini,pfinal,forstart;
%}



digit [0-9]
letter [A-Za-z]
delim [ \t\r\f\v]
newline \n
ws [delim]+
id (_|{letter})(_|{letter}|{digit})*
integer {digit}+
number {digit}*(\.{digit}+)?(E[+-]?{digit}+)?
ADDOP [+-] 
MULOP [*/%]

%%

{delim}+	{}
{newline} {line_count++;}

"if" { 
	if(startlincount==-1)
	startlincount=line_count;
symbolInfo *s= new  symbolInfo(yytext, (char *)"IF");
	s->setline(line_count);
				yylval = (YYSTYPE)s;
	logfile<<"Line# "<<line_count<<": Token <IF> Lexeme if found"<<endl; 
	return IF;
	}
"else" {
	if(startlincount==-1)
	startlincount=line_count;
	symbolInfo *s= new  symbolInfo(yytext, (char *)"IF");
	s->setline(line_count);
				yylval = (YYSTYPE)s; 
	logfile<<"Line# "<<line_count<<": Token <ELSE> Lexeme else found"<<endl;
	return ELSE;
	}
"for" { 
	if(startlincount==-1)
	startlincount=line_count;
	
	symbolInfo *s= new  symbolInfo(yytext, (char *)"FOR");
	s->setline(line_count);
				yylval = (YYSTYPE)s;
	logfile<<"Line# "<<line_count<<": Token <FOR> Lexeme for found"<<endl;
	return FOR;
	}
"while" {
	if(startlincount==-1)
	startlincount=line_count;
	symbolInfo *s= new  symbolInfo(yytext, (char *)"WHILE");
	s->setline(line_count);
				yylval = (YYSTYPE)s;
	
	logfile<<"Line# "<<line_count<<": Token <WHILE> Lexeme while found"<<endl;
	return WHILE;
	}
"int" { 
	if(startlincount==-1)
	startlincount=line_count;
	cout<<startlincount<<endl;
	logfile<<"Line# "<<line_count<<": Token <INT> Lexeme int found"<<endl;
	return INT;
	}
"float" {
	if(startlincount==-1)
	startlincount=line_count;
	logfile<<"Line# "<<line_count<<": Token <FLOAT> Lexeme float found"<<endl;
	return FLOAT;
	}


"return" {
	if(startlincount==-1)
	startlincount=line_count;
	logfile<<"Line# "<<line_count<<": Token <RETURN> Lexeme return found"<<endl;
	return RETURN;
	}
"void" {
	if(startlincount==-1)
	startlincount=line_count;
	logfile<<"Line# "<<line_count<<": Token <VOID> Lexeme void found"<<endl;
	return VOID;
	}

"println"	{
	if(startlincount==-1)
	startlincount=line_count;
	logfile<<"Line# "<<line_count<<": Token <PRINTLN> Lexeme println found"<<endl;
	return PRINTLN;}

{ADDOP} { 
	if(startlincount==-1)
	startlincount=line_count;
		logfile<<"Line# "<<line_count<<": Token <ADDOP> Lexeme "<<yytext<<" found"<<endl;

			symbolInfo *s= new  symbolInfo(yytext, (char *)"ADDOP");
			yylval = (YYSTYPE)s;
			return ADDOP;
		}



{MULOP}	{
	if(startlincount==-1)
	startlincount=line_count;
			logfile<<"Line# "<<line_count<<": Token <MULOP> Lexeme "<<yytext<<" found"<<endl;

			symbolInfo *s= new  symbolInfo(yytext, (char *)"MULOP");
			yylval = (YYSTYPE)s;
			return MULOP;
		}


"=" 	{
			logfile<<"Line# "<<line_count<<": Token <ASSIGNOP> Lexeme "<<yytext<<" found"<<endl;

	
	return ASSIGNOP;}

">" |
"<" |
">=" |
"<=" |
"==" |
"!=" {
			logfile<<"Line# "<<line_count<<": Token <RELOP> Lexeme "<<yytext<<" found"<<endl;

		symbolInfo *s= new  symbolInfo(yytext, (char *)"RELOP");
		yylval = (YYSTYPE)s;
		return RELOP;
	}

"&&"	|
"||"	{
			logfile<<"Line# "<<line_count<<": Token <LOGICOP> Lexeme "<<yytext<<" found"<<endl;

			symbolInfo *s= new  symbolInfo(yytext, (char *)"LOGICOP");
			yylval = (YYSTYPE)s;
			return LOGICOP;
		}
"!"		{	
			logfile<<"Line# "<<line_count<<": Token <LOGICOP> Lexeme "<<yytext<<" found"<<endl;

	return NOT; }


";" 	{ 
			logfile<<"Line# "<<line_count<<": Token <SEMICOLON> Lexeme "<<yytext<<" found"<<endl;

	return SEMICOLON;
	}

"," {
			logfile<<"Line# "<<line_count<<": Token <COMMA> Lexeme "<<yytext<<" found"<<endl;

	return COMMA;
	}

"(" {
	symbolInfo *s= new  symbolInfo(yytext, (char *)"LPAREN");
	s->setline(line_count);
				yylval = (YYSTYPE)s;
			logfile<<"Line# "<<line_count<<": Token <LPAREN> Lexeme "<<yytext<<" found"<<endl;

	return LPAREN;
	}

")" {
	symbolInfo *s= new  symbolInfo(yytext, (char *)"RPAREN");
	s->setline(line_count);
				yylval = (YYSTYPE)s;
			logfile<<"Line# "<<line_count<<": Token <RPAREN> Lexeme "<<yytext<<" found"<<endl;

	return RPAREN;
	}

"{" {
	if(startlincount==-1)
	startlincount=line_count;
	if(defined==false){
	//table->enterScope(logfile);
	pini=line_count;
	pfinal=line_count;
	}
	
	fstart=line_count;
		symbolInfo *s= new  symbolInfo(yytext, (char *)"LCURL");
	s->setline(line_count);
				yylval = (YYSTYPE)s;
	logfile<<"Line# "<<line_count<<": Token <LCURL> Lexeme "<<yytext<<" found"<<endl;
	return LCURL;

	}

"}" {
		symbolInfo *s= new  symbolInfo(yytext, (char *)"RCURL");
	s->setline(line_count);
				yylval = (YYSTYPE)s;
	
	
	ffinish=line_count;
			logfile<<"Line# "<<line_count<<": Token <RCURL> Lexeme "<<yytext<<" found"<<endl;

	return RCURL;
	}

"[" {
			logfile<<"Line# "<<line_count<<": Token <LSQUARE> Lexeme "<<yytext<<" found"<<endl;

	return LTHIRD;
	}

"]" {
	logfile<<"Line# "<<line_count<<": Token <RSQUARE> Lexeme "<<yytext<<" found"<<endl;
	return RTHIRD;

	}

"++" {
	logfile<<"Line# "<<line_count<<": Token <INCOP> Lexeme "<<yytext<<" found"<<endl;
	return INCOP;
	}

"--" {
	logfile<<"Line# "<<line_count<<": Token <DECOP> Lexeme "<<yytext<<" found"<<endl;
	return DECOP;
	}



{integer}	{
	logfile<<"Line# "<<line_count<<": Token <CONST_INT> Lexeme "<<yytext<<" found"<<endl;
				symbolInfo *s= new  symbolInfo(yytext, (char *)"CONST_INT");
				yylval = (YYSTYPE)s;
				return CONST_INT;
			}
{number} 	{
	logfile<<"Line# "<<line_count<<": Token <CONST_FLOAT> Lexeme "<<yytext<<" found"<<endl;	
				symbolInfo *s= new  symbolInfo(yytext, (char *)"CONST_FLOAT");
				yylval = (YYSTYPE)s;
				return CONST_FLOAT; 
			}
	
{id} 		{	 
				logfile<<"Line# "<<line_count<<": Token <ID> Lexeme "<<yytext<<" found"<<endl;
				symbolInfo *s;					
					s= new symbolInfo(yytext, (char *)"ID");
				
				yylval = (YYSTYPE)s;
							
				return ID;
			}


%%








