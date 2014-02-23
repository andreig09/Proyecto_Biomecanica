//OpenCV Headers
#include<cv.h>
#include<highgui.h>
//Input-Output
#include<stdio.h>
//Blob Library Headers
#include"cvblob.h"
//#include <cvblob.h>
#include<Windows.h>
//NameSpaces
using namespace cv;
using namespace cvb;
using namespace std;

struct blobsDetectados
{
	CvBlobs blobs;
	IplImage *imgBlobs;
};

blobsDetectados	detectarBlobs(IplImage *filtrada);
double Distance2(double dX0, double dY0, double dX1, double dY1);
CvBlob ubicarBlob(CvBlob blobanterior, CvBlobs blobs);
IplImage* seguirBlob(IplImage* cuadro,IplImage* filtrada,CvBlob lastBlob,IplImage* imagenTracking);