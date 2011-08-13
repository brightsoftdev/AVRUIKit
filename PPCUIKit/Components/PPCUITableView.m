//
//  PPCUITableView.m
//  PPCUIKit
//
//  Created by Andrea Gelati on 12/27/10.
//  Copyright (c) 2011 Push Popcorn ( http://pushpopcorn.com ). All rights reserved.
//

#import "PPCUITableView.h"

@implementation PPCUITableView

@synthesize shadowMask, scrollDirection, state;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
	if (self != nil) {
        [self setUserInteractionEnabled:YES];
        
        leftGradientLayer = [[CAGradientLayer layer] retain];
		[leftGradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
		[leftGradientLayer setEndPoint:CGPointMake(1.0f, 0.0f)];
        
		topGradientLayer = [[CAGradientLayer layer] retain];
		[topGradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
		[topGradientLayer setEndPoint:CGPointMake(0.0f, 1.0f)];

		rightGradientLayer = [[CAGradientLayer layer] retain];
		[rightGradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
		[rightGradientLayer setEndPoint:CGPointMake(1.0f, 0.0f)];

		bottomGradientLayer = [[CAGradientLayer layer] retain];
		[bottomGradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
		[bottomGradientLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
    }
	return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // scroll direction (up/down).
    if (previewContentOffset.y > [self contentOffset].y) {
        if (scrollDirection != PPCUITableViewScrollDirectionDown) {
            scrollDirection = PPCUITableViewScrollDirectionDown;
            if ([[self delegate] respondsToSelector:@selector(tableView:scrollDidChangeDirection:)]) {
                [(id)[self delegate] tableView:self scrollDidChangeDirection:scrollDirection]; 
            }
        }
    } else {
        if (scrollDirection != PPCUITableViewScrollDirectionUp) {
            scrollDirection = PPCUITableViewScrollDirectionUp;
            if ([[self delegate] respondsToSelector:@selector(tableView:scrollDidChangeDirection:)]) {
                [(id)[self delegate] tableView:self scrollDidChangeDirection:scrollDirection]; 
            }
        }
    }
    
    // pull/release/activity states.
    if ([self contentOffset].y < 0) {
        switch (scrollDirection) {
            case PPCUITableViewScrollDirectionUndetermined:
                break;
            case PPCUITableViewScrollDirectionDown:
                if (state != PPCUITableViewStatePull && [[self delegate] respondsToSelector:@selector(tableView:willReleaseHeaderView:)]) {
                    state = PPCUITableViewStatePull;
                    [(id)[self delegate] tableView:self willPullHeaderView:activityView]; 
                }
                break;
            case PPCUITableViewScrollDirectionUp:
                if (![self isTracking] && fabs([self contentOffset].y) >= [activityView frame].size.height) {
                    if (state != PPCUITableViewStateActivity && [[self delegate] respondsToSelector:@selector(tableView:activityWillBeginInHeaderView:)]) {
                        state = PPCUITableViewStateActivity;
                        [(id)[self delegate] tableView:self activityWillBeginInHeaderView:activityView]; 
                        
                        [UIView animateWithDuration:0.1
                                         animations:^(void) {
                                             [self setContentInset:UIEdgeInsetsMake([activityView frame].size.height,
                                                                                    0,
                                                                                    0,
                                                                                    0)];
                                         }];
                    }
                } else {
                    if (state != PPCUITableViewStateRelease && state == PPCUITableViewStatePull && [[self delegate] respondsToSelector:@selector(tableView:willReleaseHeaderView:)]) {
                        state = PPCUITableViewStateRelease;
                        [(id)[self delegate] tableView:self willReleaseHeaderView:activityView]; 
                    }
                }
                break;
        }
    }
        
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
    
    if (activityView) {
        [activityView setFrame:CGRectMake(0,
                                          -[activityView frame].size.height,
                                          [self frame].size.width, 
                                          [activityView frame].size.height)];
    }

	if (shadowMask & PPCUITableViewShadowSideLeft) {
        [leftGradientLayer setZPosition:1.0f];
		[leftGradientLayer setFrame:CGRectMake(0,
											   [self contentOffset].y,
											   leftGradientLayerPadding,
											   [self frame].size.height)];
	}

	if (shadowMask & PPCUITableViewShadowSideTop) {
        [topGradientLayer setZPosition:1.0f];
		[topGradientLayer setFrame:CGRectMake(0,
											  [self contentOffset].y,
											  [self frame].size.width,
											  topGradientLayerPadding)];
	}

	if (shadowMask & PPCUITableViewShadowSideRight) {
        [leftGradientLayer setZPosition:1.0f];
		[rightGradientLayer setFrame:CGRectMake([self frame].size.width - rightGradientLayerPadding,
												[self contentOffset].y,
												rightGradientLayerPadding,
												[self frame].size.height)];
	}
    
	if (shadowMask & PPCUITableViewShadowSideBottom) {
        [bottomGradientLayer setZPosition:1.0f];
		[bottomGradientLayer setFrame:CGRectMake(0,
												 [self contentOffset].y + [self frame].size.height - bottomGradientLayerPadding,
												 [self frame].size.width,
                                                 bottomGradientLayerPadding)];
	}

	[CATransaction commit];

	if (shadowMask & PPCUITableViewShadowSideTop) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            if ([self contentOffset].y > 0.0f) {
                [topGradientLayer setOpacity:fabs([self contentOffset].y / PPCUITableViewDefaultShadowOffset)];
            } else {
                [topGradientLayer setOpacity:0.0f];
            }
        }];
    }

	if (shadowMask & PPCUITableViewShadowSideBottom) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
			if ([self contentSize].height - ([self frame].size.height + [self contentOffset].y) >= 0.0f) {
				[bottomGradientLayer setOpacity:([self contentSize].height - ([self frame].size.height + [self contentOffset].y)) / PPCUITableViewDefaultShadowOffset];
			} else {
				[bottomGradientLayer setOpacity:0.0f];
			}
		}];
	}

    // update the current contentOffset.
    previewContentOffset = [self contentOffset];
}

- (void)dealloc {
	[leftGradientLayer release];
	[topGradientLayer release];
	[rightGradientLayer release];
	[bottomGradientLayer release];
    [super dealloc];
}

#pragma mark -
#pragma mark Methods

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    [super setDelegate:delegate];
        
    if ([delegate respondsToSelector:@selector(activityViewInTableView:)]) {
        if (activityView) {
            [activityView removeFromSuperview];
            activityView = nil;
        }

        activityView = [(id)[self delegate] activityViewInTableView:self];
        
        if (activityView) {
            [self addSubview:activityView];
        }
    }
}

- (void)setShadowMask:(PPCUITableViewShadowSides)mask {
	if (shadowMask == mask) {
		return;
	}
	
	shadowMask = mask;

	if (shadowMask & PPCUITableViewShadowSideLeft) {
        [[self layer] addSublayer:leftGradientLayer];

		UIColor *startColor = PPCUITableViewDefaultShadowBlackColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:startColorForShadowAtSide:)]) {
			startColor = [(id)[self delegate] tableView:self startColorForShadowAtSide:PPCUITableViewShadowSideLeft];
			if (!startColor) {
				startColor = PPCUITableViewDefaultShadowBlackColor;
			}
		}

		UIColor *stopColor = PPCUITableViewDefaultShadowClearColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:stopColorForShadowAtSide:)]) {
			stopColor = [(id)[self delegate] tableView:self stopColorForShadowAtSide:PPCUITableViewShadowSideLeft];
			if (!stopColor) {
				stopColor = PPCUITableViewDefaultShadowClearColor;
			}
		}

		[leftGradientLayer setColors:[NSArray arrayWithObjects:	(id)startColor.CGColor,
																(id)stopColor.CGColor, nil]];

		if ([[self delegate] respondsToSelector:@selector(tableView:paddingForShadowAtSide:)]) {
			leftGradientLayerPadding = [(id)[self delegate] tableView:self paddingForShadowAtSide:PPCUITableViewShadowSideLeft];
		} else {
			leftGradientLayerPadding = PPCUITableViewDefaultShadowPadding;
		}
	} else {
		[leftGradientLayer removeFromSuperlayer];
	}

	if (shadowMask & PPCUITableViewShadowSideTop) {
		[[self layer] addSublayer:topGradientLayer];

		UIColor *startColor = PPCUITableViewDefaultShadowBlackColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:startColorForShadowAtSide:)]) {
			startColor = [(id)[self delegate] tableView:self startColorForShadowAtSide:PPCUITableViewShadowSideTop];
			if (!startColor) {
				startColor = PPCUITableViewDefaultShadowBlackColor;
			}
		}		
		
		UIColor *stopColor = PPCUITableViewDefaultShadowClearColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:stopColorForShadowAtSide:)]) {
			stopColor = [(id)[self delegate] tableView:self stopColorForShadowAtSide:PPCUITableViewShadowSideTop];
			if (!stopColor) {
				stopColor = PPCUITableViewDefaultShadowClearColor;
			}
		}		
		
		[topGradientLayer setColors:[NSArray arrayWithObjects:	(id)startColor.CGColor,
																(id)stopColor.CGColor, nil]];
		
		if ([[self delegate] respondsToSelector:@selector(tableView:paddingForShadowAtSide:)]) {
			topGradientLayerPadding = [(id)[self delegate] tableView:self paddingForShadowAtSide:PPCUITableViewShadowSideTop];
		} else {
			topGradientLayerPadding = PPCUITableViewDefaultShadowPadding;
		}
	} else {
		[topGradientLayer removeFromSuperlayer];
	}

	if (shadowMask & PPCUITableViewShadowSideRight) {
		[[self layer] addSublayer:rightGradientLayer];
		
		UIColor *startColor = PPCUITableViewDefaultShadowClearColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:startColorForShadowAtSide:)]) {
            startColor = [(id)[self delegate] tableView:self startColorForShadowAtSide:PPCUITableViewShadowSideRight];
			if (!startColor) {
				startColor = PPCUITableViewDefaultShadowClearColor;
			}
		}
		
		UIColor *stopColor = PPCUITableViewDefaultShadowBlackColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:stopColorForShadowAtSide:)]) {
			stopColor = [(id)[self delegate] tableView:self stopColorForShadowAtSide:PPCUITableViewShadowSideRight];
			if (!stopColor) {
				stopColor = PPCUITableViewDefaultShadowBlackColor;
			}
		}
		
		[rightGradientLayer setColors:[NSArray arrayWithObjects:(id)startColor.CGColor,
																(id)stopColor.CGColor, nil]];
        
		if ([[self delegate] respondsToSelector:@selector(tableView:paddingForShadowAtSide:)]) {
			rightGradientLayerPadding = [(id)[self delegate] tableView:self paddingForShadowAtSide:PPCUITableViewShadowSideRight];
		} else {
			rightGradientLayerPadding = PPCUITableViewDefaultShadowPadding;
		}
	} else {
		[rightGradientLayer removeFromSuperlayer];
	}

	if (shadowMask & PPCUITableViewShadowSideBottom) {
		[[self layer] addSublayer:bottomGradientLayer];
		
		UIColor *startColor = PPCUITableViewDefaultShadowClearColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:startColorForShadowAtSide:)]) {
			startColor = [(id)[self delegate] tableView:self startColorForShadowAtSide:PPCUITableViewShadowSideBottom];
			if (!startColor) {
				startColor = PPCUITableViewDefaultShadowClearColor;
			}
		}
		
		UIColor *stopColor = PPCUITableViewDefaultShadowBlackColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:stopColorForShadowAtSide:)]) {
			stopColor = [(id)[self delegate] tableView:self stopColorForShadowAtSide:PPCUITableViewShadowSideBottom];
			if (!stopColor) {
				stopColor = PPCUITableViewDefaultShadowBlackColor;
			}
		}
		
		[bottomGradientLayer setColors:[NSArray arrayWithObjects:	(id)startColor.CGColor,
																	(id)stopColor.CGColor, nil]];
		
		if ([[self delegate] respondsToSelector:@selector(tableView:paddingForShadowAtSide:)]) {
			bottomGradientLayerPadding = [(id)[self delegate] tableView:self paddingForShadowAtSide:PPCUITableViewShadowSideBottom];
		} else {
			bottomGradientLayerPadding = PPCUITableViewDefaultShadowPadding;
		}
	} else {
		[bottomGradientLayer removeFromSuperlayer];
	}
}

- (void)dismissActivityView {
    if (state != PPCUITableViewStateActivity || [self contentOffset].y > 0) {
        [self setContentInset:UIEdgeInsetsZero];
        state = PPCUITableViewStateNone;
        
        return;
    }

    [self setContentOffset:CGPointMake(0,0) 
                  animated:YES];

    NSTimeInterval transactionDurationTimeInterval;
    transactionDurationTimeInterval = (NSTimeInterval)[[CATransaction valueForKey:kCATransactionAnimationDuration] doubleValue];
    
    [self performSelector:@selector(dismissActivityViewComplete) 
               withObject:nil 
               afterDelay:transactionDurationTimeInterval
                  inModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
}

- (void)dismissActivityViewComplete {
    [self setContentInset:UIEdgeInsetsZero];
    state = PPCUITableViewStateNone;
}

@end
