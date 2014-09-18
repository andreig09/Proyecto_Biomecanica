#include"cvblob.h"
#include<cv.h>
#include<highgui.h>
#include <fstream>
#include <string>

using namespace cv;
using namespace cvb;
using namespace std;

const char *markers_name = ".xml";

//Convierte un entero a string
string itoa(int n){
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

 const char* substring(const char* string){
  const char *e;
  int index;
  e = strchr(string, '.');
  index = (int)(e - string);
  char* p = new char [index+1];
  strncpy(p, string, index);
  p[index] = NULL;
  return p;
 }

//Concatenar dos const char
 const char* XMLname(const char *one){
	const char* r = new char [strlen(one)];
	r = substring(one);
	const char* p = new char [strlen(r)+strlen(markers_name)+1];
	const char* s = new char [strlen(one)+strlen(markers_name)+1];
    //strcpy(const_cast<char*>(p),one);
	strcpy(const_cast<char*>(p),r);
	strcat(const_cast<char*>(p),markers_name);
	strcpy(const_cast<char*>(s),p);
	return s;
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
			cvPutText(img,buffer.c_str(),centroide,&font,cvScalar(0,0,0));
		}
	
	}

//obtiene el máximo de valores de todos los threshold
//double getMaxThresh(const char * txtName){
double getMaxThresh(int l, double *thr){
	double maxThres;
	maxThres = 0;
	
	for (int i = 0; i < l; i++)
	{
		if (thr[i] > maxThres)
		{
			maxThres = thr[i];
		}
	}
	return maxThres;
}

//Funcion para escribir el xml de los markers detectados
void startXML(const char *video){
	FILE *file;
	file = fopen(video, "w");
	fprintf(file, "%s\n", "<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	fprintf(file, "%s\n", "<Detected_Markers Version=\"1\">");
	fclose(file);
}

//Funcion para escribir el xml de los markers detectados
void XMLAddBlobs(CvBlobs blobs, FILE *file){
	int i =0;
	//CvPoint centroide;
	CvPoint2D64f centroide;
	for (CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it){
		i++;
		centroide.x = it->second->centroid.x;
		centroide.y = it->second->centroid.y;
		//fprintf(file, "\t\t%s%i%s\n", "<Marker id=\"", it->first, "\" >");
		fprintf(file, "\t\t%s%i%s\n", "<Marker id=\"", i, "\" >");
		//fprintf(file, "\t\t\t%s%i%s%i%s\n", "<Centroid x=\"", centroide.x, "\" y=\"", centroide.y, "\" />");
		fprintf(file, "\t\t\t%s%f%s%f%s\n", "<Centroid x=\"", centroide.x, "\" y=\"", centroide.y, "\" />");
		fprintf(file, "\t\t%s\n", "</Marker>");
	}
}

//Funcion para escribir el xml de los markers detectados
void XMLAddFrame(int frameNumber, CvBlobs blobs,const char *video){
	FILE *file;
	file = fopen(video, "a");
	fprintf(file, "\t%s%i%s\n", "<Frame id=\"", frameNumber, "\" >");
	XMLAddBlobs(blobs, file);
	fprintf(file, "\t%s\n", "</Frame>");
	fclose(file);
}

//Funcion para escribir el xml de los markers detectados
void endXML(const char *video){
	FILE *file;
	file = fopen(video, "a");
	fprintf(file, "%s\n", "</Detected_Markers>");
	fclose(file);
}

//encontrar circulos en la imagen en escala de grises
void findCircles(IplImage* img){
	
	vector<Vec3f> circles;

	Mat imgMat(img); 
		
	HoughCircles(imgMat,circles,CV_HOUGH_GRADIENT,
		2,	//accumulator resolution (size of the image / 2)
		5,	// minimun distance between two circles
		100,	//Canny high threshold
		100,	//minimum numbre of votes
		0, 1000); //min and max radius
	
	vector<Vec3f>::const_iterator itc = circles.begin();

	while (itc!=circles.end()){
		circle(imgMat,Point((*itc)[0], (*itc)[1]), //circle centre
			(*itc)[2], //circle radius
			Scalar(153,255,255), //color
			2); //thickness
		++itc;
	}

	namedWindow("circulos",CV_WINDOW_AUTOSIZE);
	imshow("circulos",imgMat);

}

double FindT(int argc,char *argv[]){
	double result = -1;
	
	if (argc > 2){
	for (int i = 2; i < argc; i++)
	{
		if (*argv[i] == 't')
		{
			result = atof(argv[i+1]);
		}
	}
	}
	return result;
}

double FindA(int argc,char *argv[]){
	double result = -1;
	
	if (argc > 2){
	for (int i = 2; i < argc; i++)
	{
		if (*argv[i] == 'A')
		{
			result = atof(argv[i+1]);
		}
	}
	}
	return result;
}

double Finda(int argc,char *argv[]){
	double result = -1;
	
	if (argc > 2){
	for (int i = 2; i < argc; i++)
	{
		if (*argv[i] == 'a')
		{
			result = atof(argv[i+1]);
		}
	}
	}
	return result;
}

bool Finds(int argc,char *argv[]){
	bool result = false;
	if (argc > 2){
	for (int i = 2; i < argc; i++)
	{
		if (*argv[i] == 's')
		{
			result = true;
		}
	}
	}
	return result;
}