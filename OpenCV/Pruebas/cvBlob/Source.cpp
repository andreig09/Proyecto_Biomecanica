//OpenCV Headers
#include<cv.h>
#include<highgui.h>
//Input-Output
#include<stdio.h>
//Blob Library Headers
#include"cvblob.h"
//#include <cvblob.h>
#include<Windows.h>
//Definitions
#define h 240
#define w 320
//NameSpaces
using namespace cvb;
using namespace std;

int lastX = -1;
int lastY = -1;
CvBlob* blob;

CvBlob* GetGreaterBlob(CvBlobs blobs){
	CvBlob* greater;
	greater->centroid.x = -1;
	greater->centroid.y = -1;
	for (CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it)
	{

	}
}

int main()
{
//Structure to get feed from video
 CvCapture* capture =0;       
 capture = cvCaptureFromAVI("angryNegro.mp4"); //Camina_pelado.dvd
 if(!capture){
     printf("Capture failure\n");
     return -1;
 }
//Structure to hold blobs
CvBlobs blobs;
//Windows
cvNamedWindow("Blobs",CV_WINDOW_AUTOSIZE);
cvNamedWindow("Video",CV_WINDOW_AUTOSIZE);

//Getting the screen information
int screenx = GetSystemMetrics(SM_CXSCREEN);
int screeny = GetSystemMetrics(SM_CYSCREEN);

double dWidth = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_WIDTH); //get the width of frames of the video
double dHeight = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_HEIGHT); //get the height of frames of the video

//Image Variables
IplImage *frame=cvCreateImage(cvSize(dWidth,dHeight),8,3);   //Original Image
IplImage *hsvframe=cvCreateImage(cvSize(dWidth,dHeight),8,3);//Image in HSV color space
IplImage *labelImg=cvCreateImage(cvSize(dWidth,dHeight),IPL_DEPTH_LABEL,1);//Image Variable for blobs
IplImage *threshy=cvCreateImage(cvSize(dWidth,dHeight),8,1); //Threshold image of yellow color

//draw a red line
IplImage* redline;
redline = cvCreateImage(cvGetSize(frame),IPL_DEPTH_8U,3);
cvZero(redline);
 
while(1)
{
//Getting the current frame
IplImage *fram=cvQueryFrame(capture);
IplImage *frame2 = fram;
//If failed to get break the loop
if(!fram)
break;
//Resizing the capture
cvResize(fram,frame,CV_INTER_LINEAR );
//Flipping the frame
cvFlip(frame,frame,1);
//Changing the color space
cvCvtColor(frame,hsvframe,CV_BGR2HSV);
//Thresholding the frame for yellow
cvInRangeS(hsvframe,cvScalar(0,0,0), cvScalar(180,255,33),threshy);
//Filtering the frame
cvSmooth(threshy,threshy,CV_MEDIAN,7,7);
//cvSmooth(threshy,threshy,CV_GAUSSIAN,3,3);
//Finding the blobs
unsigned int result=cvLabel(threshy,labelImg,blobs);
//Rendering the blobs
cvRenderBlobs(labelImg,blobs,frame,frame);
//Filtering the blobs
cvFilterByArea(blobs,60,500);
for (CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it)
{
double moment10 = it->second->m10;
double moment01 = it->second->m01;
double area = it->second->area;
//Variable for holding position
int x1;
int y1;
//Calculating the current position
x1 = moment10/area;
y1 = moment01/area;
}

if (cvGreaterBlob(blobs)){
	
	blob = blobs[cvGreaterBlob(blobs)];

	if(lastX>=0 && lastY>=0)
		    {
			    // Draw a yellow line from the previous point to the current point
				//cvLine(redline, cvPoint(x1, y1), cvPoint(lastX, lastY), cvScalar(0,0,255), 4);
				cvLine(redline, cvPoint(blob->centroid.x, blob->centroid.y), cvPoint(lastX, lastY), cvScalar(0,0,255), 4);
			}

	lastX = blob->centroid.x;
	lastY = blob->centroid.y;

	//cvAdd(frame,redline,frame);
	}

cvAdd(frame,redline,frame);

//Showing the images
cvShowImage("Blobs",frame);
cvShowImage("Video",frame2);
//Escape Sequence
char c=cvWaitKey(33);
if(c==27)
break;

}
//Cleanup
cvReleaseBlobs(blobs);
cvReleaseCapture(&capture);
cvReleaseImage(&redline);
cvDestroyAllWindows();
 
}