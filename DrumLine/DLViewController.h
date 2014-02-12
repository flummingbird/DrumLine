//
//  DLViewController.h
//  DrumLine
//
//  Created by Danny Holmes on 10/25/12.
//  Copyright (c) 2014 Danny Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdDispatcher.h"
#include <CoreMotion/CoreMotion.h>
#include <AVFoundation/AVFoundation.h>
#include <QuartzCore/QuartzCore.h>

@interface DLViewController : UIViewController {
    PdDispatcher *dispatcher;
    void *patch;
    
    CMMotionManager *_motionManager;
    CMAttitude *referenceAttitude;
    
    NSTimer *accelUpdate;
    NSTimer *torchTimer;
}













@end