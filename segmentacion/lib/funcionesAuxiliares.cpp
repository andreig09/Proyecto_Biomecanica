#include"cvblob.h"
#include <fstream>
#include <string>

using namespace cv;
using namespace cvb;
using namespace std;


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

//obtiene el máximo de valores de un txt
double getMaxThresh(const char * txtName){
	double maxThres;
	maxThres = 0;
	ifstream file(txtName);
    string str;
	double entero;
    while (getline(file, str))
    {
        entero = stod(str);
		if (entero > maxThres){
			maxThres = entero;
		}
    }
	return maxThres;
}

void startXML(){
	FILE *file;
	file = fopen("markers.xml", "w");
	fprintf(file, "%s\n", "<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	fprintf(file, "%s\n", "<Detected_Markers Version=\"1\">");
	fclose(file);
}

void XMLAddBlobs(CvBlobs blobs, FILE *file){
	for (CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it){
		fprintf(file, "\t\t%s%i%s\n", "<Marker id=\"", it->first, "\" >");
		fprintf(file, "\t\t\t%s%i%s%i%s\n", "<Centroid x=\"", it->second->centroid.x, "\" y=\"", it->second->centroid.y, "\" />");
		fprintf(file, "\t\t%s\n", "<Marker/>");
	}
}


void XMLAddFrame(int frameNumber, CvBlobs blobs){
	FILE *file;
	file = fopen("markers.xml", "a");
	fprintf(file, "\t%s%i%s\n", "<Frame id=\"", frameNumber, "\" >");
	XMLAddBlobs(blobs, file);
	fprintf(file, "\t%s\n", "<Frame/>");
	fclose(file);
}

void endXML(){
	FILE *file;
	file = fopen("markers.xml", "a");
	fprintf(file, "%s\n", "</Detected_Markers>");
	fclose(file);
}