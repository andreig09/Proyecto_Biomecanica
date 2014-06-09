#include"cvblob.h"
#include<cv.h>
#include<highgui.h>
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
			cvPutText(img,buffer.c_str(),centroide,&font,cvScalar(0,0,0));
		}
	
	}

//obtiene el m�ximo de valores de todos los threshold
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
void startXML(){
	FILE *file;
	file = fopen("markers.xml", "w");
	fprintf(file, "%s\n", "<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	fprintf(file, "%s\n", "<Detected_Markers Version=\"1\">");
	fclose(file);
}

//Funcion para escribir el xml de los markers detectados
void XMLAddBlobs(CvBlobs blobs, FILE *file){
	CvPoint centroide;
	for (CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it){
		centroide.x = it->second->centroid.x;
		centroide.y = it->second->centroid.y;
		fprintf(file, "\t\t%s%i%s\n", "<Marker id=\"", it->first, "\" >");
		fprintf(file, "\t\t\t%s%i%s%i%s\n", "<Centroid x=\"", centroide.x, "\" y=\"", centroide.y, "\" />");
		fprintf(file, "\t\t%s\n", "</Marker>");
	}
}

//Funcion para escribir el xml de los markers detectados
void XMLAddFrame(int frameNumber, CvBlobs blobs){
	FILE *file;
	file = fopen("markers.xml", "a");
	fprintf(file, "\t%s%i%s\n", "<Frame id=\"", frameNumber, "\" >");
	XMLAddBlobs(blobs, file);
	fprintf(file, "\t%s\n", "</Frame>");
	fclose(file);
}

//Funcion para escribir el xml de los markers detectados
void endXML(){
	FILE *file;
	file = fopen("markers.xml", "a");
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