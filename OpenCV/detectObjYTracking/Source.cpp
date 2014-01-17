#include <cv.h>
#include <highgui.h>
//#include <opencv2/core/core.hpp>
//#include <opencv2/highgui/highgui.hpp>
//#include <iostream>


using namespace cv;
using namespace std;

IplImage* imgTracking;

int lastX = -1;
int lastY = -1;

//This function threshold the HSV image and create a binary image
IplImage* GetThresholdedImage(IplImage* imgHSV){        
       IplImage* imgThresh=cvCreateImage(cvGetSize(imgHSV),IPL_DEPTH_8U, 1);
       cvInRangeS(imgHSV, cvScalar(22,0,0), cvScalar(38,256,256), imgThresh); 
       return imgThresh;
} 

//ROJO  -  cvScalar(170,160,60), cvScalar(180,256,256)
//AZUL  -  cvScalar(75,50,60), cvScalar(130,256,256)
//Verde - cvScalar(38,50,60), cvScalar(75,256,256)

void trackObject(IplImage* imgThresh){
    // Calculate the moments of 'imgThresh'
    CvMoments *moments = (CvMoments*)malloc(sizeof(CvMoments));
    cvMoments(imgThresh, moments, 1);
    double moment10 = cvGetSpatialMoment(moments, 1, 0);
    double moment01 = cvGetSpatialMoment(moments, 0, 1);
    double area = cvGetCentralMoment(moments, 0, 0);

     // if the area<1000, I consider that the there are no object in the image and it's because of the noise, the area is not zero 
    if(area>1000){
        // calculate the position of the ball
        int posX = moment10/area;
        int posY = moment01/area;        
        
       if(lastX>=0 && lastY>=0 && posX>=0 && posY>=0)
        {
            // Draw a yellow line from the previous point to the current point
            cvLine(imgTracking, cvPoint(posX, posY), cvPoint(lastX, lastY), cvScalar(0,0,255), 4);
        }

         lastX = posX;
        lastY = posY;
    }

     free(moments); 
}
 
int main(){
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
      cvNamedWindow("Ball");

	  
   double dWidth = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_WIDTH); //get the width of frames of the video
   double dHeight = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_HEIGHT); //get the height of frames of the video
   int fps = cvGetCaptureProperty(capture, CV_CAP_PROP_FPS);

   cout << "Frame Size = " << dWidth << "x" << dHeight << endl;
   cout << "FPS = " << fps << endl;

   Size frameSize(static_cast<int>(dWidth), static_cast<int>(dHeight));

   VideoWriter oVideoWriter ("salida.avi", CV_FOURCC('M','P','4','2'), fps, frameSize, false); //initialize the VideoWriter object 
   //CV_FOURCC('P','I','M','1')
   if ( !oVideoWriter.isOpened() ) //if not initialize the VideoWriter successfully, exit the program
   {
        cout << "ERROR: Failed to write the video" << endl;
        return -1;
   }

    //create a blank image and assigned to 'imgTracking' which has the same size of original video
     imgTracking=cvCreateImage(frameSize,IPL_DEPTH_8U, 3);
	 cvZero(imgTracking); //covert the image, 'imgTracking' to black


      //iterate through each frames of the video      
      while(true){

           frame = cvQueryFrame(capture);           
            if(!frame) break;
            frame=cvCloneImage(frame); 
            
            cvSmooth(frame, frame, CV_GAUSSIAN,3,3); //smooth the original image using Gaussian kernel

            IplImage* imgHSV = cvCreateImage(cvGetSize(frame), IPL_DEPTH_8U, 3); 
            cvCvtColor(frame, imgHSV, CV_BGR2HSV); //Change the color format from BGR to HSV
            IplImage* imgThresh = GetThresholdedImage(imgHSV);
          
            cvSmooth(imgThresh, imgThresh, CV_GAUSSIAN,3,3); //smooth the binary image using Gaussian kernel
            
             //track the possition of the ball
             trackObject(imgThresh);

             // Add the tracking image and the frame
             cvAdd(frame, imgTracking, frame);
			 
			 oVideoWriter.write(imgThresh); //writer the frame after the filter into the fil
			
			 cvShowImage("Ball", imgThresh);           
             cvShowImage("Video", frame);
           
             //Clean up used images
             cvReleaseImage(&imgHSV);
             cvReleaseImage(&imgThresh);            
             cvReleaseImage(&frame);

              //Wait 10mS
              int c = cvWaitKey(10);
             //If 'ESC' is pressed, break the loop
             if((char)c==27 ) break;       
      }

      cvDestroyAllWindows() ;
      cvReleaseCapture(&capture);
	  cvReleaseImage(&imgTracking);

      return 0;
}