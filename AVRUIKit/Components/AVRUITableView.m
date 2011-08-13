//
//  AVRUITableView.m
//  AVRUIKit
//
//  Created by Andrea Gelati on 12/27/10.
//  Copyright (c) 2011 Andrea Gelati ( http://andreagelati.com ). All rights reserved.
//

#import "AVRUITableView.h"

@implementation AVRUITableView

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
        if (scrollDirection != AVRUITableViewScrollDirectionDown) {
            scrollDirection = AVRUITableViewScrollDirectionDown;
            if ([[self delegate] respondsToSelector:@selector(tableView:scrollDidChangeDirection:)]) {
                [(id)[self delegate] tableView:self scrollDidChangeDirection:scrollDirection]; 
            }
        }
    } else {
        if (scrollDirection != AVRUITableViewScrollDirectionUp) {
            scrollDirection = AVRUITableViewScrollDirectionUp;
            if ([[self delegate] respondsToSelector:@selector(tableView:scrollDidChangeDirection:)]) {
                [(id)[self delegate] tableView:self scrollDidChangeDirection:scrollDirection]; 
            }
        }
    }
    
    // pull/release/activity states.
    if ([self contentOffset].y < 0) {
        switch (scrollDirection) {
            case AVRUITableViewScrollDirectionUndetermined:
                break;
            case AVRUITableViewScrollDirectionDown:
                if (state != AVRUITableViewStatePull && [[self delegate] respondsToSelector:@selector(tableView:willReleaseHeaderView:)]) {
                    state = AVRUITableViewStatePull;
                    [(id)[self delegate] tableView:self willPullHeaderView:activityView]; 
                }
                break;
            case AVRUITableViewScrollDirectionUp:
                if (![self isTracking] && fabs([self contentOffset].y) >= [activityView frame].size.height) {
                    if (state != AVRUITableViewStateActivity && [[self delegate] respondsToSelector:@selector(tableView:activityWillBeginInHeaderView:)]) {
                        state = AVRUITableViewStateActivity;
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
                    if (state != AVRUITableViewStateRelease && state == AVRUITableViewStatePull && [[self delegate] respondsToSelector:@selector(tableView:willReleaseHeaderView:)]) {
                        state = AVRUITableViewStateRelease;
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

	if (shadowMask & AVRUITableViewShadowSideLeft) {
        [leftGradientLayer setZPosition:1.0f];
		[leftGradientLayer setFrame:CGRectMake(0,
											   [self contentOffset].y,
											   leftGradientLayerPadding,
											   [self frame].size.height)];
	}

	if (shadowMask & AVRUITableViewShadowSideTop) {
        [topGradientLayer setZPosition:1.0f];
		[topGradientLayer setFrame:CGRectMake(0,
											  [self contentOffset].y,
											  [self frame].size.width,
											  topGradientLayerPadding)];
	}

	if (shadowMask & AVRUITableViewShadowSideRight) {
        [leftGradientLayer setZPosition:1.0f];
		[rightGradientLayer setFrame:CGRectMake([self frame].size.width - rightGradientLayerPadding,
												[self contentOffset].y,
												rightGradientLayerPadding,
												[self frame].size.height)];
	}
    
	if (shadowMask & AVRUITableViewShadowSideBottom) {
        [bottomGradientLayer setZPosition:1.0f];
		[bottomGradientLayer setFrame:CGRectMake(0,
												 [self contentOffset].y + [self frame].size.height - bottomGradientLayerPadding,
												 [self frame].size.width,
                                                 bottomGradientLayerPadding)];
	}

	[CATransaction commit];

	if (shadowMask & AVRUITableViewShadowSideTop) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            if ([self contentOffset].y > 0.0f) {
                [topGradientLayer setOpacity:fabs([self contentOffset].y / AVRUITableViewDefaultShadowOffset)];
            } else {
                [topGradientLayer setOpacity:0.0f];
            }
        }];
    }

	if (shadowMask & AVRUITableViewShadowSideBottom) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
			if ([self contentSize].height - ([self frame].size.height + [self contentOffset].y) >= 0.0f) {
				[bottomGradientLayer setOpacity:([self contentSize].height - ([self frame].size.height + [self contentOffset].y)) / AVRUITableViewDefaultShadowOffset];
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

- (void)setShadowMask:(AVRUITableViewShadowSides)mask {
	if (shadowMask == mask) {
		return;
	}
	
	shadowMask = mask;

	if (shadowMask & AVRUITableViewShadowSideLeft) {
        [[self layer] addSublayer:leftGradientLayer];

		UIColor *startColor = AVRUITableViewDefaultShadowBlackColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:startColorForShadowAtSide:)]) {
			startColor = [(id)[self delegate] tableView:self startColorForShadowAtSide:AVRUITableViewShadowSideLeft];
			if (!startColor) {
				startColor = AVRUITableViewDefaultShadowBlackColor;
			}
		}

		UIColor *stopColor = AVRUITableViewDefaultShadowClearColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:stopColorForShadowAtSide:)]) {
			stopColor = [(id)[self delegate] tableView:self stopColorForShadowAtSide:AVRUITableViewShadowSideLeft];
			if (!stopColor) {
				stopColor = AVRUITableViewDefaultShadowClearColor;
			}
		}

		[leftGradientLayer setColors:[NSArray arrayWithObjects:	(id)startColor.CGColor,
																(id)stopColor.CGColor, nil]];

		if ([[self delegate] respondsToSelector:@selector(tableView:paddingForShadowAtSide:)]) {
			leftGradientLayerPadding = [(id)[self delegate] tableView:self paddingForShadowAtSide:AVRUITableViewShadowSideLeft];
		} else {
			leftGradientLayerPadding = AVRUITableViewDefaultShadowPadding;
		}
	} else {
		[leftGradientLayer removeFromSuperlayer];
	}

	if (shadowMask & AVRUITableViewShadowSideTop) {
		[[self layer] addSublayer:topGradientLayer];

		UIColor *startColor = AVRUITableViewDefaultShadowBlackColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:startColorForShadowAtSide:)]) {
			startColor = [(id)[self delegate] tableView:self startColorForShadowAtSide:AVRUITableViewShadowSideTop];
			if (!startColor) {
				startColor = AVRUITableViewDefaultShadowBlackColor;
			}
		}		
		
		UIColor *stopColor = AVRUITableViewDefaultShadowClearColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:stopColorForShadowAtSide:)]) {
			stopColor = [(id)[self delegate] tableView:self stopColorForShadowAtSide:AVRUITableViewShadowSideTop];
			if (!stopColor) {
				stopColor = AVRUITableViewDefaultShadowClearColor;
			}
		}		
		
		[topGradientLayer setColors:[NSArray arrayWithObjects:	(id)startColor.CGColor,
																(id)stopColor.CGColor, nil]];
		
		if ([[self delegate] respondsToSelector:@selector(tableView:paddingForShadowAtSide:)]) {
			topGradientLayerPadding = [(id)[self delegate] tableView:self paddingForShadowAtSide:AVRUITableViewShadowSideTop];
		} else {
			topGradientLayerPadding = AVRUITableViewDefaultShadowPadding;
		}
	} else {
		[topGradientLayer removeFromSuperlayer];
	}

	if (shadowMask & AVRUITableViewShadowSideRight) {
		[[self layer] addSublayer:rightGradientLayer];
		
		UIColor *startColor = AVRUITableViewDefaultShadowClearColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:startColorForShadowAtSide:)]) {
            startColor = [(id)[self delegate] tableView:self startColorForShadowAtSide:AVRUITableViewShadowSideRight];
			if (!startColor) {
				startColor = AVRUITableViewDefaultShadowClearColor;
			}
		}
		
		UIColor *stopColor = AVRUITableViewDefaultShadowBlackColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:stopColorForShadowAtSide:)]) {
			stopColor = [(id)[self delegate] tableView:self stopColorForShadowAtSide:AVRUITableViewShadowSideRight];
			if (!stopColor) {
				stopColor = AVRUITableViewDefaultShadowBlackColor;
			}
		}
		
		[rightGradientLayer setColors:[NSArray arrayWithObjects:(id)startColor.CGColor,
																(id)stopColor.CGColor, nil]];
        
		if ([[self delegate] respondsToSelector:@selector(tableView:paddingForShadowAtSide:)]) {
			rightGradientLayerPadding = [(id)[self delegate] tableView:self paddingForShadowAtSide:AVRUITableViewShadowSideRight];
		} else {
			rightGradientLayerPadding = AVRUITableViewDefaultShadowPadding;
		}
	} else {
		[rightGradientLayer removeFromSuperlayer];
	}

	if (shadowMask & AVRUITableViewShadowSideBottom) {
		[[self layer] addSublayer:bottomGradientLayer];
		
		UIColor *startColor = AVRUITableViewDefaultShadowClearColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:startColorForShadowAtSide:)]) {
			startColor = [(id)[self delegate] tableView:self startColorForShadowAtSide:AVRUITableViewShadowSideBottom];
			if (!startColor) {
				startColor = AVRUITableViewDefaultShadowClearColor;
			}
		}
		
		UIColor *stopColor = AVRUITableViewDefaultShadowBlackColor;
		if ([[self delegate] respondsToSelector:@selector(tableView:stopColorForShadowAtSide:)]) {
			stopColor = [(id)[self delegate] tableView:self stopColorForShadowAtSide:AVRUITableViewShadowSideBottom];
			if (!stopColor) {
				stopColor = AVRUITableViewDefaultShadowBlackColor;
			}
		}
		
		[bottomGradientLayer setColors:[NSArray arrayWithObjects:	(id)startColor.CGColor,
																	(id)stopColor.CGColor, nil]];
		
		if ([[self delegate] respondsToSelector:@selector(tableView:paddingForShadowAtSide:)]) {
			bottomGradientLayerPadding = [(id)[self delegate] tableView:self paddingForShadowAtSide:AVRUITableViewShadowSideBottom];
		} else {
			bottomGradientLayerPadding = AVRUITableViewDefaultShadowPadding;
		}
	} else {
		[bottomGradientLayer removeFromSuperlayer];
	}
}

- (void)dismissActivityView {
    if (state != AVRUITableViewStateActivity || [self contentOffset].y > 0) {
        [self setContentInset:UIEdgeInsetsZero];
        state = AVRUITableViewStateNone;
        
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
    state = AVRUITableViewStateNone;
}

@end
