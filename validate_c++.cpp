#include "validate_c++.h"

#include <vector>
#include <iosfwd>
#include <string>
#include <sstream>
using namespace std;


//isFloat taken from http://stackoverflow.com/questions/447206/c-isfloat-function
static bool isFloat( std::string myString ) {
    std::istringstream iss(myString);
    float f;
    iss >> std::noskipws >> f; // noskipws considers leading whitespace invalid
    // Check the entire string was consumed and if either failbit or badbit is set
    return iss.eof() && !iss.fail();
}

static bool isInt(std::string myString)
{
    for(char &cp:myString)
        if (!isdigit(cp)) return false;
    return true;
}


int main()
{
    auto _b = [](bool b)->string{
        return b?"True":"False";
    };

    string s1("345"),s2("234.5"),s3("2123x");
    cout<<s1<<" isInt:"<<_b(isInt(s1))<<endl;
    cout<<s2<<" isInt:"<<_b(isInt(s2))<<endl<<endl;

    cout<<s2<<" isFloat:"<<_b(isFloat(s2))<<endl;
    cout<<s3<<" isFloat:"<<_b(isFloat(s3))<<endl<<endl;
    return 0;
}
