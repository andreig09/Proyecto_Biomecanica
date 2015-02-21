//OpenCV Headers
#include<cv.h>
#include<highgui.h>

//NameSpaces
using namespace cv;
using namespace std;

//Filtra una imagen dada según determinado rango de color en formato HSV, devuelve una imagen en blanco y negro 
IplImage* filterOtsu(IplImage *img, int thresh, VideoWriter oVideoWriter, bool guardar){

	//cvNamedWindow("filtro");

	int dWidth = cvGetSize(img).width;
    int dHeight = cvGetSize(img).height;
	IplImage *hsvframe=cvCreateImage(cvSize(dWidth,dHeight),8,1);//Image in HSV color space
	IplImage *threshy=cvCreateImage(cvSize(dWidth,dHeight),8,1); //Threshold image of defined color
		
	//smooth the original image using Gaussian kernel
	//cvSmooth(img, img, CV_MEDIAN,3,3);  //----------------> el kernel es el método que se usa para remover ruido, habría que ver cual es el mejor para
										  //				  lo que queremos. Aca están las opciones: http://docs.opencv.org/modules/imgproc/doc/filtering.html
	//Changing the color space from BGR to HSV
	cvCvtColor(img,hsvframe,CV_BGR2GRAY);
	
	//Thresholding the frame for the color given
	//cvInRangeS(hsvframe,min, max,threshy);
	cvThreshold(hsvframe,threshy,thresh,255,CV_THRESH_BINARY);
	//cvThreshold(hsvframe,threshy,0,255,CV_THRESH_BINARY | CV_THRESH_OTSU);

	//smooth the thresholded image using Median kernel
    //cvSmooth(threshy,threshy,CV_MEDIAN,3,3);
	
	//cvShowImage("filtro",threshy);

	if( (guardar) ){
		oVideoWriter.write(threshy);
	}
	
	//cvReleaseImage(&threshy);
	cvReleaseImage(&hsvframe);

	return threshy;
}