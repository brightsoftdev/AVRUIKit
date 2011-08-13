//
//  AVRUITabBar.h
//  AVRUIKit
//
//  Created by Andrea Gelati on 8/7/11.
//  Copyright (c) 2011 Andrea Gelati ( http://andreagelati.com ). All rights reserved.
//

#import <UIKit/UIKit.h> 

@protocol AVRUITabBarDelegate;

@interface AVRUITabBar : UITabBar {
    
}

@end

@protocol AVRUITabBarDelegate <NSObject, UITabBarDelegate>
@optional

/* return the number of sub items to attach at the tabBarItem.
 */
- (NSUInteger)numberOfMenuItemsForTabBarItem:(UITabBarItem *)item inTabBar:(UITabBar *)tabBar;

/* return the menu item (UITabBarItem *) associated to the menu.
 */
- (UITabBarItem *)menuItemAtIndex:(NSUInteger)index forTabBarItem:(UITabBarItem *)item inTabBar:(UITabBar *)tabBar;

// define the background color of the menu.
- (UIColor *)menuBackgroundColorInTabBar:(UITabBar *)tabBar;

@end