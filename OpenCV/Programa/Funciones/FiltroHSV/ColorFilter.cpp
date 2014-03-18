//OpenCV Headers
#include<cv.h>
#include<highgui.h>

//Filtra una imagen dada según determinado rango de color en formato HSV, devuelve una imagen en blanco y negro 
IplImage* filterByColorHSV(IplImage *img, CvScalar min, CvScalar max){

	cvNamedWindow("filtro");

	double dWidth = cvGetSize(img).width;
    double dHeight = cvGetSize(img).height;
	IplImage *hsvframe=cvCreateImage(cvSize(dWidth,dHeight),8,3);//Image in HSV color space
	IplImage *threshy=cvCreateImage(cvSize(dWidth,dHeight),8,1); //Threshold image of defined color
	
	//smooth the original image using Gaussian kernel
	cvSmooth(img, img, CV_GAUSSIAN,3,3);  //----------------> el kernel es el método que se usa para remover ruido, habría que ver cual es el mejor para
										  //				  lo que queremos. Aca están las opciones: http://docs.opencv.org/modules/imgproc/doc/filtering.html
	//Changing the color space from BGR to HSV
	cvCvtColor(img,hsvframe,CV_BGR2HSV);
	//Thresholding the frame for the color given
	cvInRangeS(hsvframe,min, max,threshy);
	//smooth the thresholded image using Median kernel
    cvSmooth(threshy,threshy,CV_MEDIAN,7,7);
	
	cvShowImage("filtro",threshy);
	
	return threshy;
	cvReleaseImage(&threshy);
}