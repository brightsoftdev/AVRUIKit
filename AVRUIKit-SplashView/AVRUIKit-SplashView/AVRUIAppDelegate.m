//
//  AVRUIAppDelegate.m
//  AVRUIKit-SplashView
//
//  Created by Andrea Gelati on 15/01/12.
//  Copyright (c) 2012 Push Popcorn. All rights reserved.
//

#import "AVRUIAppDelegate.h"
#import "AVRUISplashViewController.h"
#import "MainViewController.h"

@implementation AVRUIAppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    _mainViewController = [[MainViewController alloc] init];

    _splashViewController = [[AVRUISplashViewController alloc] init];
    [_splashViewController setDelegate:self];

    [[self window] setRootViewController:_splashViewController];
    [[self window] makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - AVRUISplashViewControllerDelegate Methods

- (UIViewController *)segueViewControllerInSplashViewController:(AVRUISplashViewController *)controller
{
    return _mainViewController;
}

- (NSUInteger)numberOfAnimationsInSplashViewController:(AVRUISplashViewController *)controller
{
    return 1;
}

- (CAAnimation *)animationAtIndex:(NSUInteger)index inSplashViewController:(AVRUISplashViewController *)controller
{
    CABasicAnimation *animation = [CABasicAnimation animation];

    switch (index) {
        case 0:
            [animation setFromValue:(id)[UIColor blackColor].CGColor];
            [animation setToValue:(id)[UIColor clearColor].CGColor];
            break;
    }

    [animation setDuration:0.8];
    [animation setKeyPath:@"backgroundColor"];
    
    return animation;
}

- (void)splashViewControllerDidStartAnimations:(AVRUISplashViewController *)controller
{
    NSLog(@"splashViewControllerDidStartAnimations:");
}

- (void)splashViewControllerDidCompleteAnimations:(AVRUISplashViewController *)controller
{
    NSLog(@"splashViewControllerDidCompleteAnimations:");
}

- (void)splashViewController:(AVRUISplashViewController *)controller didStartAnimation:(CAAnimation *)animation atIndex:(NSUInteger)index
{
    NSLog(@"splashViewController:didStartAnimation:");
}

- (void)splashViewController:(AVRUISplashViewController *)controller didCompleteAnimation:(CAAnimation *)animation atIndex:(NSUInteger)index
{
    NSLog(@"splashViewController:didCompleteAnimation:");
}

@end
