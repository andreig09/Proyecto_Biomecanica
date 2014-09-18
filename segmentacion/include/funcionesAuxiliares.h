#include <string>
#include"cvblob.h"

using namespace cv;
using namespace cvb;

std::string itoa(int n);

double Distance2(double dX0, double dY0, double dX1, double dY1);

void numerar(IplImage *img, CvBlobs blobs );

//double getMaxThresh(const char * txtName);
double getMaxThresh(int l, double *thr);

void startXML(const char *video);
void XMLAddBlobs(CvBlobs blobs, FILE *file);
void XMLAddFrame(int frameNumber, CvBlobs blobs, const char *video);
void endXML(const char *video);
const char* XMLname(const char *one);
const char* substring(const char* string);
void findCircles(IplImage* img);
double FindT(int argc,char *argv[]);
double FindA(int argc,char *argv[]);
double Finda(int argc,char *argv[]);
bool Finds(int argc,char *argv[]);