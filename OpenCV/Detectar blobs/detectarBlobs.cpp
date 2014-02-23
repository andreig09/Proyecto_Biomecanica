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

//Funcion que a partir de una imagen filtrada devuelve los blobs 
//(tambien genera la img con blobs y los enumera en consola)
CvBlobs	detectarBlobs(IplImage *filtrada){
	
	//Structure to hold blobs
	CvBlobs blobs;

	double dWidth = cvGetSize(filtrada).width;
    double dHeight = cvGetSize(filtrada).height;
	IplImage *labelImg=cvCreateImage(cvSize(dWidth,dHeight),IPL_DEPTH_LABEL,1);//Image Variable for blobs
	IplImage *ImgBlobs=cvCreateImage(cvSize(dWidth,dHeight),IPL_DEPTH_8U,3);//Image Variable for blobs


	//Finding the blobs
	unsigned int result=cvLabel(filtrada,labelImg,blobs);
	
	//Filtering the blobs
	cvFilterByArea(blobs,500,blobs[cvLargestBlob(blobs)]->area);

	//Rendering the blobs
	cvRenderBlobs(labelImg,blobs,filtrada,ImgBlobs);
	
	CvFont font;
    cvInitFont(&font, CV_FONT_HERSHEY_SIMPLEX, 0.4, 0.4, 0, 1, 8);
	CvPoint centroide;
	char lbl='0';
	char buffer[7];
	int itblob = 0;
			
	for (CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it)
	{
		itblob++;
		centroide.x = it->second->centroid.x;
		centroide.y = it->second->centroid.y;
		lbl = it->second->label;
		printf("el label del blob es: %c y es el numero: %i \n",lbl,itblob);
		itoa (itblob,buffer,10);
		cvPutText(ImgBlobs,buffer,centroide,&font,cvScalar(0,0,0));
	}

	cvShowImage("imagen filtrada", ImgBlobs);

	Mat imgf = ImgBlobs;

	imwrite("conBlobs.jpg",imgf);

		
	return blobs;
}

double Distance2(double dX0, double dY0, double dX1, double dY1)
{
    return sqrt((dX1 - dX0)*(dX1 - dX0) + (dY1 - dY0)*(dY1 - dY0));
}

//ubica un blob (o el más parecido y más cercano) de un conjunto de blobs.

//POR AHORA ENCUENTRA SOLO EL MAS CERCANO.
CvBlob ubicarBlob(CvBlob blobanterior, CvBlobs blobs){ 
	
	CvPoint centroideanterior;
	centroideanterior.x = blobanterior.centroid.x;
	centroideanterior.y = blobanterior.centroid.y;
	CvPoint centroide;
	
	CvBlob actual;

	vector< pair<CvLabel, CvBlob*> > blobList;
    copy(blobs.begin(), blobs.end(), back_inserter(blobList));

	actual = *blobList[0].second;
	double distancia;
	double distanciaNueva;
	distancia = Distance2(centroideanterior.x,centroideanterior.y,actual.centroid.x,actual.centroid.y);
	int tamaño = blobList.size();

	for (int i = 0; i < tamaño; i++)
	{
		centroide.x = (*blobList[i].second).centroid.x;
		centroide.y = (*blobList[i].second).centroid.y;
		distanciaNueva = Distance2(centroideanterior.x,centroideanterior.y,centroide.x,centroide.y);
		if (distanciaNueva < distancia )
		{
			actual = (*blobList[i].second);
			distancia = distanciaNueva;
		}
	}

	return actual;

}

void seguirBlob(IplImage* cuadro,CvBlob lastBlob){
	
	CvPoint lastcentroid;
	lastcentroid.x = lastBlob.centroid.x;
	lastcentroid.y = lastBlob.centroid.y;

	CvBlobs blobs;

	blobs = detectarBlobs(cuadro);
	
	CvBlob blobActual;
	blobActual  = ubicarBlob(lastBlob,blobs);
	int posX;
	int posY;
	posX = blobActual.centroid.x;
	posY = blobActual.centroid.y;

	if(lastcentroid.x>=0 && lastcentroid.y>=0 && posX>=0 && posY>=0)
        {
            // Draw a line from the previous point to the current point
            cvLine(cuadro, cvPoint(posX, posY), cvPoint(lastcentroid.x, lastcentroid.y), cvScalar(0,0,255), 4);
		}

    lastBlob = blobActual;    

}
