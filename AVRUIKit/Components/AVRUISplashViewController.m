//
//  AVRUISplashViewController.m
//  AVRUIKit
//
//  Created by Andrea Gelati on 10/4/10.
//  Copyright (c) 2011 Andrea Gelati ( http://andreagelati.com ). All rights reserved.
//

#import "AVRUISplashViewController.h"


@implementation AVRUISplashViewController

@synthesize delegate;

// The designated initializer. Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		// Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    [[self view] setFrame:[[UIScreen mainScreen] bounds]]; // set the size to fit the mainScreen's size.
    [[self view] setBackgroundColor:[UIColor clearColor]]; 
    
    currentAnimationIndex = 0; // initialize the var to 0
    animationCount = [delegate numberOfAnimationsInSplashViewController:self];

    if(animationCount) {
        CAAnimation *currentAnimation = nil;
        currentAnimation = [delegate animationAtIndex:currentAnimationIndex 
                               inSplashViewController:self]; // start from the first animation at index 0

        if(currentAnimation) {
            [currentAnimation setDelegate:self];
            [currentAnimation setRemovedOnCompletion:YES];
            if([delegate respondsToSelector:@selector(splashViewControllerDidStartAnimations:)]) {
                [delegate splashViewControllerDidStartAnimations:self];
            }
            [[[self view] layer] addAnimation:currentAnimation // start to play the animation
                                       forKey:nil];
        }
    }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark CAAnimation Delegate

- (void)animationDidStart:(CAAnimation *)theAnimation {
    if([delegate respondsToSelector:@selector(splashViewController:didStartAnimation:atIndex:)]) {
        [delegate splashViewController:self didStartAnimation:theAnimation atIndex:currentAnimationIndex];
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if(flag) { // animation is completed
        if([delegate respondsToSelector:@selector(splashViewController:didCompleteAnimation:atIndex:)]) {
            [delegate splashViewController:self didCompleteAnimation:theAnimation atIndex:currentAnimationIndex];
        }

        currentAnimationIndex++; // hooray we can play the next animation.

        if(animationCount > currentAnimationIndex) {
            CAAnimation *nextAnimation = nil;
            nextAnimation = [delegate animationAtIndex:currentAnimationIndex 
                                inSplashViewController:self];
            
            if(nextAnimation) {
                [nextAnimation setDelegate:self];
                [nextAnimation setRemovedOnCompletion:YES];

                [[[self view] layer] addAnimation:nextAnimation // start to play the next animation
                                           forKey:nil];
            }
        } else {
            if([delegate respondsToSelector:@selector(splashViewControllerDidCompleteAnimations:)]) {
                [delegate splashViewControllerDidCompleteAnimations:self];
            }

            [[self view] removeFromSuperview];
        }
    }
}

@end
