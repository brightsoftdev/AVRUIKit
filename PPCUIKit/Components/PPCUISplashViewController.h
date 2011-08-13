//
//  PPCUISplashViewController.h
//  PPCUIKit
//
//  Created by Andrea Gelati on 10/4/10.
//  Copyright (c) 2011 Push Popcorn ( http://pushpopcorn.com ). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "UIView+ScreenCapture.h"

@protocol PPCUISplashViewControllerDelegate;

@interface PPCUISplashViewController : UIViewController {
    id<PPCUISplashViewControllerDelegate> delegate;
    
    NSUInteger currentAnimationIndex; // return the index of the current (playing) animation.
    NSUInteger animationCount; // return the animations count provided by the delegate.
}

@property (nonatomic, assign) id<PPCUISplashViewControllerDelegate> delegate;

@end

@protocol PPCUISplashViewControllerDelegate <NSObject>
- (NSUInteger)numberOfAnimationsInSplashViewController:(PPCUISplashViewController *)controller;
- (CAAnimation *)animationAtIndex:(NSUInteger)index inSplashViewController:(PPCUISplashViewController *)controller;
@optional
- (void)splashViewControllerDidStartAnimations:(PPCUISplashViewController *)controller;
- (void)splashViewControllerDidCompleteAnimations:(PPCUISplashViewController *)controller;
- (void)splashViewController:(PPCUISplashViewController *)controller didStartAnimation:(CAAnimation *)animation atIndex:(NSUInteger)index;
- (void)splashViewController:(PPCUISplashViewController *)controller didCompleteAnimation:(CAAnimation *)animation atIndex:(NSUInteger)index;
@end
    