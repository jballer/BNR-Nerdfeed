//
//  UIViewController+JBSplitViewManager.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/13/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "UIViewController+JBSplitViewManager.h"
#import "UINavigationItem+JBSplitViewManagerAdditions.h"
#import "JBSplitViewManager.h"

@implementation UIViewController (JBSplitViewManager)

- (BOOL)shouldEmbedInNavController
{
	return YES;
}

- (BOOL)shouldPresentButtonAutomatically
{
	return YES;
}

- (UIBarButtonItem *)splitViewBarButtonItem
{
	JBSplitViewManager *manager = (JBSplitViewManager *)(self.splitViewController.delegate);
	return manager.splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
	return;
}

@end
