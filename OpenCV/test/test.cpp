#include<opencv2/core/core.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>

using namespace cv;

int main()
{
	namedWindow("lol", WINDOW_NORMAL);

	VideoCapture cap;

	Mat frame;

	cap.open(1);

	while(1)
	{
		cap>>frame;
		imshow("lol",frame);

		waitKey(1);
	}

	return 0;
}
