//OpenCV Headers
#include<cv.h>
#include<highgui.h>
//Input-Output
#include<stdio.h>
#include<math.h>
//Blob Library Headers
#include"cvblob.h"
//#include <cvblob.h>
//#include<Windows.h>  //Solo funciona en Windows
#include "funcionesAuxiliares.h"


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

CvBlobs blobsCirculares(CvBlobs intBlobs){
	CvBlobs *OBlobs = new CvBlobs;
	int i = 0;
	//CvBlobs::const_iterator i = OBlobs->begin();
	double difMom;
	//double excentric;
	//CvBlob *blob= new CvBlob;

	for (CvBlobs::const_iterator it=intBlobs.begin(); it!=intBlobs.end(); ++it)
		{
			
			CvBlob *blob;
				blob = (*it).second;
				*blob = *it->second;
			//if ((it->second->m10-it->second->m01 < 5) && (it->second->u02-it->second->u20 < 5) && (it->second->u11 < 5) )
			//difMom = abs((blob->n02-blob->n20)/(blob->n02));
			difMom = abs((blob->n02-blob->n20)/((blob->n20)+(blob->n02)));
			//excentric = (((blob->u20)-(blob->u02))*((blob->u20)-(blob->u02)) + 4*(blob->u11))/(blob->m00);
			if ((difMom < 0.5) && (abs(blob->n11/((blob->n20)+(blob->n02))) < 0.4) )
			//if ((excentric < 1.2) && (excentric > 0.8) )
			{
				//OBlobs->insert(it,(*it).second);
				OBlobs->insert(CvLabelBlob(blob->label,blob));
			}
			
		}
	//delete blob;
	//delete OBlobs;
	return *OBlobs;
}

//Funcion que a partir de una imagen filtrada devuelve los blobs.
//tambien genera la img con blobs y la muestra en una ventana
blobsDetectados	detectarBlobs(IplImage *filtrada, double aMax,double aMin, VideoWriter oVideoWriter2, VideoWriter oVideoWriter3, bool guardar){
	
	//inicializar elementos
	blobsDetectados salida;
	CvBlobs blobs; //structure to hold blobs
	CvBlobs circulos;
	//CvBlobs *blobs = new CvBlobs;
	//CvBlobs *circulos = new CvBlobs;
	
	double dWidth = cvGetSize(filtrada).width;
    double dHeight = cvGetSize(filtrada).height;
	IplImage *labelImg=cvCreateImage(cvSize(dWidth,dHeight),IPL_DEPTH_LABEL,1);//Image Variable for blobs
	IplImage *ImgBlobs=cvCreateImage(cvSize(dWidth,dHeight),IPL_DEPTH_8U,3);//Image Variable for blobs
	IplImage *ImgBlobsAll=cvCreateImage(cvSize(dWidth,dHeight),IPL_DEPTH_8U,3);//Image Variable for blobs

	//Finding the blobs
	unsigned int result=cvLabel(filtrada,labelImg,blobs);
	
	int tamanioBlobs = blobs.size();

	if ( tamanioBlobs > 0) //Si se detecta al menos 1 blob, se dibujan en la imagen y se numeran
	{
	
	//Filtering the blobs (sacar el ruido)
	if ((aMax == -1) && (aMin != -1)){
		cvFilterByArea(blobs,aMin,blobs[cvLargestBlob(blobs)]->area);
	} else if ((aMax != -1) && (aMin == -1)){
		cvFilterByArea(blobs,0,aMax);
	} else if ((aMax != -1) && (aMin != -1)){
		cvFilterByArea(blobs,aMin,aMax);
	}

	circulos = blobsCirculares(blobs);

	//Rendering the blobs
	cvRenderBlobs(labelImg,circulos,filtrada,ImgBlobs);
	cvRenderBlobs(labelImg,blobs,filtrada,ImgBlobsAll);

	//numerar(ImgBlobs,blobs);
	numerar(ImgBlobs,circulos);
	numerar(ImgBlobsAll,blobs);
	
	}
	
	//Se muestra la imagen
	//cvShowImage("Blobs circulares", ImgBlobs);
	//cvShowImage("Blobs", ImgBlobsAll);
	//se guarda
	if( (guardar) ){
		oVideoWriter3.write(ImgBlobsAll);
		oVideoWriter2.write(ImgBlobs);
	}
			
	salida.blobs = circulos;
	salida.imgBlobs = ImgBlobs;
	cvReleaseImage(&ImgBlobs);
	cvReleaseImage(&ImgBlobsAll);
	cvReleaseImage(&labelImg);
	return salida;
	//delete blobs;
	//delete circulos;	
}

//ubica un blob dado en otro conjunto de blobs.
//(POR AHORA ENCUENTRA SOLO EL MAS CERCANO, la idea es hacerlo más 
//robusto, por ejemplo con el sistema de puntajes.)
CvBlob ubicarBlob(CvBlob blobanterior, CvBlobs blobs){ 
	
	//inicializar objetos
	CvPoint centroideanterior;
	centroideanterior.x = blobanterior.centroid.x;
	centroideanterior.y = blobanterior.centroid.y;
	CvPoint centroide;
	CvBlob actual;
	
	//Lista de <label,blob>										//Probablemente esto sea innecesario, pero no pude recorrer los CvBlobs
	vector< pair<CvLabel, CvBlob*> > blobList;
    copy(blobs.begin(), blobs.end(), back_inserter(blobList));

	actual = *blobList[0].second;
	double distancia;
	double distanciaNueva;
	distancia = Distance2(centroideanterior.x,centroideanterior.y,actual.centroid.x,actual.centroid.y);
	int tamanio = blobList.size();

	//recorre todos los blobs y se queda con el que tiene el centroide más cerca
	for (int i = 0; i < tamanio; i++)
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

	//supongo que de un cuadro a otro el blob no se mueve más de 100 pixeles
	//Esto habría que acomodarlo (cuando estén implementadas las otras condiciones) para que
	//en vez de solo la distancia, evalúe si encontró el blob o el mismo desapareció.
	if (distancia < 100)
	{
		return actual;
	}else
	{
		return blobanterior;
	}
	

}

//Función que dibuja una linea entre las posiciones de los 
//centroides de un mismo blob en dos imagenes consecutivas de una secuencia de imagenes
//imgtrack seguirBlob(IplImage* cuadro,IplImage* filtrada,CvBlob lastBlob,IplImage* imagenTracking){
	
	//declaracion de objetos
//	imgtrack salida;
//	CvBlob anterior = lastBlob;
//	IplImage* imgtracked;
//	IplImage* linea = imagenTracking;
//	CvPoint lastcentroid;
//	lastcentroid.x = anterior.centroid.x;
//	lastcentroid.y = anterior.centroid.y;
//	blobsDetectados detectar;
//	CvBlobs blobs;

	//Detectar los blobs de la imagen actual
//	detectar = detectarBlobs(filtrada, argc,argv);
//	blobs = detectar.blobs;
	
	//Si hay al menos uno se ubica el blob deseado
//	if (blobs.size() > 0)
//	{
//	CvBlob blobActual;
//	blobActual  = ubicarBlob(anterior,blobs);
//	int posX;
//	int posY;
//	posX = blobActual.centroid.x;
//	posY = blobActual.centroid.y;

//	if(lastcentroid.x>=0 && lastcentroid.y>=0 && posX>=0 && posY>=0)
//        {
//            // Draw a line from the previous centroid to the current centroid
//            cvLine(linea, cvPoint(posX, posY), cvPoint(lastcentroid.x, lastcentroid.y), cvScalar(0,0,255), 4);
//		}
//	}
	
//	salida.BlobsAnteriores = detectar.blobs;
	
	//Se crea una imagen igual a la actual con los blobs detectados y se le agrega la linea
//	imgtracked = cvCreateImage(cvGetSize(cuadro), IPL_DEPTH_8U, 3);
//	imgtracked = detectar.imgBlobs;
//	cvAdd(imgtracked, linea, imgtracked);

//	salida.BlobsTrack = imgtracked;
//	cvShowImage("Seguimiento", imgtracked);
//	salida.tracking = linea;
//	cvReleaseImage(&imgtracked);
//	cvReleaseImage(&linea);
//	return salida;
//}