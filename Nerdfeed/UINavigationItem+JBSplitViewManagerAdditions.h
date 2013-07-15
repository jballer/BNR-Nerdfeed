//
//  UINavigationItem+JBSplitViewManagerAdditions.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/13/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (JBSplitViewManagerAdditions)

- (void)addSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem;
- (void)removeSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem;

@end
