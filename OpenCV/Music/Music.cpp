#include<opencv2/core/core.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>
#include<cstdlib>
#include<ctime>
#include<iostream>

int CLK_DIFF=CLOCKS_PER_SEC;

using namespace cv;
using namespace std;

int main()
{
	VideoCapture cap(0);
	VideoCapture cap1;

	Mat present;
	Mat past;
	Mat diff;
	namedWindow("present", WINDOW_NORMAL);
	namedWindow("past", WINDOW_NORMAL);
	namedWindow("diff", WINDOW_NORMAL);

	cap>>past;
	imshow("past",past);
	imwrite("past.jpg",past);
	cap.release();

	time_t t;

	t=clock();

	while(clock()-t<CLK_DIFF)
	{
	}

	cap1.open(0);
	cap1>>present;
	cap1.release();
//	while(1)
//	{
//		cap>>present;
//		diff=diff+(present-past);
//		past=present;
		past=imread("past.jpg");
		imshow("past",past);
		diff=past-present;
		imshow("present",present);
		imshow("diff",diff);
		waitKey(0.01);
		imwrite("present.jpg", present);
		imwrite("diff.jpg", diff);
//	}
	return 0;
}
