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

CvScalar Rojomin = cvScalar(170,160,60);
CvScalar Rojomax = cvScalar(180,256,256);
CvScalar Amarillomax = cvScalar(38,256,256);
CvScalar Amarillomin = cvScalar(22,0,0);
CvScalar azulmin = cvScalar(75,50,60);
CvScalar azulmax = cvScalar(130,256,256);
CvScalar verdemin = cvScalar(38,50,60);
CvScalar verdemax = cvScalar(75,256,256);
CvScalar blancomin = cvScalar(0,0,200);
CvScalar blancomax = cvScalar(180,10,256);
CvScalar naranjomin = cvScalar(10,122,200);
CvScalar naranjomax = cvScalar(22,256,256);

IplImage* imgTracking;

CvBlob blobAnterior;

int lastX = -1;
int lastY = -1;

int main(){
		
	CvCapture* capture =0;       
	  
	 capture = cvCaptureFromAVI("pelotitas.mp4"); //Camina_pelado.dvd

      if(!capture){
            printf("Capture failure\n");
            return -1;
      }
      
      IplImage* frame=0;
	  frame = cvQueryFrame(capture);           
      if(!frame) return -1;

      cvNamedWindow("Video");      
      cvNamedWindow("filtro");
	  cvNamedWindow("Seguimiento");

	  
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
      
   IplImage* imgThresh = filterByColorHSV(frame,naranjomin,naranjomax);
   cvShowImage("filtro", imgThresh);
   blobsDetectados detblobs = detectarBlobs(imgThresh);
   IplImage* imgblob = detblobs.imgBlobs;

   //create a blank image and assigned to 'imgTracking' which has the same size of original video
   imgTracking=cvCreateImage(cvGetSize(imgThresh),IPL_DEPTH_8U, 3);
   cvZero(imgTracking); //covert the image, 'imgTracking' to black

   //inicializar blob anterior
   blobAnterior.centroid.x = lastX;
   blobAnterior.centroid.y = lastY;

   //iterate through each frames of the video      
      while(true){

           frame = cvQueryFrame(capture);           
           if(!frame) break;
           frame=cvCloneImage(frame); 
            
           IplImage* imgThresh = filterByColorHSV(frame,naranjomin,naranjomax);
		   //blobsDetectados detblobs = detectarBlobs(imgThresh);
           //IplImage* imgblob = detblobs.imgBlobs;
		   imgtrack seguir = seguirBlob(frame,imgThresh,blobAnterior,imgTracking);
		   imgblob = seguir.BlobsTrack;
		   imgTracking = seguir.tracking;
		   blobAnterior = seguir.BlobAnterior;
           
		   oVideoWriter.write(imgThresh); //writer the frame after the filter into the fil
		   oVideoWriter2.write(imgblob); //writer the frame after the filter into the fil
			 
		   cvShowImage("Seguimiento", imgblob);
		   cvShowImage("filtro", imgThresh);
		   cvShowImage("Video", frame);
           
           //Clean up used images
           cvReleaseImage(&imgThresh);            
           cvReleaseImage(&frame);
		   cvReleaseImage(&imgblob); //Si dejo esto me da un error de acceso a memoria que no pude resolver

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