#pragma once
#include <bits/stdc++.h>

using namespace std;



class symbolInfo
{
    string name;
    string type;
    string type2;
    int vsize;
    bool haserror;
    symbolInfo *pntr;
    int truelist;
    int falselist;
     // using this to create a ll later.
     int line;
public:
   symbolInfo()
{
    // empty constructor
}
symbolInfo(string name, string type)
{
    
    this->name = name;
    this->type = type;
    this->pntr = NULL;
    this->type2="VAR";
    haserror=false;
    //cout << "Calling constructor of symbolInfo.." << endl;
    //cout <<"name = "<< name << "  type  = " << type << endl;
}
symbolInfo(string name, string type,string type2)
{
    
    this->name = name;
    this->type = type;
    this->pntr = NULL;
    this->type2=type2;
    haserror=false;
    //cout << "Calling constructor of symbolInfo.." << endl;
    //cout <<"name = "<< name << "  type  = " << type << endl;
}
void settruelist(int label)
{
    this->truelist=label;
}
int gettruelist(){return this->truelist;}
void setfalselist(int label){this->falselist=label;}
int getfalselist(){return this->falselist;}
    void setname(string name)
{
    this->name = name;
}

string getname()
{
    return this->name;
}
void setvsize(int t)
{
    this->vsize=t;

}
void setline(int line){this->line=line;}
int getline(){return line;}
void sethaserror(bool nabid){haserror=nabid;}
bool gethaserror(){return haserror;}
int getvsize()
{
    return vsize;
}
void settype(string type)
{
    this->type = type;
}
string gettype()
{
    return this->type;
}
void settype2(string type)
{
    this->type2 = type;
}
string gettype2()
{
    return this->type2;
}

void setpntr(symbolInfo *pntr)
{
    this->pntr = pntr;
}
 symbolInfo* getpntr()
{
    return this->pntr;
}
~symbolInfo()
{
    // no dynamic memeroy allocation
}

};

class scopeTable
{
    symbolInfo** list;
    scopeTable* parent;
    const int buckets; // size of the hash table
    int id;            // assigning a unique id to each scopetable

public:
 scopeTable(int num_buckets, int id) : buckets(num_buckets)
{
    //cout<<"Scopetable constructor.."<<endl;
    //cout << "size of the hashtable = "<<num_buckets << std::endl;
    list = new symbolInfo* [num_buckets];
    for (int i = 0; i < num_buckets; i++)
        list[i] = NULL;
    // creating the hash table
    this->id = id;
    parent = NULL;
   
//    cout << " id = " << id << " size = " << buckets << endl;
}
 void setparent(scopeTable *pa)   
{
    this->parent = pa;
}
    
int getid()
{
    return this->id;
}
int getbuckets()
{
    return this->buckets;
}
scopeTable* getparent()
{
    return this->parent;
}
unsigned long long  hashfunction2(string str)
{
    //long long
    //cout<<"name:"<<str<<""<<endl;
 unsigned long long hash = 0;
 unsigned long long i = 0;
   int len = str.length();
    //cout << "length = " << len << " " << endl;

    for (i = 0; i < len; i++)
    {
        hash = ((str[i]) + (hash << 6) + (hash << 16) - hash);
        //hash=hash%buckets;
    }

//    cout << "this: " << this << endl;
  //  cout << "hash = " << hash << endl;
    //cout << "buckets = " << buckets << endl;
//cout<<"hash: "<<hash<<endl;
    return hash%buckets;
}

unsigned long long hashfunction(string str)
{

return hashfunction2(str)%buckets;
}

symbolInfo* lookup(string value,int w=0)
{
//    cout<<"From scopetable lookup.."<<endl;
//cout << " value to be looked up = " << value << endl;
    


    int pos = hashfunction(value);

   
   // cout << "pos in the hashtable = " << pos << endl;
    // pos is the initial position in the hash table.There might be a chaining.
    symbolInfo *tmp1 = list[pos];
    int chain = 1;
   
    while (tmp1 != NULL)
    {
        if (value == tmp1->getname())
        {
            //cout << "founded" << endl;
            if(w==0){
            //output  << tmp1->getname() << endl;
            //output << "\t'" << tmp1->getname() << "' found in ScopeTable# " << id << " at position " << pos+1 << ", " << chain << endl;
            }
            return tmp1;
        }
        tmp1 = tmp1->getpntr();

        chain++;
    }
   // cout<<"DONE WITH THE Lookup"<<endl;

    return NULL;
}

bool insert(symbolInfo &newsymbol)
{
//    cout << "From insert(scopeTable)..  " <<  endl;
    
    if (lookup(newsymbol.getname(),1))
    {
  //      output << "" << newsymbol.getname() << " "<<newsymbol.gettype()<<endl
  //output<<"\t"<<newsymbol.getname()<<" already exists in the current ScopeTable" << endl;
        //cout << "    " << newsymbol.getname() << " already exists in the current ScopeTable" << endl;

        return false;
    }
    int chain = 1;
    int newpos = hashfunction(newsymbol.getname());
    //cout << "Inserting position = " << newpos << endl;
    if (list[newpos] == NULL)
    {
        //cout << "Yes.Empty place" << endl;
        list[newpos] = &newsymbol;
        list[newpos]->setpntr(NULL);
    }
    else
    {
        symbolInfo *tmp2 = list[newpos];
          chain++;
        while (tmp2->getpntr() != NULL)
        {
            tmp2 = tmp2->getpntr();
            chain++;
        }
        tmp2->setpntr(&newsymbol);
        tmp2 = tmp2->getpntr();
        tmp2->setpntr(NULL);
    }
    //cout << "Done inserting.." << endl;
//    output   << newsymbol.getname() << " " << newsymbol.gettype() << endl;
  //  output 
         // output << "\tInserted in ScopeTable# " << id << " at position " << newpos+1 << ", " << chain << endl;

    return true;
}

bool Delete(string newsymbol)
{
//    cout<<"From scopetable delete"<<endl;
  //  cout<<"value to be deleted " <<newsymbol<<endl;
    if (lookup(newsymbol,1) == NULL)
    {
    //    cout << "Doesn't exist" << endl;
        // output  << newsymbol << endl;
        // output << "\tNot found in the current ScopeTable" << endl;
        return false;
    }
    int chain = 1;
    int newpos = hashfunction(newsymbol);
    symbolInfo *tmp3 = list[newpos];
    symbolInfo *tmp4;
    if (list[newpos]->getname() == newsymbol)
    {
        list[newpos] = list[newpos]->getpntr();
    }
    else
    {
        tmp4 = list[newpos]->getpntr();
        while (tmp4 != NULL && tmp4->getname() != newsymbol)
        {
            tmp4 = tmp4->getpntr();
            tmp3 = tmp3->getpntr();
            chain++;
        }
        tmp3->setpntr(tmp4->getpntr());
        tmp4->setpntr(NULL);
     }
    // output << newsymbol << endl;
    // output << "\tDeleted '" << newsymbol << "' from ScopeTable# " << id << " at position " << newpos+1 << ", " << chain << endl;

    return true;
}
void print(ostream &output)
{
    output << "\tScopeTable# " << this->id << endl;
    symbolInfo *tmp;
    int t = 0;
    while (t < buckets)
    {
        tmp = list[t];
        //cout<<" t = "<<t+1<<" address "<<tmp<<endl;
        //output << "    " << t+1  << "--> ";
        if (tmp == NULL)
        {
         //   output << " ";
        }
else{
     output << "    " << t+1  << "--> ";
        while (tmp != NULL)
        {
           
           // cout << "<" << tmp->getname() << "," << tmp->gettype() << "> "<<endl;
          // cout<<tmp->gettype2()<<endl;

            if(tmp->gettype2().compare("FUNCTION")==0)
            {
               // cout<<"hurrah"<<endl;
                 output << "<" << tmp->getname() << ", FUNCTION, " << tmp->gettype() << "> ";

            }
            else if(tmp->gettype2().compare("ARRAY")==0)
            {
                output << "<" << tmp->getname() << ", ARRAY, " << tmp->gettype() << "> ";

            }
            else
            output << "<" << tmp->getname() << ", " << tmp->gettype() << "> ";

            tmp = tmp->getpntr();
        }
          output << " " << endl;
}
        t++;
      
    }
}

~scopeTable()
{
    delete[] list;
}

};

class symbolTable
{
    scopeTable *currentScope;
    int bucket_size;
    static inline int Id = 1;

public:
   symbolTable(int bucket_size)
{
 //   cout << "Calling constrcutor of symboltable.." << endl;
    this->bucket_size = bucket_size;
    currentScope = NULL;
    Id = 1;
    scopeTable *temp = new scopeTable(bucket_size, Id);
    temp->setparent(this->currentScope);
    this->currentScope = temp;

    //output << "\tScopeTable# " << Id << " created" << endl;
//    cout << "Done.." << endl;
}
   
~symbolTable()
{

}
void enterScope()
{
    Id++;
    int bucks;

    bucks = bucket_size;
    scopeTable *temp=new scopeTable(bucks,Id);
    temp->setparent(this->currentScope);
    this->currentScope = temp;
    
 //   cout << "\tScopeTable# " << Id << " created"<<endl;;
}
int getcurrentScopeId(){return this->currentScope->getid();}
bool exitScope(int saffat=0)
{
    if (currentScope == NULL || currentScope->getparent() == NULL)
    {
        if(saffat!=0)
        {
 // output<<"\tScopeTable# 1 removed"<<endl;
        }
        else{
        //cout << "Nothing to exit" << endl;
        
     //   cout<<"\tScopeTable# 1 cannot be removed"<<endl;
          }
        return false;
       
    }
    else{
        //cout<<"IN exit"<<endl;
       // cout<<"id for currentscope"<<currentScope->getid()<<endl;
         
    //output << "\tScopeTable# " << currentScope->getid() << " removed" << endl;

    currentScope = currentScope->getparent();
//    cout<<"id for currentscope parent"<<currentScope->getid()<<endl;
    return true;
   
    }
    }
   
bool insert(symbolInfo& newsymbol)
{
   // cout << "Calling symbolTable insert" << endl;
    bool tmp = currentScope->insert(newsymbol);
    //output<<currentScope->getid()<<endl;
    if (tmp == true)
    {
     //    cout<<"current scope="<<Id<<"Cmd  I  "<<newsymbol.getname()<<" "<<newsymbol.gettype()<<endl;
    }
 //   cout << "ending symbolTable insert" << endl;
    return tmp;
}
bool remove(string newsymbol)
{
    bool tmp = currentScope->Delete(newsymbol);
    return tmp;
}
symbolInfo* lookup(string key)
{
    scopeTable *tmp = currentScope;
    symbolInfo *ans = NULL;
    //cout << "from symboltable key = " << key << endl;
    while (tmp != NULL)
    {
        ans = tmp->lookup(key);
        if (ans != NULL)
            return ans;
        tmp = tmp->getparent();
    }
    
    //output << ""<< key << endl<<"\t'"<<key<<"' not found in any of the ScopeTables" << endl;
    return NULL;
}
symbolInfo* lookuphere(string key)
{
    scopeTable *tmp = currentScope;
    symbolInfo *ans = NULL;
    //cout << "from symboltable key = " << key << endl;
    //while (tmp != NULL)
    //{
        ans = tmp->lookup(key);
        if (ans != NULL)
            return ans;
     //   tmp = tmp->getparent();
    //}
    
    //output << ""<< key << endl<<"\t'"<<key<<"' not found in any of the ScopeTables" << endl;
    return NULL;
}
void printCurrent(ostream &output)
{
 //   output 
   //        << "P C" << endl;
    currentScope->print(output);
}
void printAll(ostream &output)
{
    //output 
      //     << "P A" << endl;
    scopeTable *tmp = currentScope;

    while (tmp != NULL)
    {
        tmp->print(output);
        tmp = tmp->getparent();
    }
}
};