#include<opencv2/core/core.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>

using namespace cv;

int main()
{
	VideoCapture cap(0);
	Mat frame;
	namedWindow("View", CV_WINDOW_AUTOSIZE);

	cap>>frame;

	imshow("View", frame);
	waitKey(0);

	return 0;
}
