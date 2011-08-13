//
//  AppDelegate.h
//  AVRUIKit
//
//  Created by Andrea Gelati on 8/7/11.
//  Copyright (c) 2011 Andrea Gelati ( http://andreagelati.com ). All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *mainWindow;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, readonly) MainViewController *mainViewController;

@end
