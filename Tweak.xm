#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>

@interface SBAwayLockBar{
}
-(id)knob;
-(void)unlock;
-(void)slideBack:(BOOL)back;
-(void)knobDragged:(float)dragged;
@end



#define STOP_THRESHOLD 2
#define TOP_STOP_THRESHOLD 0.7
#define DIR_FORWARD 1
#define DIR_BACKWARD 0
#define SLEEP_TIME 0.01
#define SURFACE 5

static float CONST_ACCEL=0;
static float BOUNCE_FACTOR=0;

static double velocity=0;
static double acceleration=CONST_ACCEL;
static double totalTime=0;
static int direction=DIR_BACKWARD;
static NSTimer *myTimer=nil;
static BOOL isEnabled;
static BOOL bounceBeforeUnlock;
static BOOL unlocked;



%hook SBAwayLockBar

%new
-(void)fireOnTimer{
	//NSLog(@"ZABI:: Im HERE IN");
		

	CGRect frame=[[self knob] frame];

	if (direction==DIR_FORWARD)
		frame.origin.x+=velocity;
	else
		frame.origin.x-=velocity;



	if (direction==DIR_FORWARD && velocity<=TOP_STOP_THRESHOLD){
		direction=DIR_BACKWARD;
		totalTime=0;
		velocity=0;
		acceleration= CONST_ACCEL;
	}
	if (direction==DIR_BACKWARD && frame.origin.x<SURFACE){
		direction=DIR_FORWARD;
		totalTime=0;
		velocity=BOUNCE_FACTOR*velocity;
		acceleration= -CONST_ACCEL;
		if (velocity <= STOP_THRESHOLD){
			velocity=0;
			acceleration=0;
			frame.origin.x=2;
		}
	}

	CGRect newFrame=CGRectMake((frame.origin.x<=0)?2:frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
	[[self knob] setFrame:newFrame];
	
	totalTime+=SLEEP_TIME;
	velocity=velocity+acceleration*totalTime; //Equation is Vf=Vi + gt
	if(acceleration==0){
		[myTimer invalidate];
		//NSLog(@"I AM INVALIDATED");
		[myTimer release];
		myTimer=nil;
		[self knobDragged:0.0];// Just to get the slide text back
		if(bounceBeforeUnlock && unlocked){
			bounceBeforeUnlock=NO;
			[self unlock];
		}
	}

	
	//NSLog(@"VELOCITY: %f, DIRECTION: %d,totalTime: %f",velocity,direction,totalTime);
		
}
-(void)slideBack:(BOOL)back { 
	%log;
	//NSLog(@"ZABI: Im HERE");
	if(isEnabled){
		if(back==YES){
			velocity=0;
			acceleration=CONST_ACCEL;
			totalTime=0;
			direction=DIR_BACKWARD;
			
			myTimer=[NSTimer scheduledTimerWithTimeInterval:SLEEP_TIME target:self selector:@selector(fireOnTimer) userInfo:nil repeats:YES];
			[myTimer retain];
			
		}
		else{
			%orig;
		}
	}
	else
		%orig;
	//NSLog(@"ZABI: Im HERE END");

	
}

-(void)downInKnob{

	if(CONST_ACCEL==0 || BOUNCE_FACTOR ==0){
		NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.zabirauf.bouncelock.plist"];

		isEnabled=![[dict objectForKey:@"Enabled"] boolValue];
		CONST_ACCEL=[[dict objectForKey:@"AccelerationValue"] floatValue];
		BOUNCE_FACTOR=[[dict objectForKey:@"bounce_factor"] floatValue];
		bounceBeforeUnlock=[[dict objectForKey:@"BounceBefore"] boolValue];

		//NSLog(@"ZABI: ACCEL :%f , FACTOR:%f",CONST_ACCEL,BOUNCE_FACTOR);
	}

	if(isEnabled){
		velocity=0;
		acceleration=0;
		totalTime=0;
		direction=DIR_BACKWARD;
		unlocked=NO;
		if(myTimer!=nil){
			if([myTimer isValid]==YES)
				[myTimer invalidate];
			[myTimer release];
			myTimer=nil;
		}
	}

	%orig;
}

-(void)unlock{
	//I know its really bad coding, could optimize it but not in mood :)
	if(isEnabled){
		if(bounceBeforeUnlock){
			unlocked=YES;
			[self slideBack:YES];
		}
		else{
			CONST_ACCEL=0;
			BOUNCE_FACTOR=0;
			%orig;
		}
	}else{
		CONST_ACCEL=0;
		BOUNCE_FACTOR=0;
		%orig;
	}
}


%end
