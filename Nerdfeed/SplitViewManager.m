//
//  NFSplitViewManager.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/12/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "SplitViewManager.h"

@interface SplitViewManager ()

@property (nonatomic, strong) UIBarButtonItem *persistentBarButtonItem;
@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation SplitViewManager

- (void)setDetailViewController:(UIViewController<ReplaceableDetailViewController> *)detailViewController
{
	// Move the "show master" button to the new view
	_detailViewController.persistentBarButtonItem = nil;
	detailViewController.persistentBarButtonItem = self.persistentBarButtonItem;
	
	// Swap in the new view controller
	NSMutableArray *vcs = [self.splitViewController.viewControllers mutableCopy];
	UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailViewController];
	[vcs setObject:detailNav atIndexedSubscript:1];
	
	self.splitViewController.viewControllers = vcs;
	
	// Dismiss the popover
	if ([self.popover isPopoverVisible]) {
		[self.popover dismissPopoverAnimated:YES];
	}
	
	_detailViewController = detailViewController;
}

- (void)setPersistentBarButtonItem:(UIBarButtonItem *)persistentBarButtonItem
{
	if (_persistentBarButtonItem != persistentBarButtonItem) {
		_persistentBarButtonItem = persistentBarButtonItem;
		_detailViewController.persistentBarButtonItem = persistentBarButtonItem;
		// could cause deadlock if not first checked for equality!
	}
}

#pragma mark Split View Controller Delegate

- (void)splitViewController:(UISplitViewController *)svc
	 willHideViewController:(UIViewController *)aViewController
		  withBarButtonItem:(UIBarButtonItem *)barButtonItem
	   forPopoverController:(UIPopoverController *)pc
{
	barButtonItem.title = @"< BNR Discussions";
	self.persistentBarButtonItem = barButtonItem;
	
	self.popover = pc;
}

- (void)splitViewController:(UISplitViewController *)svc
	 willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	self.persistentBarButtonItem = nil;
	self.popover = nil;
}

@end
