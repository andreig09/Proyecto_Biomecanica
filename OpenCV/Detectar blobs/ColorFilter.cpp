//OpenCV Headers
#include<cv.h>
#include<highgui.h>


IplImage* filterByColorHSV(IplImage *img, CvScalar min, CvScalar max){

	
	double dWidth = cvGetSize(img).width;
    double dHeight = cvGetSize(img).height;
	IplImage *hsvframe=cvCreateImage(cvSize(dWidth,dHeight),8,3);//Image in HSV color space
	IplImage *threshy=cvCreateImage(cvSize(dWidth,dHeight),8,1); //Threshold image of defined color
	
	//smooth the original image using Gaussian kernel
	cvSmooth(img, img, CV_GAUSSIAN,3,3); 
	//Changing the color space
	cvCvtColor(img,hsvframe,CV_BGR2HSV);
	//Thresholding the frame for yellow
	cvInRangeS(hsvframe,min, max,threshy);
	//Filtering the frame
	cvSmooth(threshy,threshy,CV_MEDIAN,7,7);
	

	return threshy;
}