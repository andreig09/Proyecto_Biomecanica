#include <string>

//Convierte un entero a string
std::string itoa(int n){
  std::string rtn;
  bool neg=false;
  if (n<0)
    {
      neg=true;
      n=-n;
    }

  if (n==0)
    return "0";

  for(rtn="";n>0;rtn.insert(rtn.begin(),n%10+'0'),n/=10);

  if (neg)
    rtn.insert(rtn.begin(),'-');
  return rtn;
}

//Distancia vectorial entre dos puntos
double Distance2(double dX0, double dY0, double dX1, double dY1)
{
    return sqrt((dX1 - dX0)*(dX1 - dX0) + (dY1 - dY0)*(dY1 - dY0));
}