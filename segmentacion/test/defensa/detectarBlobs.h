//OpenCV Headers
#include<cv.h>
#include<highgui.h>
//Input-Output
#include<stdio.h>
//Blob Library Headers
#include"cvblob.h"
//#include <cvblob.h>
//#include<Windows.h>  Solo funca en windows
//NameSpaces
using namespace cv;
using namespace cvb;
using namespace std;

struct blobsDetectados
{
	CvBlobs blobs;
	IplImage *imgBlobs;
};

struct imgtrack
{
	IplImage *tracking;
	IplImage *BlobsTrack;
	CvBlobs BlobsAnteriores;
};

blobsDetectados	detectarBlobs(IplImage *filtrada , double aMax ,double aMin, VideoWriter oVideoWriter2, VideoWriter oVideoWriter3, bool guardar);

CvBlob ubicarBlob(CvBlob blobanterior, CvBlobs blobs);

//imgtrack seguirBlob(IplImage* cuadro,IplImage* filtrada,CvBlob lastBlob,IplImage* imagenTracking);

CvBlobs blobsCirculares(CvBlobs intBlobs);