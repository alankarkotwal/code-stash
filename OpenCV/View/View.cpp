#include <stdio.h>
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

int main( int argc, char** argv )
{
  Mat image;

  VideoCapture cap(0);
  cap>>image;

  namedWindow( "Display Image", CV_WINDOW_AUTOSIZE );
  imshow( "Display Image", image );

  std::cout<<image.cols;

  waitKey(0);

  return 0;
}
