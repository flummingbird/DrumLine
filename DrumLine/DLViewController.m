//
//  DLViewController.m
//  DrumLine
//
//  Created by Danny Holmes on 10/25/12.
//  Copyright (c) 2014 Danny Holmes. All rights reserved.
//

#import "DLViewController.h"

@interface DLViewController ()

@property (nonatomic, strong) CMDeviceMotion *deviceMotion;
@property (nonatomic, strong) CMAttitude *currentAttitude;
@property (nonatomic, retain) CMMotionManager *motionManager;
@property (nonatomic, retain) AVCaptureDevice *device;

@property (nonatomic) BOOL aboveZero;
@property (nonatomic) BOOL aboveZeroY;

- (IBAction)panView:(UIPanGestureRecognizer *)sender;
- (IBAction)doubleTapView:(UITapGestureRecognizer *)sender;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation DLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    
    patch = [PdBase openFile:@"Drumline1_0.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"failed to load patch!");
    }
    
    NSOperationQueue *accelerometerQueue = [NSOperationQueue mainQueue];
    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionManager setAccelerometerUpdateInterval:(1.0 / 20)];
    [self.motionManager startAccelerometerUpdatesToQueue:accelerometerQueue withHandler:^(CMAccelerometerData *data, NSError *error) {
        [self updateWithFilteredAcceleration:data.acceleration];
    }];
    
    _aboveZero = 1;
    _aboveZeroY = 1;
}

- (void)updateWithFilteredAcceleration:(CMAcceleration)acceleration {
    
    //http://justinvoss.com/2011/11/07/smoothing-data-with-low-pass-filters/

    
    static CGFloat x0 = 0;
    static CGFloat y0 = 0;
    
    const NSTimeInterval dt = (1.0 / 20);
    const double RCX = 0.1;
    //const double RCY = 0.5;
    const double alphaX = dt / (RCX + dt);
    //const double alphaY = dt / (RCY + dt);
    
    CMAcceleration smoothed;
    smoothed.x = (alphaX * acceleration.x) + (1.0 - alphaX) * x0;
    //smoothed.y = (alphaY * acceleration.y) + (1.0 - alphaY) * y0;
    
    x0 = smoothed.x;
    //y0 = smoothed.y;
    
    NSLog(@"x %f",x0);
    
    
    //float y = y0 * 40.0;
    
    //NSLog(@"y %f",y);
    
    [self detectZeroCrossingX:x0];
    //[PdBase sendFloat:y toReceiver:@"1.transpose"];
    //[self detectZeroCrossingY:y0];
}

- (void)detectZeroCrossingX:(float)accel {
    if (accel > .5) {
        if (_aboveZero == 0) {
            _aboveZero = 1;
            [PdBase sendBangToReceiver:@"1.bang"];
            [self torchOnOff:1];
            [self torchOnOff:0];
            [self animateBackground];
        }
    }
    
    if (accel < .5) {
        if (_aboveZero == 1) {
            _aboveZero = 0;
            [PdBase sendBangToReceiver:@"1.bang"];
            [self torchOnOff:1];
            [self torchOnOff:0];
            [self animateBackground];
        }
    }
}

//- (void)detectZeroCrossingY:(float)accel {
//    if (accel > -.5) {
//        if (_aboveZeroY == 0) {
//            _aboveZeroY = 1;
//            [PdBase sendBangToReceiver:@"1.bang"];
//            [self torchOnOff:1];
//            [self torchOnOff:0];
//            [self animateBackground];
//        }
//    }
//    
//    if (accel < -.5) {
//        if (_aboveZeroY == 1) {
//            _aboveZeroY = 0;
//            [PdBase sendBangToReceiver:@"1.bang"];
//            [self torchOnOff:1];
//            [self torchOnOff:0];
//            [self animateBackground];
//        }
//    }
//}


- (void)torchOnOff: (BOOL) onOff
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: onOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

-(void)animateBackground {
    
    NSLog(@"animate");
    
    UIColor *lastColor = _backgroundView.backgroundColor;
    
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    UIColor *randomColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1];
    
    //_backgroundView.backgroundColor = lastColor;
    [UIView animateWithDuration:1.0/15.0 animations:^{
        _backgroundView.backgroundColor = randomColor;
    }];
    
    lastColor = randomColor;
    
}



- (IBAction)panView:(UIPanGestureRecognizer *)sender {
    float window = [sender locationInView:sender.view].y;
    
    NSLog(@"%f window",window);
    
    [PdBase sendFloat:window toReceiver:@"1.window"];
}

- (IBAction)doubleTapView:(UITapGestureRecognizer *)sender {
    [PdBase sendFloat:10 toReceiver:@"1.window"];
    NSLog(@"10.0 window");
}
@end