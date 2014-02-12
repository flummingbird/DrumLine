//
//  DLAppDelegate.h
//  DrumLine
//
//  Created by Danny Holmes on 10/25/12.
//  Copyright (c) 2014 Danny Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudioController.h"

@class DLViewController;

@interface DLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DLViewController *viewController;

@property (strong, nonatomic, readonly) PdAudioController *audioController;

@end
