//OpenCV Headers
#include<cv.h>
#include<highgui.h>
//Input-Output
#include<stdio.h>
//Blob Library Headers
#include"cvblob.h"
//#include <cvblob.h>
#include<Windows.h>

#include"ColorFilter.h"
#include"detectarBlobs.h"

//NameSpaces
using namespace cv;
using namespace cvb;
using namespace std;
//using namespace cvb;

//Este main te saca 3 videos: el original, el filtrado y el blob detectado (todo para 1 blob)
int main1Blob3Vid(){
		
	CvCapture* capture =0;       
	  
	 capture = cvCaptureFromAVI("limon2.mp4");

      if(!capture){
            printf("Capture failure\n");
            return -1;
      }
      
      IplImage* frame=0;
	  frame = cvQueryFrame(capture);           
      if(!frame) return -1;

      cvNamedWindow("Video");      
      cvNamedWindow("filtro");

	  
   double dWidth = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_WIDTH); //get the width of frames of the video
   double dHeight = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_HEIGHT); //get the height of frames of the video
   int fps = cvGetCaptureProperty(capture, CV_CAP_PROP_FPS);

   cout << "Frame Size = " << dWidth << "x" << dHeight << endl;
   cout << "FPS = " << fps << endl;

   Size frameSize(static_cast<int>(dWidth), static_cast<int>(dHeight));

   VideoWriter oVideoWriter ("filtro.avi", CV_FOURCC('M','P','4','2'), fps, frameSize, false); //initialize the VideoWriter object 
   //CV_FOURCC('P','I','M','1')
   if ( !oVideoWriter.isOpened() ) //if not initialize the VideoWriter successfully, exit the program
   {
        cout << "ERROR: Failed to write the video" << endl;
        return -1;
   }

   VideoWriter oVideoWriter2 ("Blobs.avi", CV_FOURCC('M','P','4','2'), fps, frameSize, true); //initialize the VideoWriter object
   
   if ( !oVideoWriter2.isOpened() ) //if not initialize the VideoWriter successfully, exit the program
   {
        cout << "ERROR: Failed to write the video" << endl;
        return -1;
   }
    
   CvScalar Amarillomax = cvScalar(38,256,256);
   CvScalar Amarillomin = cvScalar(22,0,0);

   IplImage* imgThresh = filterByColorHSV(frame,Amarillomin,Amarillomax);
   blobsDetectados detblobs = detectarBlobs(imgThresh);
   IplImage* imgblob = detblobs.imgBlobs;

   //iterate through each frames of the video      
      while(true){

           frame = cvQueryFrame(capture);           
            if(!frame) break;
            frame=cvCloneImage(frame); 
            
           IplImage* imgThresh = filterByColorHSV(frame,Amarillomin,Amarillomax);
		   blobsDetectados detblobs = detectarBlobs(imgThresh);
           IplImage* imgblob = detblobs.imgBlobs;
          
           	 oVideoWriter.write(imgThresh); //writer the frame after the filter into the fil
			 oVideoWriter2.write(imgblob); //writer the frame after the filter into the fil
			 
			 //cvShowImage("puntos detectados", imgThresh);
			 cvShowImage("filtro", imgThresh);
			 cvShowImage("Video", frame);
           
             //Clean up used images
             cvReleaseImage(&imgThresh);            
             cvReleaseImage(&frame);
			 cvReleaseImage(&imgblob);

              //Wait 10mS
              int c = cvWaitKey(10);
             //If 'ESC' is pressed, break the loop
             if((char)c==27 ) break;       
      }

	  waitKey(0); //wait infinite time for a keypress

	  destroyAllWindows;
	  cvReleaseCapture(&capture);
      return 0;

}