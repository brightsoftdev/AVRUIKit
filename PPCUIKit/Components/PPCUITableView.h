//
//  PPCUITableView.h
//  PPCUIKit
//
//  Created by Andrea Gelati on 12/27/10.
//  Copyright (c) 2011 Push Popcorn ( http://pushpopcorn.com ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define PPCUITableViewDefaultShadowPadding 5.0f
#define PPCUITableViewDefaultShadowBlackColor [UIColor colorWithWhite:0.0f alpha:0.5f]
#define PPCUITableViewDefaultShadowClearColor [UIColor clearColor]
#define PPCUITableViewDefaultShadowOffset 20

typedef enum PPCUITableViewScrollDirections {
    PPCUITableViewScrollDirectionUndetermined = 0, // default
    PPCUITableViewScrollDirectionUp,
    PPCUITableViewScrollDirectionDown,
} PPCUITableViewScrollDirections;

typedef enum PPCUITableViewStates {
    PPCUITableViewStateNone = 0, // default
    PPCUITableViewStatePull,
    PPCUITableViewStateRelease,
    PPCUITableViewStateActivity,
} PPCUITableViewStates;

enum {
	PPCUITableViewShadowSideNone		= 0 << 0, // default
	PPCUITableViewShadowSideTop         = 1 << 0,
	PPCUITableViewShadowSideBottom		= 1 << 1,
	PPCUITableViewShadowSideLeft		= 1 << 2,
	PPCUITableViewShadowSideRight		= 1 << 3,
};
typedef NSUInteger PPCUITableViewShadowSides;


@class PPCUITableView;

@protocol PPCUITableViewDelegate <NSObject, UITableViewDelegate>
@optional

/* return the padding of the shadow or return the PPCUITableViewDefaultShadowPadding default value.
 */
- (CGFloat)tableView:(PPCUITableView *)tableView paddingForShadowAtSide:(PPCUITableViewShadowSides)side;

/* return the startColor of the shadow or nil in case you want to use the default color.
 */
- (UIColor *)tableView:(PPCUITableView *)tableView startColorForShadowAtSide:(PPCUITableViewShadowSides)side;

/* return the stopColor of the shadow or nil in case you want to use the default color.
 */
- (UIColor *)tableView:(PPCUITableView *)tableView stopColorForShadowAtSide:(PPCUITableViewShadowSides)side;

/* return the activity view to manage the 'pull down / release' actions.
 */
- (UIView *)activityViewInTableView:(PPCUITableView *)tableView;

/* called when the user is scrolling and change the up/down direction.
 */
- (void)tableView:(PPCUITableView *)tableView scrollDidChangeDirection:(PPCUITableViewScrollDirections)direction;

/* called when the user pull down the table view and the activity view will displayed.
 */
- (void)tableView:(PPCUITableView *)tableView willPullHeaderView:(UIView *)activityView;

/* called when the user release the table view and the activity view will not displayed.
 */
- (void)tableView:(PPCUITableView *)tableView willReleaseHeaderView:(UIView *)activityView;

/* called when the user have pulled completely the activity view and the app will begin the activity.
 */
- (void)tableView:(PPCUITableView *)tableView activityWillBeginInHeaderView:(UIView *)activityView;
@end

@interface PPCUITableView : UITableView <UIGestureRecognizerDelegate> {
	CAGradientLayer *leftGradientLayer;
	CAGradientLayer *topGradientLayer;
	CAGradientLayer *rightGradientLayer;
	CAGradientLayer *bottomGradientLayer;
	
	CGFloat leftGradientLayerPadding;
	CGFloat topGradientLayerPadding;
	CGFloat rightGradientLayerPadding;
	CGFloat bottomGradientLayerPadding;

	PPCUITableViewShadowSides shadowMask;
    PPCUITableViewScrollDirections scrollDirection;
    PPCUITableViewStates state;
    
    UIView *activityView;
    
    CGPoint previewContentOffset; // needed to understand the up/down dragging direction.
}

@property (nonatomic, readonly) PPCUITableViewShadowSides shadowMask;
@property (nonatomic, readonly) PPCUITableViewScrollDirections scrollDirection;
@property (nonatomic, readonly) PPCUITableViewStates state;

#pragma mark - Methods

/* the bit mask for define what side have the shadow.
 */
- (void)setShadowMask:(PPCUITableViewShadowSides)mask;

/* redefined the delegate setter to inject and manage the AVRUITableView extensions.
 */
- (void)setDelegate:(id<UITableViewDelegate>)delegate;

/* dismiss the activity view.
 */
- (void)dismissActivityView;

@end
