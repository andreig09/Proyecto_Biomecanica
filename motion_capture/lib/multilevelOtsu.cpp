#include<cv.h>
#include<highgui.h>
#include <stdio.h>

using namespace std;
using namespace cv;

void histogram(IplImage *image){
//compute histogram first
Mat imageh; //image edited to grayscale for histogram purpose

//imageh=image; //to delete and uncomment below;
cvCvtColor(image,&imageh,CV_BGR2GRAY);

int histSize[1] = {256}; // number of bins
float hranges[2] = {0.0, 256.0}; // min andax pixel value
const float* ranges[1] = {hranges};
int channels[1] = {0}; // only 1 channel used
//Mat imagehmat = imageh;
MatND hist;
// Compute histogram
//calcHist(&imagehmat, 1, channels, Mat(), hist, 1, histSize, ranges);
calcHist(&imageh, 1, channels, Mat(), hist, 1, histSize, ranges);

// Draw the histograms
  int hist_w = 512; int hist_h = 400;
  int bin_w = cvRound( (double) hist_w/histSize[1] );

  Mat histImage(hist_h, hist_w, CV_8UC1, cvScalar( 0,0,0) );
  
  /// Normalize the result to [ 0, histImage.rows ]
  //cvNormalize(&hist, &hist, 0, 255, NORM_MINMAX, CV_8UC1);
  // Draw for each channel
  //for( int i = 1; i < histSize[1]; i++ )
  //{
	//  cvLine(&histImage, cvPoint( bin_w*(i-1), hist_h - cvRound(hist.at<float>(i-1)) ) ,
    //                   cvPoint( bin_w*(i), hist_h - cvRound(hist.at<float>(i)) ),
    //                   cvScalar( 255, 0, 0), 2, 8, 0  );
  //}

cvNamedWindow("Histograma");
//cvShowImage("Histograma",&histImage);
imshow("Histograma",histImage);

cvReleaseImage(&image);
//cvReleaseImage(&imageh);

}