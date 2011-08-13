//
//  AVRUITableView.h
//  AVRUIKit
//
//  Created by Andrea Gelati on 12/27/10.
//  Copyright (c) 2011 Andrea Gelati ( http://andreagelati.com ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define AVRUITableViewDefaultShadowPadding 5.0f
#define AVRUITableViewDefaultShadowBlackColor [UIColor colorWithWhite:0.0f alpha:0.5f]
#define AVRUITableViewDefaultShadowClearColor [UIColor clearColor]
#define AVRUITableViewDefaultShadowOffset 20

typedef enum AVRUITableViewScrollDirections {
    AVRUITableViewScrollDirectionUndetermined = 0, // default
    AVRUITableViewScrollDirectionUp,
    AVRUITableViewScrollDirectionDown,
} AVRUITableViewScrollDirections;

typedef enum AVRUITableViewStates {
    AVRUITableViewStateNone = 0, // default
    AVRUITableViewStatePull,
    AVRUITableViewStateRelease,
    AVRUITableViewStateActivity,
} AVRUITableViewStates;

enum {
	AVRUITableViewShadowSideNone		= 0 << 0, // default
	AVRUITableViewShadowSideTop         = 1 << 0,
	AVRUITableViewShadowSideBottom		= 1 << 1,
	AVRUITableViewShadowSideLeft		= 1 << 2,
	AVRUITableViewShadowSideRight		= 1 << 3,
};
typedef NSUInteger AVRUITableViewShadowSides;


@class AVRUITableView;

@protocol AVRUITableViewDelegate <NSObject, UITableViewDelegate>
@optional

/* return the padding of the shadow or return the AVRUITableViewDefaultShadowPadding default value.
 */
- (CGFloat)tableView:(AVRUITableView *)tableView paddingForShadowAtSide:(AVRUITableViewShadowSides)side;

/* return the startColor of the shadow or nil in case you want to use the default color.
 */
- (UIColor *)tableView:(AVRUITableView *)tableView startColorForShadowAtSide:(AVRUITableViewShadowSides)side;

/* return the stopColor of the shadow or nil in case you want to use the default color.
 */
- (UIColor *)tableView:(AVRUITableView *)tableView stopColorForShadowAtSide:(AVRUITableViewShadowSides)side;

/* return the activity view to manage the 'pull down / release' actions.
 */
- (UIView *)activityViewInTableView:(AVRUITableView *)tableView;

/* called when the user is scrolling and change the up/down direction.
 */
- (void)tableView:(AVRUITableView *)tableView scrollDidChangeDirection:(AVRUITableViewScrollDirections)direction;

/* called when the user pull down the table view and the activity view will displayed.
 */
- (void)tableView:(AVRUITableView *)tableView willPullHeaderView:(UIView *)activityView;

/* called when the user release the table view and the activity view will not displayed.
 */
- (void)tableView:(AVRUITableView *)tableView willReleaseHeaderView:(UIView *)activityView;

/* called when the user have pulled completely the activity view and the app will begin the activity.
 */
- (void)tableView:(AVRUITableView *)tableView activityWillBeginInHeaderView:(UIView *)activityView;
@end

@interface AVRUITableView : UITableView <UIGestureRecognizerDelegate> {
	CAGradientLayer *leftGradientLayer;
	CAGradientLayer *topGradientLayer;
	CAGradientLayer *rightGradientLayer;
	CAGradientLayer *bottomGradientLayer;
	
	CGFloat leftGradientLayerPadding;
	CGFloat topGradientLayerPadding;
	CGFloat rightGradientLayerPadding;
	CGFloat bottomGradientLayerPadding;

	AVRUITableViewShadowSides shadowMask;
    AVRUITableViewScrollDirections scrollDirection;
    AVRUITableViewStates state;
    
    UIView *activityView;
    
    CGPoint previewContentOffset; // needed to understand the up/down dragging direction.
}

@property (nonatomic, readonly) AVRUITableViewShadowSides shadowMask;
@property (nonatomic, readonly) AVRUITableViewScrollDirections scrollDirection;
@property (nonatomic, readonly) AVRUITableViewStates state;

#pragma mark - Methods

/* the bit mask for define what side have the shadow.
 */
- (void)setShadowMask:(AVRUITableViewShadowSides)mask;

/* redefined the delegate setter to inject and manage the AVRUITableView extensions.
 */
- (void)setDelegate:(id<UITableViewDelegate>)delegate;

/* dismiss the activity view.
 */
- (void)dismissActivityView;

@end
