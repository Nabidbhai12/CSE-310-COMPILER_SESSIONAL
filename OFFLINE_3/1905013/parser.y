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
bool checker1=false;
int startlincount;
 stack<int> enters,statem;
// queue<int> ifline;
int exits=0;

int fenter=0;
int doublechecker=0;
bool tika=false;
int pini=-1,pfinal=-1,pst;
int yyparse(void);
int yylex(void);
extern FILE *yyin;
int line_count=1;
int fstart=0,ffinish=0;
int error_count=0;
bool defined=false;
symbolTable
 *table;
FILE *fp,*fp2,*fp3;

ofstream logfile,errorfile,parsefile;
class varinfo{
	public:
	string name;
	int size;
	varinfo(string n,int t)
	{
		this->name=n;
		this->size=t;

	}
	string getname(){return name;}
	


};
 varinfo *tmp;
vector<varinfo*> varlist;
class paraminfo
{
	public:
	string name;
	string type;
	paraminfo(string name,string type)
	{
		this->name=name;
		this->type=type;

	}

};
paraminfo *tmp1;
vector<paraminfo*> parlist;
class funcinfo
{
	public:
	vector<paraminfo> parameter_list;
	string function_name;
	string return_type;
	string getname()
	{
		return function_name;
	}
	string gettype(){return return_type;}
	int getpsize()
	{
		return parameter_list.size();

	}
	funcinfo(string name,string type)
	{
		this->function_name=name;
		this->return_type=type;
		

	}
	bool checklist(vector<paraminfo*> tmp)
	{
		//cout<<"cholo"<<endl;
		
		if(tmp.size()!=parameter_list.size())
		return false;
		for(int i=0;i<tmp.size();i++){
			//new
			//errorfile<<"def list "<<tmp[i]->type<<endl;
			//errorfile<<"stred list "<<parameter_list[i].type<<endl;
			if(tmp[i]->type.compare(parameter_list[i].type)!=0)
			{
				
				
				return false;
			}

	}

		return true;
	}
	int* argcheck(vector<string> arglist)
	{
		int *arr=new int[10];
		for(int i=0;i<10;i++)
		arr[i]=-1;
		int p=0;

			
		for(int i=0;i<arglist.size();i++){
			if(arglist[i].compare(parameter_list[i].type)!=0)
			{
				//errorfile<<"() =  "<<arglist[i]<<" , () = "<<parameter_list[i].type<<", () = "<<to_string(line_count)<<endl;
				
				
				p++;
				arr[p]=i+1;
				
			}
		}
		arr[0]=p;
		return arr;	
		}

	void copylist(vector<paraminfo*> tmp)
	{
		//cout<<"cholo"<<endl;
		for(int i=0;i<tmp.size();i++){
			//cout<<tmp[i]->name<<endl;
		parameter_list.push_back(*tmp[i]);
		//cout<<"kk"<<endl;
		
		}

	}
	


};
funcinfo *tmp2;
vector<funcinfo*> funclist;
class Nodeinfo
{
	public:
	string str;

};
vector<string> arglist;
stack<Nodeinfo*> parsetreestack;
Nodeinfo *tmp4;
 string line_count1;
stringstream stream;
int unitfinal=-1;
string split(string str){
	char del='\n';
    // declaring temp string to store the curr "word" upto del
      string temp = "";

int cnt=0;
   for(int i=0; i<(int)str.size(); i++){
        // If cur char is not del, then append it to the cur "word", otherwise
          // you have completed the word, print it, and start a new word.
         if(str[i] == del){
			cnt++;
         
        }
    }

   int pmp=0;
      for(int i=0; i<(int)str.size(); i++){
        // If cur char is not del, then append it to the cur "word", otherwise
          // you have completed the word, print it, and start a new word.
         if(str[i] != del){
            temp += str[i];
        }
          else{
            //cout << temp << " ";
			  pmp++;
			if(pmp!=cnt)
              temp+="\n ";
			  else
			  temp+="\n";
			

        }
    }
        //temp+="\n";
      //cout << temp;
return temp;
}
void yyerror(char *s)
{
	logfile<<"error"<<endl;
	//write your code
//	logfile<<(string)s<<endl;
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
%%

start : program
	{
		//write your code in this block in all the similar blocks below
		logfile<< "start : program" <<endl;
		logfile<<"Total Lines: "<<line_count<<endl;
		logfile<<"Total Errors: "<<error_count<<endl;
		tmp4=parsetreestack.top();
		parsetreestack.pop();
		
		tmp4->str="start : program \t<Line: "<<to_string(1)<<"-"+to_string(line_count)+">\n"+tmp4->str;
		tmp4->str=split(tmp4->str);
		parsetreestack.push(tmp4);
		

		parsefile<<parsetreestack.top()->str<<endl;
	}
	;

program : program unit {
	
	logfile<<"program : program unit" << endl;
	Nodeinfo *unit=parsetreestack.top();
	parsetreestack.pop();
	Nodeinfo *program=parsetreestack.top();
	parsetreestack.pop();
	tmp4=new Nodeinfo();


	tmp4->str="program : program unit \t<Line: "<<to_string(1)<<"-"+to_string(unitfinal)+">\n"+program->str+unit->str;
			tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);


}

	| unit {
		
		//cout<<"laaa"<<endl;
		logfile<< "program : unit" <<endl;
		tmp4=parsetreestack.top();
		parsetreestack.pop();
		
		

	tmp4->str="program : unit \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	tmp4->str=split(tmp4->str);
	//cout<<"heyy"<<endl;
	parsetreestack.push(tmp4);

	}
	;
	
unit : var_declaration {
	unitfinal=line_count;
	logfile << "unit : var_declaration" <<endl;
	tmp4=parsetreestack.top();
	parsetreestack.pop();
	
	
	tmp4->str="unit : var_declaration \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);


}

     | func_declaration {
		unitfinal=line_count;
		logfile<< "unit : func_declaration" <<endl;
		tmp4=parsetreestack.top();
		parsetreestack.pop();
		
		tmp4->str="unit : func_declaration \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
		tmp4->str=split(tmp4->str);
		parsetreestack.push(tmp4);

	 }
     | func_definition
	 {
		unitfinal=line_count;
		logfile<< "unit : func_definition" <<endl;
		tmp4=parsetreestack.top();
		parsetreestack.pop();
		tmp4->str="unit : func_definition \t<Line: "+to_string(fenter)+"-"+to_string(line_count)+">\n"+tmp4->str;
		tmp4->str=split(tmp4->str);
		parsetreestack.push(tmp4);

	 }
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
	logfile<<"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON" << endl;
	//cout<<"i am there"<<endl;
	symbolInfo *ptr=table->lookup($2->getname(),logfile);
	// cout<<"no"<<endl;
	// for(int i=0;i<parlist.size();i++)
	// cout<<parlist[i]->name<<endl;
	if(ptr==NULL)
	{
		//function is not declared yet.
		table->insert( *(new symbolInfo($2->getname() , $1->getname() ,"FUNCTION")),logfile );
		//keeping the list of declared function in  funclist
		tmp2=new funcinfo($2->getname(),$1->getname());
		tmp2->copylist(parlist);
		funclist.push_back(tmp2);
		parlist.clear();
		//making the parse tree.
		//cout<<"starting.."<<endl;
		Nodeinfo *parl=parsetreestack.top();
		parsetreestack.pop();
		
		//cout<<"first done"<<endl;
		tmp4=parsetreestack.top();
		parsetreestack.pop();
		
	//	cout<<"2nd done.."<<endl;
		
		tmp4->str+="ID : "+$2->getname()+"\t<Line: "+ to_string(line_count) +">\n";
		tmp4->str+="LPAREN : (\t<Line: ";
		tmp4->str+=to_string(line_count)+">\n";
		tmp4->str+=parl->str;
		tmp4->str+="RPAREN : )\t<Line: "+to_string(line_count)+">\n";
		tmp4->str+="SEMICOLON : ;\t<Line: "+to_string(line_count)+">\n";
		tmp4->str="func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON \t<Line: "
		+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
		  tmp4->str=split(tmp4->str);
		parsetreestack.push(tmp4);	
		

	}
	else
	{
		//symboltable has one entry of the same name.THere can be multiple errors.
		errorfile<<"Line# "<<to_string(pini)<<": \'"<<$2->getname()<<"\' redeclared as different kind of symbol"<<endl;
			error_count++;


	}


}
		| type_specifier ID LPAREN RPAREN SEMICOLON 
		{
			logfile<< "func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON" << endl;
			symbolInfo *ptr=table->lookup($2->getname(),logfile);
			if(ptr==NULL){
			table->insert( *(new symbolInfo($2->getname() , $1->getname(),"FUNCTION" )),logfile );
		//keeping the list of declared function in  funclist
		tmp2=new funcinfo($2->getname(),$1->getname());
		tmp2->copylist(parlist);
		funclist.push_back(tmp2);
		parlist.clear();
		//cout<<"in fnction declaration"<<endl;
		//making the parse tree.
		tmp4=parsetreestack.top();
		parsetreestack.pop();
		// tmp4->str=split(tmp4->str);
		
		
		tmp4->str+="ID : "+$2->getname()+"\t<Line: "+ to_string(line_count) +">\n";
		tmp4->str+="LPAREN : (\t<Line: ";
		tmp4->str+=to_string(line_count)+">\n";
		tmp4->str+="RPAREN : )\t<Line: "+to_string(line_count)+">\n";
		tmp4->str+="SEMICOLON : ;\t<Line: "+to_string(line_count)+">\n";
		tmp4->str="func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON \t<Line: "+to_string(line_count)
		+"-"+to_string(line_count)+">\n"+tmp4->str;
		tmp4->str=split(tmp4->str);
		parsetreestack.push(tmp4);	
			}
			else
			{
				//error
				errorfile<<"Line# "<<to_string(pini)<<": \'"<<$2->getname()<<"\' redeclared as different kind of symbol"<<endl;
			error_count++;
			}	

		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN{
	checker1=table->lookup($2->getname(),logfile);
		table->insert( *(new symbolInfo($2->getname() , $1->getname(),"FUNCTION" )),logfile );
		// tmp2=new funcinfo($2->getname(),$1->getname());
		// tmp2->copylist(parlist);
		// funclist.push_back(tmp2);
		
		//logfile<<"name entry"<<endl;
		fenter=line_count;

}compound_statement {
//	enters.pop();
	// table->printCurrent(logfile);
	// table->exitScope();
	defined=false;

	symbolInfo *ptr=table->lookup($2->getname(),logfile);
	if(checker1==false)
	{
	//no entry in symboltable.That means the function is not yet declared or defined
	//table->insert( *(new symbolInfo($2->getname() , $1->getname(),"FUNCTION" )),logfile );
	//storing the function info at funclist vector
	 tmp2=new funcinfo($2->getname(),$1->getname());
	 	tmp2->copylist(parlist);
	 	funclist.push_back(tmp2);
		//
	//table->printAll(logfile);
		logfile<< "func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement" << endl;
	//entering the function name as id and return type as type specifier in symbol table
	 parlist.clear();
	//MAKING THE parse tree
	Nodeinfo *first=parsetreestack.top();
	parsetreestack.pop();
	//first->str=split(first->str);
	Nodeinfo *sec=parsetreestack.top();
	parsetreestack.pop();
	//sec->str=split(sec->str);
	Nodeinfo *third=parsetreestack.top();
	parsetreestack.pop();
	//third->str=split(third->str);
	sec->str+="RPAREN : )\t<Line: "+to_string(pfinal)+">\n";
	sec->str+=first->str;
	sec->str="ID : "+$2->getname()+"\t<Line: "+to_string(pini)+">\n"+
	 "LPAREN : (\t<Line: "+to_string(pini)+">\n"+
	 sec->str;

	 third->str=third->str+sec->str;
	 third->str="func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement \t<Line: "+to_string(fenter)
	 +"-"+to_string(ffinish)+">\n"+
	 third->str;
	 third->str=split(third->str);
	 parsetreestack.push(third);
	
	}
	else {
		//it means the function is either defined twice(error) or just declared(no error)
		bool t=false;
		bool pls=false;
		bool tsp=false;
		

		for(int i=0;i<funclist.size();i++)
		{
			funcinfo *ttmp=funclist[i];
			if( ttmp->getname().compare($2->getname())==0 && ttmp->gettype().compare($1->getname())==0 )
			{
				bool abid=ttmp->checklist(parlist);
				cout<<abid<<endl;
				
				if(abid==false)
				pls=true;
				else
				t=true;

				break;
			}
			else if( ttmp->getname().compare($2->getname())==0 && ttmp->gettype().compare($1->getname())!=0 )
			{
				tsp=true;
				break;
			}
			else {

			}
		}
		
		if(t==true)
		{
			//table->insert( *(new symbolInfo($2->getname() , $1->getname(),"FUNCTION" )),logfile );
	//table->printAll(logfile);
	 tmp2=new funcinfo($2->getname(),$1->getname());
	 	tmp2->copylist(parlist);
	 	funclist.push_back(tmp2);
		logfile<< "func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement" << endl;
	//entering the function name as id and return type as type specifier in symbol table
	
			// cout<<"declared alreadyy.."<<endl;
			 parlist.clear();
	//MAKING THE parse tree
	Nodeinfo *first=parsetreestack.top();
	parsetreestack.pop();
	//first->str=split(first->str);
	Nodeinfo *sec=parsetreestack.top();
	parsetreestack.pop();
	//sec->str=split(sec->str);
	Nodeinfo *third=parsetreestack.top();
	parsetreestack.pop();
	//third->str=split(third->str);
	sec->str+="RPAREN : )\t<Line: "+to_string(pfinal)+">\n";
	sec->str+=first->str;
	sec->str="ID : "+$2->getname()+"\t<Line: "+to_string(pini)+">\n"+
	 "LPAREN : (\t<Line: "+to_string(pini)+">\n"+
	 sec->str;

	 third->str=third->str+sec->str;
	 third->str="func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement \t<Line: "+
	 to_string(fenter)+"-"+to_string(ffinish)+">\n"+
	 third->str;
	 third->str=split(third->str);
	 parsetreestack.push(third);
		}
		else if(tsp==true)
		{
//
errorfile<<"Line# "<<to_string(pini)<<": Conflicting types for \'"<<$2->getname()<<"\'"<<endl;
error_count++;

		



//					table->insert( *(new symbolInfo($2->getname() , $1->getname(),"FUNCTION" )),logfile );

//	table->printAll(logfile);
	parlist.clear();
		logfile<< "func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement" << endl;
		Nodeinfo *first=parsetreestack.top();
	parsetreestack.pop();
//	first->str=split(first->str);
	Nodeinfo *sec=parsetreestack.top();
	parsetreestack.pop();
//	sec->str=split(sec->str);
	Nodeinfo *third=parsetreestack.top();
	parsetreestack.pop();
//	third->str=split(third->str);
	sec->str+="RPAREN : )\t<Line: "+to_string(pfinal)+">\n";
	sec->str+=first->str;
	sec->str="ID : "+$2->getname()+"\t<Line: "+to_string(pini)+">\n"+
	 "LPAREN : (\t<Line: "+to_string(pini)+">\n"+
	 sec->str;

	 third->str=third->str+sec->str;
	 third->str="func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement \t<Line: "+
	 to_string(fenter)+"-"+to_string(ffinish)+">\n"+
	 third->str;
	 third->str=split(third->str);
	 parsetreestack.push(third);
			//not
		}
		else if(pls==true)
		{
			errorfile<<"Line# "<<to_string(pini)<<": Conflicting types for \'"<<$2->getname()<<"\'"<<endl;
			error_count++;
		

		



					table->insert( *(new symbolInfo($2->getname() , $1->getname(),"FUNCTION" )),logfile );
	//table->printAll(logfile);
	parlist.clear();
		logfile<< "func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement" << endl;
		Nodeinfo *first=parsetreestack.top();
	parsetreestack.pop();
	//first->str=split(first->str);
	Nodeinfo *sec=parsetreestack.top();
	parsetreestack.pop();
	//sec->str=split(sec->str);
	Nodeinfo *third=parsetreestack.top();
	parsetreestack.pop();
	//third->str=split(third->str);
	sec->str+="RPAREN : )\t<Line: "+to_string(pfinal)+">\n";
	sec->str+=first->str;
	sec->str="ID : "+$2->getname()+"\t<Line: "+to_string(pini)+">\n"+
	 "LPAREN : (\t<Line: "+to_string(pini)+">\n"+
	 sec->str;

	 third->str=third->str+sec->str;
	 third->str="func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement \t<Line: "+
	 to_string(fenter)+"-"+to_string(ffinish)+">\n"+
	 third->str;
	 	 third->str=split(third->str);

	 parsetreestack.push(third);



		}
		else
		{
			errorfile<<"Line# "<<to_string(pini)<<": \'"<<$2->getname()<<"\' redeclared as different kind of symbol"<<endl;
			error_count++;
			

		
		
					//table->insert( *(new symbolInfo($2->getname() , $1->getname(),"FUNCTION" )),logfile );
	//table->printAll(logfile);
	parlist.clear();
		logfile<< "func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement" << endl;
		Nodeinfo *first=parsetreestack.top();
	parsetreestack.pop();
	
	Nodeinfo *sec=parsetreestack.top();
	parsetreestack.pop();
	Nodeinfo *third=parsetreestack.top();
	parsetreestack.pop();
	// first->str=split(first->str);
	// sec->str=split(sec->str);
	// third->str=split(third->str);
	sec->str+="RPAREN : )\t<Line: "+to_string(pfinal)+">\n";
	sec->str+=first->str;
	sec->str="ID : "+$2->getname()+"\t<Line: "+to_string(pini)+">\n"+
	 "LPAREN : (\t<Line: "+to_string(pini)+">\n"+
	 sec->str;

	 third->str=third->str+sec->str;
	 third->str="func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement \t<Line: "+
	 to_string(fenter)+"-"+to_string(ffinish)+">\n"+
	 third->str;
	 	 third->str=split(third->str);

	 parsetreestack.push(third);


		}

		

	}


}
		| type_specifier ID LPAREN RPAREN{
					table->insert( *(new symbolInfo($2->getname() , $1->getname(),"FUNCTION" )),logfile );
					tmp2=new funcinfo($2->getname(),$1->getname());
		tmp2->copylist(parlist);
		funclist.push_back(tmp2);
		fenter=line_count;
		

		}compound_statement {
		//	enters.pop();
	// 		table->printCurrent(logfile);
	// table->exitScope();
			
			symbolInfo *ptr=table->lookup($2->getname(),logfile);
	if(ptr==NULL)
	{
		
	//no entry in symboltable.That means the function is not yet declared or defined
	//table->insert( *(new symbolInfo($2->getname() , $1->getname(),"FUNCTION" )),logfile );
	//table->printAll(logfile);
	logfile<<"func_definition : type_specifier ID LPAREN RPAREN compound_statement" <<endl;
	//entering the function name as id and return type as type specifier in symbol table
	parlist.clear();
	//MAKING THE parse tree
	Nodeinfo *first=parsetreestack.top();
	parsetreestack.pop();
	Nodeinfo *sec=parsetreestack.top();
	parsetreestack.pop();
	// first->str=split(first->str);
	// sec->str=split(sec->str);
	sec->str+="ID : "+$2->getname()+"\t<Line: "+to_string(fenter)+">\n";
	sec->str+="LPAREN : (\t<Line: "+to_string(fenter)+">\n";
	sec->str+="RPAREN : )\t<Line: "+to_string(fenter)+">\n";
	sec->str+=first->str;

	 
	 sec->str="func_definition : type_specifier ID LPAREN RPAREN compound_statement \t<Line: "+
	 to_string(fenter)+"-"+to_string(ffinish)+">\n"+
	 sec->str;
	 	 sec->str=split(sec->str);

	 parsetreestack.push(sec);
	}
	else {
		//it means the function is either defined twice(error) or just declared(no error)
		bool t=false;
		
		for(int i=0;i<funclist.size();i++)
		{
			funcinfo *ttmp=funclist[i];
			if(ttmp->getname().compare($2->getname())==0 && ttmp->gettype().compare($1->getname())==0)
			{
				t=true;
				break;
			}
		}
		if(t==true)
		{
			//table->printAll(logfile);
	logfile<<"func_definition : type_specifier ID LPAREN RPAREN compound_statement" <<endl;
	parlist.clear();
			//no error
				//MAKING THE parse tree
	Nodeinfo *first=parsetreestack.top();
	parsetreestack.pop();
	Nodeinfo *sec=parsetreestack.top();
	parsetreestack.pop();
	// first->str=split(first->str);
	// sec->str=split(sec->str);
	
	sec->str+="ID : "+$2->getname()+"\t<Line: "+to_string(fenter)+">\n";
	sec->str+="LPAREN : (\t<Line: "+to_string(fenter)+">\n";
	sec->str+="RPAREN : )\t<Line: "+to_string(fenter)+">\n";
	sec->str+=first->str;

	 
	 sec->str="func_definition : type_specifier ID LPAREN RPAREN compound_statement \t<Line: "+
	 to_string(fenter)+"-"+to_string(ffinish)+">\n"+
	 sec->str;
	 	 	 sec->str=split(sec->str);

	 parsetreestack.push(sec);

		}
		else
		{
			
			//error
			logfile<<"func_definition : type_specifier ID LPAREN RPAREN compound_statement" <<endl;
	parlist.clear();
			//no error
				//MAKING THE parse tree
	Nodeinfo *first=parsetreestack.top();
	parsetreestack.pop();
	Nodeinfo *sec=parsetreestack.top();
	parsetreestack.pop();
	// first->str=split(first->str);
	// sec->str=split(sec->str);
	sec->str+="ID : "+$2->getname()+"\t<Line: "+to_string(fenter)+">\n";
	sec->str+="LPAREN : (\t<Line: "+to_string(fenter)+">\n";
	sec->str+="RPAREN : )\t<Line: "+to_string(fenter)+">\n";
	sec->str+=first->str;

	 
	 sec->str="func_definition : type_specifier ID LPAREN RPAREN compound_statement \t<Line: "+
	 to_string(fenter)+"-"+to_string(ffinish)+">\n "+
	 sec->str;
	 	 	 sec->str=split(sec->str);

	 parsetreestack.push(sec);
		}
		
		

	}

		}
		
 		;
					


parameter_list  : parameter_list COMMA type_specifier ID {
	pfinal=line_count;
	 
	 logfile<<"parameter_list  : parameter_list COMMA type_specifier ID" << endl;
	 symbolInfo *na=new symbolInfo((string)$4->getname(),(string)$3->getname());
			na->setvsize(-1);
			//table->insert(*na,logfile);
	   tmp1=new paraminfo($4->getname(),$3->getname());
			parlist.push_back(tmp1);
			tmp4=parsetreestack.top();
			parsetreestack.pop();
			//tmp4->str=split(tmp4->str);
			Nodeinfo *plist=new Nodeinfo();
			plist=parsetreestack.top();
			parsetreestack.pop();
			//plist->str=split(plist->str);
			plist->str+="COMMA : ,\t<Line: "+to_string(line_count)+">\n";
			plist->str+=tmp4->str;
			plist->str+="ID : "+(string)$4->getname()+"\t<Line: "+to_string(line_count)+">\n";
			plist->str="parameter_list : parameter_list COMMA type_specifier ID \t<Line: "+
			to_string(line_count)+"-"+to_string(line_count)+">\n"+plist->str;
	 	 plist->str=split(plist->str);

			parsetreestack.push(plist);



}
		| parameter_list COMMA type_specifier {
			
			logfile<<"parameter_list  : parameter_list COMMA type_specifier"<<endl;
				//tmp1=new paraminfo("",$2->getname());
					 symbolInfo *na=new symbolInfo("",(string)$3->getname());
			na->setvsize(-1);
			//table->insert(*na,logfile);
	   tmp1=new paraminfo("",$3->getname());
			parlist.push_back(tmp1);
			tmp4=parsetreestack.top();
			parsetreestack.pop();
			//tmp4->str=split(tmp4->str);
			Nodeinfo *plist=new Nodeinfo();
			plist=parsetreestack.top();
			parsetreestack.pop();
			//plist->str=split(plist->str);
			plist->str+="COMMA : ,\t<Line: "+to_string(line_count)+">\n";
			plist->str+=tmp4->str;
		//	plist->str+="ID : "+(string)$4->getname()+"\t<Line: "+to_string(line_count)+">\n";
			plist->str="parameter_list : parameter_list COMMA type_specifier ID \t<Line: "+
			to_string(line_count)+"-"+to_string(line_count)+">\n"+plist->str;
	 	 plist->str=split(plist->str);

			parsetreestack.push(plist);
		}
 		| type_specifier  ID {
			pini=line_count;
			pfinal=line_count;

			 tmp1=new paraminfo($2->getname(),$1->getname());
			parlist.push_back(tmp1);
			//table->enterScope(logfile);
			defined=true;
			symbolInfo *na=new symbolInfo((string)$2->getname(),(string)$1->getname());
			na->setvsize(-1);
//			table->insert(*na,logfile);

			logfile<< "parameter_list  : type_specifier ID" <<endl;
			//making the parse tree
			tmp4=parsetreestack.top();
			parsetreestack.pop();
		
			tmp4->str+="ID : "+(string)$2->getname()+"\t<Line: "+to_string(line_count)+">\n";
			tmp4->str="parameter_list : type_specifier ID \t<Line: "+to_string(line_count)+"-"+
			to_string(line_count)+">\n"+tmp4->str;
				 	 tmp4->str=split(tmp4->str);
					 //errorfile<<tmp4->str<<endl;

			parsetreestack.push(tmp4);




		}
		| type_specifier {
			logfile<<"parameter_list : type_specifier" <<endl;
			// tmp1=new paraminfo("",$1->getname());
			// parlist.push_back(tmp1);

pini=line_count;
			pfinal=line_count;

			 tmp1=new paraminfo("",$1->getname());
			parlist.push_back(tmp1);
			//table->enterScope(logfile);
			defined=true;
			symbolInfo *na=new symbolInfo("",(string)$1->getname());
			na->setvsize(-1);
//			table->insert(*na,logfile);

			logfile<< "parameter_list  : type_specifier" <<endl;
			//making the parse tree
			tmp4=parsetreestack.top();
			parsetreestack.pop();
			
			//tmp4->str+="ID : "+(string)$2->getname()+"\t<Line: "+to_string(line_count)+">\n";
			tmp4->str="parameter_list : type_specifier \t<Line: "+to_string(line_count)
			+"-"+to_string(line_count)+">\n"+tmp4->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);

		}
		

 		;

 		
compound_statement : LCURL enterscope statements RCURL {
		symbolInfo *nj = new symbolInfo("compound_statement", "compound_statement");
nj->setline($1->getline());
$$=nj;


	logfile<<"compound_statement : LCURL statements RCURL" <<endl;
	table->printAll(logfile);
	 table->exitScope();
	 exits=line_count;
	
	tmp4=parsetreestack.top();
			parsetreestack.pop();
	
			tmp4->str+="RCURL : }\t<Line: "+to_string($4->getline())
			+">\n";
			tmp4->str="compound_statement : LCURL statements RCURL \t<Line: "
			+to_string($1->getline())
			+"-"+to_string($4->getline())+">\nLCURL : {\t<Line: "+
			to_string($1->getline())+">\n"+tmp4->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);
	//		enters.pop();
			


}
 		    | LCURL enterscope RCURL {
			//	statem.pop();
				
				logfile<<"compound_statement : LCURL RCURL" <<endl;
					table->printAll(logfile);
	table->exitScope();
				tmp4=new Nodeinfo();
				tmp4->str+="RCURL : }\t<Line: "+to_string($3->getline())
			+">\n";
			tmp4->str="compound_statement : LCURL RCURL \t<Line: "
			+to_string($1->getline())
			+"-"+to_string($3->getline())+">\nLCURL : {\t<Line: "+
			to_string($1->getline())+">\n"+tmp4->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);
//enters.pop();


			}
 		    ;
			enterscope :
		{
		//	logfile<<"enterscope"<<endl;
			bool cr7;

			 table->enterScope(logfile);
			 enters.push(line_count);
			 for(int l=0;l<parlist.size();l++)
			{
				symbolInfo *na=new symbolInfo(parlist[l]->name,parlist[l]->type);
				//pushing all the parameters of a function here
				cr7=table->insert(*na,logfile);
				if(cr7==false){
				errorfile<<"Line# "<<to_string(line_count)<<": Redefinition of parameter \'"<<na->getname()<<"'"<<endl;
				error_count++;
				
				}


			}
//			parlist.clear();
			//table->printCurrent(logfile);

		
		}	
 		    
var_declaration : type_specifier declaration_list SEMICOLON {
	
//it handles if only one variable is declared as void.
if($1->getname().compare("VOID")==0){					
errorfile<<"Line# "<<to_string(line_count)<<": Variable or field \'"<<$2->getname()<<"' declared void "<<endl;
error_count++;


}

	            $$ = new symbolInfo((string)$1->getname()+(string)" "+(string)$2->getname()+(string)";"+(string)"\n", "NON_TERMINAL");
				 logfile<<"var_declaration : type_specifier declaration_list SEMICOLON" <<endl;
				 symbolInfo *tmp1;
				 for(int i=0;i<varlist.size();i++)
				 {
					tmp1=new symbolInfo(varlist[i]->name,(string)$1->getname());
					//tmp1->settype2((string)$1->getname());
					tmp1->setvsize(varlist[i]->size);
					if(varlist[i]->size!=-1)
					tmp1->settype2("ARRAY");
					bool testing=table->insert(*tmp1,logfile);
					if(testing==false)
					{
						//just checking whether symboltable already has a variable or function with same name or not.
					symbolInfo	*saad=table->lookup(tmp1->getname(),logfile);
					//checking that if a symbol(variable) has been already entered,their type matches or not
					if(saad->gettype().compare($1->gettype())!=0){
					errorfile<<"Line# "<<to_string(line_count)<<": Conflicting types for\'"<<tmp1->getname()<<"\'"<<endl;
					error_count++;
					}
					//new
					if(saad->gettype().compare($1->gettype())==0){
					errorfile<<"Line# "<<to_string(line_count)<<": Redeclaration of variable \'"<<tmp1->getname()<<"\'"<<endl;
					error_count++;
					}
					}
					
				 
				 }
				 varlist.clear();
				
				
				 Nodeinfo * dlist=parsetreestack.top();
				 parsetreestack.pop();
				
				 dlist->str=dlist->str+"SEMICOLON : ;\t<Line: "+to_string(line_count)+">\n";
				 
				 Nodeinfo *types=parsetreestack.top();

				 parsetreestack.pop();
				
				 tmp4=new Nodeinfo();
				 tmp4->str="var_declaration : type_specifier declaration_list SEMICOLON";
				 tmp4->str+=" \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n";
				 tmp4->str+=types->str;
				 tmp4->str+=dlist->str;
				 tmp4->str=split(tmp4->str);
				 //errorfile<<tmp4->str<<endl;
				 parsetreestack.push(tmp4);



} 
 		 ;
 		 
type_specifier	: INT {
	   $$ = new symbolInfo("INT", "INT");

	tmp4=new Nodeinfo();
	tmp4->str="type_specifier : INT \t<Line: ";
	
	tmp4->str+=to_string(line_count)+"-"+to_string(line_count)+">\n";
	tmp4->str+="INT : int\t<Line: "+to_string(line_count)+">\n";
;
	tmp4->str=split(tmp4->str);
	//errorfile<<tmp4->str<<endl;
	parsetreestack.push(tmp4);
	
       logfile<<  "type_specifier\t: INT"<< endl;
           
}
 		| FLOAT {
			 $$ = new symbolInfo("FLOAT", "FLOAT");

       logfile<<  "type_specifier\t: FLOAT"  << endl;
	   tmp4=new Nodeinfo();
	tmp4->str="type_specifier : FLOAT \t<Line: ";

	tmp4->str+=to_string(line_count)+"-"+to_string(line_count)+">\n";
	tmp4->str+="FLOAT : float\t<Line: "+to_string(line_count)+">\n";
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);


		}
 		| VOID {
			 $$ = new symbolInfo("VOID", "VOID");
			 tmp4=new Nodeinfo();
	tmp4->str="type_specifier : VOID \t<Line: ";

	tmp4->str+=to_string(line_count)+"-"+to_string(line_count)+">\n";
	tmp4->str+="VOID : void\t<Line: "+to_string(line_count)+">\n";
	//cout<<"done"<<endl;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);

       logfile<<  "type_specifier\t: VOID"   << endl;
		}
 		;
 		
declaration_list : declaration_list COMMA ID {
	
	  logfile<<"declaration_list : declaration_list COMMA ID" <<endl;
	  tmp=new varinfo((string)$3->getname(),-1);
			 varlist.push_back(tmp);
			 tmp4=parsetreestack.top();
		
			 parsetreestack.pop();
			 tmp4->str+="COMMA : ,\t<Line: "+to_string(line_count)+">\n";
			 tmp4->str+="ID : "+(string)$3->getname()+"\t<Line: "+to_string(line_count)+">\n";
			 			 

			tmp4->str="declaration_list : declaration_list COMMA ID \t<Line: "+to_string(line_count)+"-"+
			to_string(line_count)+">\n"+tmp4->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);

}
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
		  {
			 logfile<<"declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE"<<endl;

			int t=stoi($5->getname());
			//cout<<t<<endl;
			tmp=new varinfo((string)$3->getname(),t);
			varlist.push_back(tmp);		
			 tmp4=parsetreestack.top();
			 	
			 parsetreestack.pop();
			 
			 tmp4->str+="COMMA : ,\t<Line: "+to_string(line_count)+">\n";
			tmp4->str+="ID : "+(string)$3->getname()+"\t<Line: "+to_string(line_count)+">\n";
			 tmp4->str+="LSQUARE : [\t<Line: "+to_string(line_count)+">\n";
			 tmp4->str+="CONST_INT : "+$5->getname()+ "\t<Line: "+to_string(line_count)+">\n";
			 tmp4->str+="RSQUARE : ]\t<Line: "+to_string(line_count)+">\n";
			tmp4->str="declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE \t<Line: "+
			to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);
			

		  }

 		  | ID    {
			$$ = new symbolInfo($1->getname(), $1->gettype());
			 logfile << "declaration_list : ID"<< endl;
			 //here i am pushing the founded id's for future use.-1 means variable not array
			//creating a varinfo object and storing intp variable list
			tmp=new varinfo((string)$1->getname(),-1);
			 varlist.push_back(tmp);
//parse tree related
			 tmp4=new Nodeinfo();
			 tmp4->str="declaration_list : ID \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n";
			 //cout<<(string)$1->getname()<<endl;
			 tmp4->str+="ID : "+(string)$1->getname()+"\t<Line: "+to_string(line_count)+">\n";
			 tmp4->str=split(tmp4->str);
			 parsetreestack.push(tmp4);


		  }
		
 		  | ID LTHIRD CONST_INT RTHIRD { 
			//array 
			$$ = new symbolInfo($1->getname(), $1->gettype());

			logfile<< "declaration_list : ID LSQUARE CONST_INT RSQUARE" << endl;
			int t=stoi($3->getname());
			//cout<<t<<endl;
			tmp=new varinfo((string)$1->getname(),t);
			varlist.push_back(tmp);
			tmp4=new Nodeinfo();
			 
			 tmp4->str="declaration_list : ID LSQUARE CONST_INT RSQUARE \t<Line: "+to_string(line_count)+"-"+
			 to_string(line_count)+">\n";
			// cout<<(string)$1->getname()<<endl;
			 tmp4->str+="ID : "+(string)$1->getname()+"\t<Line: "+to_string(line_count)+">\n";
			 tmp4->str+="LSQUARE : [\t<Line: "+to_string(line_count)+">\n";
			 tmp4->str+="CONST_INT : "+$3->getname()+ "\t<Line: "+to_string(line_count)+">\n";
			 tmp4->str+="RSQUARE : ]\t<Line: "+to_string(line_count)+">\n";
			 tmp4->str=split(tmp4->str);
			 parsetreestack.push(tmp4);	 



		  }
 		  ;
 		  
statements : statement {

	symbolInfo *nj=new symbolInfo("statements","statements");
	nj->setline(line_count);
	$$=nj;
	doublechecker=0;
	statem.push(line_count);
	
	logfile<<"statements : statement" <<endl;
	tmp4=parsetreestack.top();
	parsetreestack.pop();
	
	tmp4->str="statements : statement \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);
	
		//errorfile<<to_string(line_count)<<" :"<<tmp4->str<<endl;


}
	   | statements statement {
		doublechecker=0;
		
		cout<<$1->getline()<<endl;
	$$=$1;
		
            logfile<< "statements : statements statement"  << endl;
			Nodeinfo *first=parsetreestack.top();
			parsetreestack.pop();
			
			Nodeinfo *sec=parsetreestack.top();
			parsetreestack.pop();
		
			sec->str+=first->str;
			sec->str="statements : statements statement \t<Line: "+to_string($1->getline())+"-"+
			to_string(line_count)+">\n"+sec->str;
				sec->str=split(sec->str);
			parsetreestack.push(sec);


	   }
	   ;
	   
statement : var_declaration {
	
            logfile<<"statement : var_declaration"<< endl;
			tmp4=parsetreestack.top();
	parsetreestack.pop();
	
	tmp4->str="statement : var_declaration \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);


}

	  | expression_statement {
		  $$ = new symbolInfo((string)$1->getname(), "NON_TERMINAL");
            logfile<<"statement : expression_statement"<< endl;
			tmp4=parsetreestack.top();
			//cout<<"ok"<<endl;
	parsetreestack.pop();
	

	

	//cout<<"laa"<<endl;
	tmp4->str="statement : expression_statement \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	//errorfile<<tmp4->str<<endl;
		tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);
	//cout<<"laa"<<endl;
			


	  }
	  | compound_statement {
		$$ = new symbolInfo((string)$1->getname()+(string)"\n", "NON_TERMINAL");
            logfile<<"statement : compound_statement"<< endl;
			tmp4=parsetreestack.top();
	parsetreestack.pop();
		

	tmp4->str="statement : compound_statement \t<Line: "+to_string($1->getline())+"-"+to_string(line_count)+">\n"+tmp4->str;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);
		//errorfile<<to_string(line_count)<<" :"<<tmp4->str<<endl;
//enters.pop();
			

	  }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement {
		

            logfile<< "statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement" <<endl;
Nodeinfo *first=parsetreestack.top();
	parsetreestack.pop();
	Nodeinfo *sec=parsetreestack.top();
	parsetreestack.pop();
	Nodeinfo *third=parsetreestack.top();
	parsetreestack.pop();
	Nodeinfo *fourth=parsetreestack.top();
	parsetreestack.pop();
	tmp4=new Nodeinfo();
	// 	first->str=split(first->str);
	// sec->str=split(sec->str);
	// third->str=split(third->str);
	// 	fourth->str=split(fourth->str);


tmp4->str="statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement \t<Line: "+to_string($1->getline())
+"-"+to_string(line_count)+">\n";
	 		 tmp4->str+="FOR : for\t<Line: "+to_string($1->getline())+">\n";
	 tmp4->str+="LPAREN : (\t<Line: "+to_string($2->getline())+">\n";
	 tmp4->str+=fourth->str;
	 tmp4->str+=third->str;
	 tmp4->str+=sec->str;
	tmp4->str+="RPAREN : )\t<Line: "+to_string($6->getline())+">\n";
	tmp4->str+=first->str;
	tmp4->str=split(tmp4->str);
	 parsetreestack.push(tmp4);

	  }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE {
		  logfile << "statement : IF LPAREN expression RPAREN statement %prec THEN" << endl;
		  cout<<$4->getline()<<endl;
		  
		  Nodeinfo *first=parsetreestack.top();
	parsetreestack.pop();
//exp_statement
	Nodeinfo *sec=parsetreestack.top();
	parsetreestack.pop();

	// first->str=split(first->str);
	// sec->str=split(sec->str);
	



	tmp4=new Nodeinfo();
tmp4->str="statement : IF LPAREN expression RPAREN statement \t<Line: "+to_string($1->getline())+"-"+to_string(line_count)+">\n";
		 tmp4->str+="IF : if\t<Line: "+to_string($1->getline())+">\n";
	 tmp4->str+="LPAREN : (\t<Line: "+to_string($2->getline())+">\n";
	 tmp4->str+=sec->str;
	tmp4->str+="RPAREN : )\t<Line: "+to_string($4->getline())+">\n";
	tmp4->str+=first->str;
	tmp4->str=split(tmp4->str);
	 parsetreestack.push(tmp4);
	 
		  }
	 
	  
	  | IF LPAREN expression RPAREN statement ELSE statement
	  {
				logfile<< "statement : IF LPAREN expression RPAREN statement ELSE statement" <<endl;
//if(doublechecker==0){
		Nodeinfo *first=parsetreestack.top();
		//errorfile<<"first:\n"<<first->str<<"\n"<<endl;
	parsetreestack.pop();
//exp_statement
	Nodeinfo *sec=parsetreestack.top();
//			errorfile<<"sec:\n"<<sec->str<<"\n"<<endl;

	parsetreestack.pop();
	//exp_statement
	Nodeinfo *third=parsetreestack.top();
	parsetreestack.pop();
//			errorfile<<"third:\n"<<third->str<<"\n"<<endl;
	// first->str=split(first->str);
	// sec->str=split(sec->str);
	// third->str=split(third->str);
		

			tmp4=new Nodeinfo();
tmp4->str="statement : IF LPAREN expression RPAREN statement ELSE statement \t<Line: "+to_string($1->getline())+"-"+
to_string(line_count)+">\n";
	 		 tmp4->str+="IF : if\t<Line: "+to_string($1->getline())+">\n";
	 tmp4->str+="LPAREN : (\t<Line: "+to_string($2->getline())+">\n";
	 tmp4->str+=third->str;
	 	tmp4->str+="RPAREN : )\t<Line: "+to_string($4->getline())+">\n";
	 tmp4->str+=sec->str;
	 		 tmp4->str+="ELSE : else\t<Line: "+to_string($6->getline())+">\n";
	 tmp4->str+=first->str;
	 tmp4->str=split(tmp4->str);
	 parsetreestack.push(tmp4);
	 doublechecker=1;
	//errorfile<<"final\n"<<tmp4->str<<endl;
	
//}
		
	  }
	  | WHILE LPAREN expression RPAREN statement {

		logfile <<"statement : WHILE LPAREN expression RPAREN statement"<< endl;
		Nodeinfo *first=parsetreestack.top();
	parsetreestack.pop();
//exp_statement
	Nodeinfo *sec=parsetreestack.top();
	parsetreestack.pop();
	// 	first->str=split(first->str);
	// sec->str=split(sec->str);
	
		tmp4=new Nodeinfo();
tmp4->str="statement : WHILE LPAREN expression RPAREN statement \t<Line: "+to_string($1->getline())+"-"+
to_string(line_count)+">\n";
	 		 tmp4->str+="WHILE : while\t<Line: "+to_string($1->getline())+">\n";
	 tmp4->str+="LPAREN : (\t<Line: "+to_string($2->getline())+">\n";
	 tmp4->str+=sec->str;
	 	tmp4->str+="RPAREN : )\t<Line: "+to_string($4->getline())+">\n";
	 tmp4->str+=first->str;
	 tmp4->str=split(tmp4->str);
	 parsetreestack.push(tmp4);
            
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON {
		logfile <<"statement : PRINTLN LPAREN ID RPAREN SEMICOLON"<<endl;
	  }
	  | RETURN expression SEMICOLON {
		logfile <<"statement : RETURN expression SEMICOLON"<< endl;
	tmp4=parsetreestack.top();
			parsetreestack.pop();
			// tmp4->str=split(tmp4->str);
			tmp4->str+="SEMICOLON : ;\t<Line: "+to_string(line_count)
			+">\n";
			tmp4->str="statement : RETURN expression SEMICOLON \t<Line: "
			+to_string(line_count)
			+"-"+to_string(line_count)+">\nRETURN : return\t<Line: "+
			to_string(line_count)+">\n"+tmp4->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);





	  }
	  ;
	  
expression_statement 	: SEMICOLON	{
	logfile<< "expression_statement : SEMICOLON"<< endl;
	tmp4=new Nodeinfo();
	tmp4->str="expression_statement : SEMICOLON \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	tmp4->str+="SEMICOLON : ;\t<Line: "+to_string(line_count)+">\n";
	tmp4->str=split(tmp4->str);
					parsetreestack.push(tmp4);





}		
			| expression SEMICOLON {
				logfile<< "expression_statement : expression SEMICOLON" <<endl;
				tmp4=parsetreestack.top();
				parsetreestack.pop();
							//tmp4->str=split(tmp4->str);

				tmp4->str+="SEMICOLON : ;\t<Line: "+to_string(line_count)+">\n";
				tmp4->str="expression_statement : expression SEMICOLON \t<Line: "+to_string(line_count)+
				"-"+to_string(line_count)+">\n"+tmp4->str;
				tmp4->str=split(tmp4->str);
				parsetreestack.push(tmp4);


			}
			;
	
variable : ID {
	//we have found a used variable in our program.NOw we have to check whether it has been declared or not
	//if declared ,then pass its information for further use.
	//check whether the symboltable has it already or not
	symbolInfo *paisi=table->lookup($1->getname(),logfile);
	if(paisi==NULL)
	{
		//a undeclared variable
		errorfile<<"Line# "<<to_string(line_count)<<": Undeclared variable \'"<<$1->getname()<<"\'"<<endl;
		error_count++;
		


	}
	else
	{
		//declared variable.SO just pass its information.
		$$=new symbolInfo(paisi->getname(),paisi->gettype());
		//errorfile<<to_string(line_count)<<" our var  "<<$1->getname()<<endl;
	//	errorfile<<"()= "<<paisi->getname()<<", ()-> "<<paisi->gettype()<<", () "<<to_string(line_count)<<endl;

	}
	logfile<< "variable : ID"<< endl;
	//making the parse tree
	tmp4=new Nodeinfo();
	tmp4->str="variable : ID \t<Line: "+to_string(line_count)+"-"+
	to_string(line_count)+">\n";
	tmp4->str+="ID : "+$1->getname()+"\t<Line: "+to_string(line_count)+">\n";
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4); 


}		
	 | ID LTHIRD expression RTHIRD {
		symbolInfo *paisi=table->lookup($1->getname(),logfile);
	if(paisi==NULL)
	{
		//a undeclared variable
		errorfile<<"Line# "<<to_string(line_count)<<": Undeclared variable \'"<<$1->getname()<<"\'"<<endl;
		error_count++;
	


	}
	else
	{
		//declared variable.SO just pass its information.
		symbolInfo *typ=new symbolInfo(paisi->getname(),paisi->gettype());
		if(paisi->getvsize()==-1)
		{
			//not an array then
			typ->setvsize(-1);
			typ->settype2("ARRAY");
					errorfile<<"Line# "<<to_string(line_count)<<": \'"<<$1->getname()<<"\' is not an array"<<endl;
					error_count++;



		}
		else
		{
			typ->setvsize(paisi->getvsize());
			typ->settype2("ARRAY");
		}
		$$=typ;

	}
	
		 
            logfile<<"variable : ID LSQUARE expression RSQUARE"<< endl;
		string ttt=(string)$3->gettype();
			if(ttt.compare("FLOAT")==0){
			errorfile<<"Line# "<<to_string(line_count)<<": Array subscript is not an integer"<<endl;
			error_count++;
			
			}
			tmp4=parsetreestack.top();
			parsetreestack.pop();
					

			Nodeinfo *pt=new Nodeinfo();
			pt->str="variable : ID LSQUARE expression RSQUARE \t<Line: "+to_string(line_count)+"-"+
	to_string(line_count)+">\n";
			pt->str+="ID : "+$1->getname()+"\t<Line: "+to_string(line_count)+">\n";
			pt->str+="LSQUARE : [\t<Line: "+to_string(line_count)+">\n";
			tmp4->str+="RSQUARE : ]\t<Line: "+to_string(line_count)+">\n";
			pt->str+=tmp4->str;
			pt->str=split(pt->str);
			parsetreestack.push(pt);

	 }
	 ;
	 
 expression : logic_expression	{
	$$=$1;
	logfile<<"expression \t: logic_expression"<< endl;
	tmp4=parsetreestack.top();
	parsetreestack.pop();
				

	tmp4->str="expression : logic_expression \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	//errorfile<<to_string(line_count)<<" :"<<tmp4->str<<endl;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);

 } 
	   | variable ASSIGNOP logic_expression 	{
		//now
		$$=new symbolInfo("expression",$1->gettype());
		symbolInfo *ptr=table->lookup($3->getname(),logfile);
		//if(ptr!=NULL)
		//errorfile<<ptr->gettype2()<<endl;
		
		//errorfile<<"logic expression"<<$3->gettype()<<endl;
	//	errorfile<<$3->gethaserror()<<endl;
		if($3->gethaserror()==false){
		if($3->gettype().compare("VOID")==0)
			 {
			 	funcinfo *fnt=NULL;
			 	for(int i=0;i<funclist.size();i++)
			 	{

					
			 			if(funclist[i]->getname().compare($3->getname())==0)
			 			{
							//errorfile<<"list name = "<<funclist[i]->getname()<<" expression name = "<<$3->getname()<<endl;
			 				fnt=funclist[i];
			 				break;
			 			}
			 	}
			 	if(fnt!=NULL && fnt->gettype().compare("VOID")==0){
					//errorfile<<"nabid ; "<<fnt->getname()<<" "<<fnt->gettype()<<endl;
				errorfile<<"Line# "<<to_string(line_count)<<": Void cannot be used in expression"<<endl; 
				error_count++;
							

				}


			 }
			 symbolInfo *fnt=table->lookup($1->getname(),logfile);
			 if(fnt!=NULL)
			 {
				//errorfile<<" line :"<<line_count<<"  "<<fnt->gettype()<<" "<<$3->gettype()<<endl;
				if(fnt->gettype().compare($3->gettype())!=0)
				{
					if(fnt->gettype().compare("INT")==0 && $3->gettype().compare("FLOAT")==0)
					{
						
						errorfile<<"Line# "<<to_string(line_count)<<": Warning: possible loss of data in assignment of FLOAT to INT"<<endl;
					//if(fnt->gettype().compare("FLOAT")==0)
					error_count++;
					//errorfile<<"Line# "<<to_string(line_count)<<": Warning: possible loss of data in assignment of INT to FLOAT"<<endl;
					}


					

				}


			 }
		}
		logfile<< "expression \t: variable ASSIGNOP logic_expression" <<endl;
		Nodeinfo *first=parsetreestack.top();
		parsetreestack.pop();
		Nodeinfo *sec=parsetreestack.top();
		parsetreestack.pop();
		// first->str=split(first->str);
		// sec->str=split(sec->str);


	
		first->str="ASSIGNOP : =\t<Line: "+to_string(line_count)+">\n"+first->str;
sec->str+=first->str;
sec->str="expression : variable ASSIGNOP logic_expression \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+
">\n"+sec->str;
sec->str=split(sec->str);
parsetreestack.push(sec);



	   }
	   ;
			
logic_expression : rel_expression 	{
	$$=$1;
	logfile<<"logic_expression : rel_expression" <<endl;
	tmp4=parsetreestack.top();
	parsetreestack.pop();
				//tmp4->str=split(tmp4->str);
	tmp4->str="logic_expression : rel_expression \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);
	

}

		 | rel_expression LOGICOP rel_expression 	{
			$$=$3;
			logfile<< "logic_expression : rel_expression LOGICOP rel_expression" <<endl;
			Nodeinfo *first=parsetreestack.top();
			parsetreestack.pop();
			Nodeinfo *sec=parsetreestack.top();
			parsetreestack.pop();
			// 			first->str=split(first->str);
			// sec->str=split(sec->str);

			sec->str+="LOGICOP : "+$2->getname()+"\t<Line: "+to_string(line_count)+">\n";

			first->str=sec->str+first->str;
			tmp4=new Nodeinfo();
			tmp4->str="logic_expression : rel_expression LOGICOP rel_expression \t<Line: "+
			to_string(line_count)+"-"+to_string(line_count)+">\n"+first->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);

		 }

		 ;
			
rel_expression	: simple_expression {
	$$=$1;
	logfile<< "rel_expression\t: simple_expression" <<endl;
	tmp4=parsetreestack.top();
	parsetreestack.pop();
				//tmp4->str=split(tmp4->str);

	tmp4->str="rel_expression : simple_expression \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
				tmp4->str=split(tmp4->str);

	parsetreestack.push(tmp4);


}

		| simple_expression RELOP simple_expression	{
			$$=$3;
			


			logfile<<"rel_expression\t: simple_expression RELOP simple_expression" <<endl;
			Nodeinfo *first=parsetreestack.top();
			parsetreestack.pop();
 			Nodeinfo *sec=parsetreestack.top();
			parsetreestack.pop();
			// 			first->str=split(first->str);
			// sec->str=split(sec->str);

			sec->str+="RELOP : "+$2->getname()+"\t<Line: "+to_string(line_count)+">\n";

			first->str=sec->str+first->str;
			tmp4=new Nodeinfo();
			tmp4->str="rel_expression : simple_expression RELOP simple_expression \t<Line: "+
			to_string(line_count)+"-"+to_string(line_count)+">\n"+first->str;
						tmp4->str=split(tmp4->str);

			parsetreestack.push(tmp4);
			 

		}
		;
				
simple_expression : term {
	$$=$1;
	logfile<<"simple_expression : term" <<endl;
	tmp4=parsetreestack.top();
	parsetreestack.pop();
				//tmp4->str=split(tmp4->str);

	tmp4->str="simple_expression : term \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
				tmp4->str=split(tmp4->str);

	parsetreestack.push(tmp4);



}
		  | simple_expression ADDOP term 
		  {
			symbolInfo *ptr=new symbolInfo("simplex_expression","not_void");
			if($1->gettype().compare("VOID")==0 || $3->gettype().compare("VOID")==0){
				if($3->gethaserror()==false && $1->gethaserror()==false){
             errorfile<<"Line# "<<to_string(line_count)<<": Void cannot be used in expression"<<endl; 
				error_count++;
				ptr->settype("VOID");
				ptr->sethaserror(true);
				}
			}
			$$=ptr;

			logfile<< "simple_expression : simple_expression ADDOP term" << endl;
			Nodeinfo *first=parsetreestack.top();
			parsetreestack.pop();
			Nodeinfo *sec=parsetreestack.top();
			parsetreestack.pop();
			// 			first->str=split(first->str);
			// sec->str=split(sec->str);

			sec->str+="ADDOP : "+$2->getname()+"\t<Line: "+to_string(line_count)+">\n";

			first->str=sec->str+first->str;
			tmp4=new Nodeinfo();
			tmp4->str="simple_expression : simple_expression ADDOP term \t<Line: "+to_string(line_count)+"-"+
			to_string(line_count)+">\n"+first->str;
						tmp4->str=split(tmp4->str);

			parsetreestack.push(tmp4);

		  }
		  
		  ;
					
term :	unary_expression
{
	$$=$1;
	
	logfile<< "term :\tunary_expression" <<endl;
	tmp4=parsetreestack.top();
	parsetreestack.pop();
				
	tmp4->str="term : unary_expression \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);

}
     |  term MULOP unary_expression
	 {
		symbolInfo *ptr=new symbolInfo("term",$3->gettype());
			if($1->gettype().compare("VOID")==0 || $3->gettype().compare("VOID")==0){
				if($3->gethaserror()==false && $1->gethaserror()==false){
             errorfile<<"Line# "<<to_string(line_count)<<": Void cannot be used in expression"<<endl; 
				error_count++;
				ptr->settype("VOID");
				ptr->sethaserror(true);
				}
			}
			
		

		if($2->getname().compare("%")==0)
		{
			//21 TARIQ
			
			if($3->gettype().compare("FLOAT")==0 || $1->gettype().compare("FLOAT")==0)
			{
			errorfile<<"Line# "<<to_string(line_count)<<": Operands of modulus must be integers"<<endl; 
			error_count++;
			$3->sethaserror(true);
			ptr->sethaserror(true);



			}
			if($3->getname().compare("0")==0){
						errorfile<<"Line# "<<to_string(line_count)<<": Warning: division by zero "<<endl; 
						error_count++;
							$3->sethaserror(true);
							ptr->sethaserror(true);
									
						
			}


		}

				if($2->getname().compare("/")==0)
				{
					if($3->getname().compare("0")==0)
						errorfile<<"Line# "<<to_string(line_count)<<": Warning: division by zero "<<endl; 
						error_count++;
							$3->sethaserror(true);
							ptr->sethaserror(true);
								

						


				}
				$$=ptr;
				
		
			//if we are using a function in a expression
			 
logfile<< "term :\tterm MULOP unary_expression" << endl;
Nodeinfo *first=parsetreestack.top();
			parsetreestack.pop();
			Nodeinfo *sec=parsetreestack.top();
			parsetreestack.pop();
			sec->str+="MULOP : "+$2->getname()+"\t<Line: "+to_string(line_count)+">\n";

			// sec->str=split(sec->str);
			 first->str=sec->str+first->str;
			tmp4=new Nodeinfo();
			tmp4->str="term : term MULOP unary_expression \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+
			first->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);
	 }
     ;

unary_expression : ADDOP unary_expression  
{
	$$=$2;
logfile<< "unary_expression : ADDOP unary_expression" <<endl;
	
			
			tmp4=parsetreestack.top();
			parsetreestack.pop();
			//tmp4->str=split(tmp4->str);
				string nab="ADDOP : "+$1->getname()+"\t<Line: "+to_string(line_count)+">\n";
			tmp4->str="unary_expression : ADDOP unary_expression \t<Line: "+to_string(line_count)+"-"
			+to_string(line_count)+">\n"+nab+tmp4->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);

}
		 | NOT unary_expression 
		 {
			$$=$1;
			

			tmp4=parsetreestack.top();
			parsetreestack.pop();
						

				string nab="LOGICOP : !\t<Line: "+to_string(line_count)+">\n";
			tmp4->str="unary_expression : LOGICOP unary_expression \t<Line: "+to_string(line_count)+
			"-"+to_string(line_count)+">\n"+nab+tmp4->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);
			logfile<< "unary_expression : NOT unary_expression" << endl;

		 }
		 | factor {
			$$=$1;
			
			logfile<<"unary_expression : factor" << endl;
			tmp4=parsetreestack.top();
			parsetreestack.pop();
						

			tmp4->str="unary_expression : factor \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);

		 }
		 ;
	
factor	: variable {
	$$=$1;
	logfile<< "factor\t: variable" <<endl;
	tmp4=parsetreestack.top();
	parsetreestack.pop();
				

	tmp4->str="factor : variable \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);
	

}
	| ID LPAREN argument_list RPAREN
	{
		
		//$$=new symbolInfo($1->getname(),"FUNCTION");
		   //errorfile<<"fnc name = "<<$1->getname()<<" : "<<$1->gettype()<<" "<<to_string(line_count)<<endl;
		//   for(int i=0;i<arglist.size();i++)
		//   errorfile<<arglist[i]<<" "<<endl;
		bool paisi=false;
		funcinfo *fnc,*fnt;
		for(int i=0;i<funclist.size();i++)
		{
			fnc=funclist[i];
			if(fnc->getname().compare($1->getname())==0)
			{
				fnt=fnc;
				paisi=true;
				break;
			}
			
		}
		if(paisi==true)
		{
			symbolInfo *ptr=new symbolInfo($1->getname(),fnt->gettype());
			ptr->setline(line_count);
		$$=ptr;
			//it can happen that a function is called with proper type of argument but not all argument has been given
			if(arglist.size()!=fnt->getpsize())
			{
				//yes error!!
				if(arglist.size()>fnt->getpsize())
				{
					//many
					errorfile<<"Line# "<<to_string(line_count)<<": Too many arguments to function \'"<<$1->getname()<<"\'"<<endl;
					error_count++;
								



				}
				else
				{
					//few
				errorfile<<"Line# "<<to_string(line_count)<<": Too few arguments to function \'"<<$1->getname()<<"\'"<<endl;
				error_count++;
							



				}
			}
			else
			{
					//the called function already has been declared or defined atleast.
			int *arr=fnt->argcheck(arglist);
			if(arr[0]>0)
			{
				//it means multiple arugment type doesn't match
			for(int h=1;h<=arr[0];h++){
			errorfile<<"Line# "<<to_string(line_count)<<": Type mismatch for argument "<<arr[h]<<" of \'"<<$1->getname()<<"\'"<<endl;
			error_count++;
		
			}

			}

			}
		}
		else
		{
			//we called a function but the function didn't exist.
			errorfile<<"Line# "<<to_string(line_count)<<": Undeclared function \'"<<$1->getname()<<"\'"<<endl;
			error_count++;
						

		}				
		//clearing the argument list.
		arglist.clear();
		logfile<< "factor\t: ID LPAREN argument_list RPAREN" << endl;
		Nodeinfo *pt=new Nodeinfo();
		pt->str="factor : ID LPAREN argument_list RPAREN \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n";
		pt->str+="ID : "+$1->getname()+"\t<Line: "+to_string(line_count)+">\n";
		pt->str+="LPAREN : (\t<Line: "+to_string(line_count)+">\n";
		tmp4=parsetreestack.top();
		parsetreestack.pop();
					

		tmp4->str+="RPAREN : )\t<Line: "+to_string(line_count)+">\n";
		pt->str+=tmp4->str;
		pt->str=split(pt->str);
		parsetreestack.push(pt);

		

	}
	| LPAREN expression RPAREN{
		logfile<< "factor\t: LPAREN expression RPAREN" << endl;
		Nodeinfo *pt=new Nodeinfo();
		pt->str="factor : LPAREN expression RPAREN \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n";
		pt->str+="LPAREN : (\t<Line: "+to_string(line_count)+">\n";
		tmp4=parsetreestack.top();
		parsetreestack.pop();
					

		tmp4->str+="RPAREN : )\t<Line: "+to_string(line_count)+">\n";
		pt->str+=tmp4->str;
		pt->str=split(pt->str);
		parsetreestack.push(pt);

	}
	| CONST_INT {
		$$=new symbolInfo($1->getname(),"INT");
		logfile<< "factor\t: CONST_INT" << endl;
		tmp4=new Nodeinfo();
	tmp4->str="factor : CONST_INT \t<Line: "+to_string(line_count)+"-"+
	to_string(line_count)+">\n";
	tmp4->str+="CONST_INT : "+$1->getname()+"\t<Line: "+to_string(line_count)+">\n";
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4); 

	}
	| CONST_FLOAT {
				$$=new symbolInfo($1->getname(),"FLOAT");

		logfile<< "factor\t: CONST_FLOAT" <<endl;
		tmp4=new Nodeinfo();
	tmp4->str="factor : CONST_FLOAT \t<Line: "+to_string(line_count)+"-"+
	to_string(line_count)+">\n";
	tmp4->str+="CONST_FLOAT : "+$1->getname()+"\t<Line: "+to_string(line_count)+">\n";
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4); 
	}
	| variable INCOP {
		$$=$1;
		logfile<< "factor\t: variable INCOP" <<endl;
			tmp4=parsetreestack.top();
	parsetreestack.pop();
				

	string nab="INCOP : ++\t<Line: "+to_string(line_count)+">\n";
	tmp4->str="factor : variable INCOP \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str+nab;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);

	}
	| variable DECOP {
		$$=$1;
		logfile<< "factor\t: variable DECOP" <<endl;
		tmp4=parsetreestack.top();
	parsetreestack.pop();
				

	string nab="DECOP : --\t<Line: "+to_string(line_count)+">\n";
	tmp4->str="factor : variable DECOP \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str+nab;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);

	}
	;
	
argument_list : arguments 
{
	logfile<<"argument_list : arguments"<<endl;
	tmp4=parsetreestack.top();
	parsetreestack.pop();
				

	tmp4->str="argument_list : arguments \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);

			}
			
			| {
				cout<<"nabid"<<endl;
				logfile<<"argument_list : "<<endl;
	tmp4=new Nodeinfo();
	tmp4->str="argument_list :  \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n";
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);

			  }
			  ;
	
arguments : arguments COMMA logic_expression 
{
	//storing the type of the arguments for checking whether function is called with proper arguments.
			arglist.push_back($3->gettype());
			//errorfile<<$3->gettype()<<" (arg) = "<<to_string(line_count)<<endl;
	logfile<<"arguments : arguments COMMA logic_expression"<<endl;
	Nodeinfo *first=parsetreestack.top();
			parsetreestack.pop();
					

			Nodeinfo *sec=parsetreestack.top();
			parsetreestack.pop();
			

			sec->str+="COMMA : ,\t<Line: "+to_string(line_count)+">\n";
			first->str=sec->str+first->str;
			tmp4=new Nodeinfo();
			tmp4->str="arguments : arguments COMMA logic_expression \t<Line: "+to_string(line_count)+"-"+to_string(line_count)
			+">\n"+first->str;
			tmp4->str=split(tmp4->str);
			parsetreestack.push(tmp4);

}
	      | logic_expression 
		  {
			cout<<"hii"<<endl;
			//storing the type of the arguments for checking whether function is called with proper arguments.
			arglist.push_back($1->gettype());
			logfile<<"arguments : logic_expression"<<endl;
			tmp4=parsetreestack.top();
	parsetreestack.pop();
				//tmp4->str=split(tmp4->str);

	tmp4->str="arguments : logic_expression \t<Line: "+to_string(line_count)+"-"+to_string(line_count)+">\n"+tmp4->str;
	tmp4->str=split(tmp4->str);
	parsetreestack.push(tmp4);


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

	logfile.open("1905013_log.txt",ios::out);

	errorfile.open("1905013_error.txt",ios::out);
	parsefile.open("1905013_parse.txt",ios::out);

	

	if(logfile.is_open()==false)
	{
		cout<<"sorry!file can't be opened.."<<endl;

	}
	if(errorfile.is_open()==false)
	{
		cout<<"sorry!file can't be opened.."<<endl;
	}
	if(parsefile.is_open()==false)
	{
		cout<<"sorry!can't be opended.."<<endl;
	}
	
	
table=new symbolTable(11,errorfile);
	yyin=fp;
	yyparse();
	

	fclose(yyin);
	logfile.close();
	errorfile.close();
	parsefile.close();
	
	return 0;
}

