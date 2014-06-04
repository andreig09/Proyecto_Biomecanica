#include <string>
#include"cvblob.h"

using namespace cv;
using namespace cvb;

std::string itoa(int n);

double Distance2(double dX0, double dY0, double dX1, double dY1);

void numerar(IplImage *img, CvBlobs blobs );

//double getMaxThresh(const char * txtName);
double getMaxThresh(int l, double *thr);

void startXML();
void XMLAddBlobs(CvBlobs blobs, FILE *file);
void XMLAddFrame(int frameNumber, CvBlobs blobs);
void endXML();

void findCircles(IplImage* img);