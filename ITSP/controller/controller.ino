// Input serial data as <four digits of alt><five digits of az> (alt*100,az*100)

#define select1 13		//	0	0	1	1
#define select2 12	//	0	1	0	1
			//	Gesture	Joystick	Android	Laptop
		
#define joystickAlt 0
#define joystickAz 1

#define senUp 4
#define senDown 2

#define altOutput1 3
#define altOutput2 5
#define azOutput1 6
#define azOutput2 9

float sensitivity=0.5;

char altIn[2];
char azIn[3];
float alt;
float az;
float currentAlt;
float currentAz;

int altRead;
int azRead;

void setup()
{
	pinMode(select1,INPUT);
	pinMode(select2,INPUT);
	digitalWrite(select1,LOW);
	digitalWrite(select2,LOW);
	Serial.begin(9600);
	pinMode(4,INPUT);
	pinMode(2,INPUT);
	digitalWrite(4,HIGH);
	digitalWrite(2,HIGH);
}

void loop()
{
	if(digitalRead(select1)==1)
	{
		if(Serial.available())
		{
			alt=0;
			az=0;			
			Serial.readBytes(altIn,4);
			Serial.readBytes(azIn,5);
			for(int i=0;i<4;i++)
			{
				alt=alt+pow(10,3-i)*(altIn[i]-48);
			}
			alt=alt/100;
			for(int i=0;i<5;i++)
			{
				az=az+pow(10,4-i)*(altIn[i]-48);
			}
			az=az/100;
		}
		delay(100);
	}
	if(digitalRead(select1)==0&&digitalRead(select2)==1)
	{
		if(digitalRead(4)==HIGH)
		{
			if(sen>0.1)
			{
				sen=sen-0.1;
			}
			delay(500);
		}
		if(digitalRead(2)==HIGH)
		{
			if(sen<0.9)
			{
				sen=sen+0.1;
			}
			delay(500);
		}
	}
	if(digitalRead(select1)==0&&digitalRead(select2)==0)
	{
		// Off State (Software)
	}
}
