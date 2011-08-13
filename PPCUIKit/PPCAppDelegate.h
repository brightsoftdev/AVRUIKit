//
//  PPCAppDelegate.h
//  PPCUIKit
//
//  Created by Andrea Gelati on 8/7/11.
//  Copyright (c) 2011 Push Popcorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPCViewController;

@interface PPCAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) PPCViewController *viewController;

@end
