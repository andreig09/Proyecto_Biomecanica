#include <string>
#include"cvblob.h"
//#include<cv.h>

using namespace cv;
using namespace cvb;

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

//Numera blobs empezando por la punta superior izquierda y recorriendo cada linea hacia abajo
void numerar(IplImage *img, CvBlobs blobs ){
	
	CvFont font;
    cvInitFont(&font, CV_FONT_HERSHEY_SIMPLEX, 0.4, 0.4, 0, 1, 8);
	CvPoint centroide;
	std::string buffer;
	int itblob = 0;
			
	for (CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it)
		{
			itblob++;
			centroide.x = it->second->centroid.x;
			centroide.y = it->second->centroid.y;
			buffer = itoa(it->first);
			//buffer = itoa(itblob);
			cvPutText(img,buffer.c_str(),centroide,&font,cvScalar(0,0,0));
		}
	
	}