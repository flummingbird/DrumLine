//
//  DLViewController.h
//  DrumLine
//
//  Created by Danny Holmes on 2-12-14.

//  Copyright (c) 2014 Danny Holmes.

//This program is free software; you can redistribute it and/or
//modify it under the terms of the GNU General Public License
//as published by the Free Software Foundation; either version 2
//of the License, or (at your option) any later version.
//
//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with this program. If not, see <http://www.gnu.org/licenses/>.


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