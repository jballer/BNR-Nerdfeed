//
//  UIViewController+JBSplitViewManager.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/13/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JBSplitViewManager)

/**
 Defaults to YES if there's no splitViewBarButtonItem provided.
 
 If a splitViewBarButtonItem is provided, defaults to NO.
 */
@property (nonatomic, readonly) BOOL shouldEmbedInNavController;
@property (nonatomic, readonly) BOOL shouldPresentButtonAutomatically;

/**
 @warning If not provided, the view will be presented in a UINavigationController, and
 the item handled automatically. This will make the Split View Manager the Navigation Controller's delegate.
 */
@property (nonatomic, retain) UIBarButtonItem *splitViewBarButtonItem;

- (BOOL)shouldEmbedInNavController;
- (UIBarButtonItem *)splitViewBarButtonItem;
- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem;

@end
