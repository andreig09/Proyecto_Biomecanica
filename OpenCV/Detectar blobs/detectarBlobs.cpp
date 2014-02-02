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
using namespace cvb;
using namespace std;


IplImage*	detectarBlobs(IplImage *filtrada){

	//Structure to hold blobs
	CvBlobs blobs;

	double dWidth = cvGetSize(filtrada).width;
    double dHeight = cvGetSize(filtrada).height;
	IplImage *labelImg=cvCreateImage(cvSize(dWidth,dHeight),IPL_DEPTH_LABEL,1);//Image Variable for blobs
	IplImage *ImgBlobs=cvCreateImage(cvSize(dWidth,dHeight),IPL_DEPTH_8U,3);//Image Variable for blobs


	//Finding the blobs
	unsigned int result=cvLabel(filtrada,labelImg,blobs);
	//Rendering the blobs
	cvRenderBlobs(labelImg,blobs,filtrada,ImgBlobs);
	
	vector< pair<CvLabel, CvBlob*> > blobList;
    copy(blobs.begin(), blobs.end(), back_inserter(blobList));
		
	CvFont font = cvFontQt("CV_FONT_ITALIC");
	CvPoint centroide;
	char lbl='0';

	//Filtering the blobs
	//cvFilterByArea(blobs,60,500);
	for (CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it)
	{
		centroide.x = it->second->centroid.x;
		centroide.y = it->second->centroid.y;
		lbl = it->second->label;
		//cvAddText(ImgBlobs,&lbl,centroide,&font);
		cvPutText(ImgBlobs,&lbl,centroide,&font,cvScalar(200,200,250));
		//cvPutText(ImgBlobs,it->second->label,it->second->centroid,&font);
		
	//double moment10 = it->second->m10;
	//double moment01 = it->second->m01;
	//double area = it->second->area;
	//Variable for holding position
	//int x1;
	//int y1;
	//Calculating the current position
	//x1 = moment10/area;
	//y1 = moment01/area;
	}

	//if (cvGreaterBlob(blobs)){
	
		//blob = blobs[cvLargestBlob(blobs)];

		//if(lastX>=0 && lastY>=0)
			//    {
					// Draw a yellow line from the previous point to the current point
					//cvLine(redline, cvPoint(x1, y1), cvPoint(lastX, lastY), cvScalar(0,0,255), 4);
				//	cvLine(redline, cvPoint(blob->centroid.x, blob->centroid.y), cvPoint(lastX, lastY), cvScalar(0,0,255), 4);
				//}

		//lastX = blob->centroid.x;
		//lastY = blob->centroid.y;

		//cvAdd(frame,redline,frame);
		//}
	return ImgBlobs;
}
