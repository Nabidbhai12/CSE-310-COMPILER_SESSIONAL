#include <bits/stdc++.h>
using namespace std;

class symbolInfo
{
    string name;
    string type;
    symbolInfo *pntr; // using this to create a ll later.
public:
    symbolInfo();
    symbolInfo(string, string);
    void setname(string);
    string getname();
    void settype(string);
    string gettype();
    void setpntr(symbolInfo* );
    symbolInfo* getpntr();
    ~symbolInfo();
};
symbolInfo::symbolInfo()
{
    // empty constructor
}
symbolInfo::symbolInfo(string name, string type)
{
    this->name = name;
    this->type = type;
    this->pntr = NULL;
    //cout << "Calling constructor of symbolInfo.." << endl;
    //cout <<"name = "<< name << "  type  = " << type << endl;
}
void symbolInfo::setname(string name)
{
    this->name = name;
}
string symbolInfo::getname()
{
    return this->name;
}

void symbolInfo::settype(string type)
{
    this->type = type;
}
string symbolInfo::gettype()
{
    return this->type;
}
void symbolInfo::setpntr(symbolInfo *pntr)
{
    this->pntr = pntr;
}
symbolInfo *symbolInfo::getpntr()
{
    return this->pntr;
}
symbolInfo::~symbolInfo()
{
    // no dynamic memeroy allocation
}

class scopeTable
{
    symbolInfo** list;
    scopeTable* parent;
    const int buckets; // size of the hash table
    int id;            // assigning a unique id to each scopetable

public:
    scopeTable();
    scopeTable(int, int);
    int getid();
    int getbuckets();
    void setparent(scopeTable *);
    scopeTable *getparent();
    int hashfunction(string);
    unsigned long long  hashfunction2(string);
    symbolInfo *lookup(string, ostream &,int);
    bool insert(symbolInfo&, ostream &);
    bool Delete(string, ostream &);
    void print(ostream &);
    ~scopeTable();
};
scopeTable::scopeTable(int num_buckets, int id) : buckets(num_buckets)
{
    cout<<"Scopetable constructor.."<<endl;
    cout << "size of the hashtable = "<<num_buckets << std::endl;
    list = new symbolInfo* [num_buckets];
    for (int i = 0; i < num_buckets; i++)
        list[i] = NULL;
    // creating the hash table
    this->id = id;
    parent = NULL;
   
    cout << " id = " << id << " size = " << buckets << endl;
}
void scopeTable::setparent(scopeTable *pa)
{
    this->parent = pa;
}
int scopeTable::getid()
{
    return this->id;
}
int scopeTable::getbuckets()
{
    return this->buckets;
}
scopeTable *scopeTable::getparent()
{
    return this->parent;
}
unsigned long long  scopeTable::hashfunction2(string str)
{
  unsigned long long  hash = 0;
 int i = 0;
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

    return hash%buckets;
}

 int scopeTable::hashfunction(string str)
{

return hashfunction2(str)%buckets;
}

symbolInfo* scopeTable::lookup(string value, ostream &output,int w=0)
{
    cout<<"From scopetable lookup.."<<endl;
cout << " value to be looked up = " << value << endl;
    


    int pos = hashfunction(value);

   
    cout << "pos in the hashtable = " << pos << endl;
    // pos is the initial position in the hash table.There might be a chaining.
    symbolInfo *tmp1 = list[pos];
    int chain = 1;
   
    while (tmp1 != NULL)
    {
        if (value == tmp1->getname())
        {
            cout << "founded" << endl;
            if(w==0){
            output  << tmp1->getname() << endl;
            output << "\t'" << tmp1->getname() << "' found in ScopeTable# " << id << " at position " << pos+1 << ", " << chain << endl;
            }
            return tmp1;
        }
        tmp1 = tmp1->getpntr();

        chain++;
    }
    cout<<"DONE WITH THE Lookup"<<endl;

    return NULL;
}

bool scopeTable::insert(symbolInfo &newsymbol, ostream &output)
{
    cout << "From insert(scopeTable)..  " <<  endl;
    
    if (lookup(newsymbol.getname(), output,1))
    {
  //      output << "" << newsymbol.getname() << " "<<newsymbol.gettype()<<endl
  output<<"\t"<<newsymbol.getname()<<" already exists in the current ScopeTable" << endl;
        cout << "    " << newsymbol.getname() << " already exists in the current ScopeTable" << endl;

        return false;
    }
    int chain = 1;
    int newpos = hashfunction(newsymbol.getname());
    cout << "Inserting position = " << newpos << endl;
    if (list[newpos] == NULL)
    {
        cout << "Yes.Empty place" << endl;
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
    cout << "Done inserting.." << endl;
//    output   << newsymbol.getname() << " " << newsymbol.gettype() << endl;
  //  output 
         // output << "\tInserted in ScopeTable# " << id << " at position " << newpos+1 << ", " << chain << endl;

    return true;
}

bool scopeTable::Delete(string newsymbol, ostream &output)
{
    cout<<"From scopetable delete"<<endl;
    cout<<"value to be deleted " <<newsymbol<<endl;
    if (lookup(newsymbol, output,1) == NULL)
    {
        cout << "Doesn't exist" << endl;
        output  << newsymbol << endl;
        output << "\tNot found in the current ScopeTable" << endl;
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
    output << newsymbol << endl;
    output << "\tDeleted '" << newsymbol << "' from ScopeTable# " << id << " at position " << newpos+1 << ", " << chain << endl;

    return true;
}
void scopeTable::print(ostream &output)
{
    output << "\tScopeTable# " << this->id << endl;
    symbolInfo *tmp;
    int t = 0;
    while (t < buckets)
    {
        tmp = list[t];
        cout<<" t = "<<t+1<<" address "<<tmp<<endl;
        //output << "    " << t+1  << "--> ";
        if (tmp == NULL)
        {
         //   output << " ";
        }
else{
     output << "    " << t+1  << "--> ";
        while (tmp != NULL)
        {
           
            cout << "<" << tmp->getname() << "," << tmp->gettype() << "> "<<endl;

            output << "<" << tmp->getname() << "," << tmp->gettype() << "> ";

            tmp = tmp->getpntr();
        }
          output << " " << endl;
}
        t++;
      
    }
}

scopeTable::~scopeTable()
{
    delete[] list;
}
class symbolTable
{
    scopeTable *currentScope;
    int bucket_size;
    static inline int Id = 1;

public:
    symbolTable(int, ostream &);
    ~symbolTable();
    scopeTable *getCurrentScope() { return currentScope; }
    void enterScope(ofstream &);
    bool exitScope(int);
    int getbuckets() { return bucket_size; }
    bool insert(symbolInfo&, ostream &);
    bool remove(string, ostream &);
    symbolInfo *lookup(string, ostream &);
    void printCurrent(ostream &);
    void printAll(ostream &);
};
symbolTable::symbolTable(int bucket_size, ostream &output)
{
    cout << "Calling constrcutor of symboltable.." << endl;
    this->bucket_size = bucket_size;
    currentScope = NULL;
    Id = 1;
    scopeTable *temp = new scopeTable(bucket_size, Id);
    temp->setparent(this->currentScope);
    this->currentScope = temp;

    output << "\tScopeTable# " << Id << " created" << endl;
    cout << "Done.." << endl;
}
symbolTable::~symbolTable()
{

}
void symbolTable::enterScope(ofstream &output)
{
    Id++;
    int bucks;

    bucks = bucket_size;
    scopeTable *temp=new scopeTable(bucks,Id);
    temp->setparent(this->currentScope);
    this->currentScope = temp;
    
    //output << "\tScopeTable# " << Id << " created"<<endl;;
}
bool symbolTable::exitScope(int saffat=0)
{
    if (currentScope == NULL || currentScope->getparent() == NULL)
    {
        if(saffat!=0)
        {
 // output<<"\tScopeTable# 1 removed"<<endl;
        }
        else{
        cout << "Nothing to exit" << endl;
        if(currentScope->getparent()==NULL)
        cout<<"\tScopeTable# 1 cannot be removed"<<endl;
        }
        return false;
       
    }
    else{
        cout<<"IN exit"<<endl;
        cout<<"id for currentscope"<<currentScope->getid()<<endl;
         
    //output << "\tScopeTable# " << currentScope->getid() << " removed" << endl;

    currentScope = currentScope->getparent();
    cout<<"id for currentscope parent"<<currentScope->getid()<<endl;
    return true;
   
    }
    }
   
bool symbolTable::insert(symbolInfo& newsymbol, ostream &output)
{
    cout << "Calling symbolTable insert" << endl;
    bool tmp = currentScope->insert(newsymbol, output);
    if (tmp == true)
    {
        // output<<"Cmd <"<cmd<<": I "<<newsymbol.getname()<<" "<<newsymbol.gettype()<<endl;
    }
    cout << "ending symbolTable insert" << endl;
    return tmp;
}
bool symbolTable::remove(string newsymbol, ostream &output)
{
    bool tmp = currentScope->Delete(newsymbol, output);
    return tmp;
}
symbolInfo *symbolTable::lookup(string key, ostream &output)
{
    scopeTable *tmp = currentScope;
    symbolInfo *ans = NULL;
    cout << "from symboltable key = " << key << endl;
    while (tmp != NULL)
    {
        ans = tmp->lookup(key, output);
        if (ans != NULL)
            return ans;
        tmp = tmp->getparent();
    }
    
    output << ""<< key << endl<<"\t'"<<key<<"' not found in any of the ScopeTables" << endl;
    return NULL;
}
void symbolTable::printCurrent(ostream &output)
{
 //   output 
   //        << "P C" << endl;
    currentScope->print(output);
}
void symbolTable::printAll(ostream &output)
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


