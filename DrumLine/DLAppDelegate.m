//
//  DLAppDelegate.m
//  DrumLine
//
//  Created by Danny Holmes on 10/25/12.
//  Copyright (c) 2014 Danny Holmes. All rights reserved.
//

#import "DLAppDelegate.h"
#import "DLViewController.h"

@implementation DLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _audioController = [[PdAudioController alloc] init];
    if ([self.audioController configureAmbientWithSampleRate:44100 numberChannels:2 mixingEnabled:YES] != PdAudioOK ) {
        NSLog(@"failed to initialize audio components");
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.audioController.active = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    self.audioController.active = NO;
}

@end