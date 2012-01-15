//
//  AVRUIAppDelegate.h
//  AVRUIKit-SplashView
//
//  Created by Andrea Gelati on 15/01/12.
//  Copyright (c) 2012 Push Popcorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVRUIKit.h"

@class MainViewController;

@interface AVRUIAppDelegate : UIResponder <UIApplicationDelegate, AVRUISplashViewControllerDelegate>
{
    AVRUISplashViewController *_splashViewController;
    MainViewController *_mainViewController;
}

@property (strong, nonatomic) UIWindow *window;

@end
