//
//  NFSplitViewManager.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/12/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "SplitViewManager.h"

@interface SplitViewManager ()
@property (nonatomic, strong) UIPopoverController *popover;
@end

@implementation SplitViewManager

- (BOOL)shouldEmbedViewController:(UIViewController *)detailViewController
{
	if ([detailViewController respondsToSelector:@selector(embedInNavController)])
	{
		return ((UIViewController<ReplaceableDetailViewController> *)detailViewController).embedInNavController;
	}
	else if ([detailViewController respondsToSelector:@selector(persistentBarButtonItem)])
	{
		return NO;
	}
	else {
		return YES;
	}
}

- (void)setDetailViewController:(UIViewController<ReplaceableDetailViewController> *)detailViewController
{
	[self setDetailViewController:(UIViewController *)detailViewController
			updatingSplitView:YES];
}

/**
 Allow internal methods to set this value without changing the SplitView,
 i.e. when setting a SplitViewController that already has its hierarchy set up.
 */
- (void)setDetailViewController:(UIViewController *)detailViewController
			  updatingSplitView:(BOOL)shouldUpdateSplitView
{
	//Hide popover, if necessary
	if (self.popover.popoverVisible) {
		[self.popover dismissPopoverAnimated:YES];
	}
	
	// Move the "show master" button to the new view
	// Set Old Button to nil
	[self setPersistentBarButtonItem:nil forDetailViewController:self.detailViewController];
	
	// Switch to the new value
	_detailViewController = (UIViewController<ReplaceableDetailViewController> *)detailViewController;
	
	// Set New Button to our Persistent Button
	[self setPersistentBarButtonItem:self.persistentBarButtonItem
			 forDetailViewController:self.detailViewController];
	
	// Swap in the new view controller
	if (shouldUpdateSplitView) {
		NSMutableArray *vcs = [self.splitViewController.viewControllers mutableCopy];
		if (![vcs count]) { // If the controllers aren't set yet, fail instead of crashing
			[[NSException exceptionWithName:@"Could Not Set Detail View Controller" reason:@"Split View Controller didn't have a master and detail set before calling setDetailViewController" userInfo:nil] raise];
			return;
		}
		
		// Embed in a Navigation Controller if needed
		if ([self shouldEmbedViewController:self.detailViewController]) {
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
			nav.delegate = self;
			vcs[1] = nav;
		}
		else {
			vcs[1] = self.detailViewController;
		}
		self.splitViewController.viewControllers = vcs;
	}
}

- (void)setPersistentBarButtonItem:(UIBarButtonItem *)item
		   forDetailViewController:(UIViewController *)detailViewController
{
	if ([detailViewController respondsToSelector:@selector(persistentBarButtonItem)]) {
	// If not embedded, the Detail View Controller has to handle it on its own.
		((UIViewController<ReplaceableDetailViewController> *) detailViewController).persistentBarButtonItem = item;
	}

	// If embedded, it's in the Navigation Item
	else if ([self shouldEmbedViewController:detailViewController]) {
		detailViewController.navigationItem.leftItemsSupplementBackButton = YES;
		NSMutableArray *items = [NSMutableArray arrayWithArray:detailViewController.navigationItem.leftBarButtonItems];
		if (!item) {
			[items removeObject:self.persistentBarButtonItem];
		}
		else if(![items containsObject:item]) {
			[items count] ? [items insertObject:item atIndex:0] : [items addObject:item];
		}
		detailViewController.navigationItem.leftBarButtonItems = items;
	}
}

- (void)setPersistentBarButtonItem:(UIBarButtonItem *)persistentBarButtonItem
{
	// Set it for the Detail View Controller, too.
	[self setPersistentBarButtonItem:persistentBarButtonItem
			 forDetailViewController:self.detailViewController];
	
	// We need to hold the old one until now, so we can remove it from the VC's navigationItems array.
	_persistentBarButtonItem = persistentBarButtonItem;
}

- (void)setSplitViewController:(UISplitViewController *)splitViewController
{
	_splitViewController = splitViewController;
	splitViewController.delegate = self;
	
	UIViewController *detail = splitViewController.viewControllers[1];
	if ([detail  isKindOfClass:[UINavigationController class]]) {
		detail = ((UINavigationController *)detail).viewControllers[0];
	}

	[self setDetailViewController:detail updatingSplitView:NO];
}

#pragma mark Split View Controller Delegate

- (void)splitViewController:(UISplitViewController *)svc
	 willHideViewController:(UIViewController *)aViewController
		  withBarButtonItem:(UIBarButtonItem *)barButtonItem
	   forPopoverController:(UIPopoverController *)pc
{
	if (!self.splitViewController) {
		self.splitViewController = svc;
	}
	
	barButtonItem.title = @"BNR Discussions";
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

#pragma mark Navigation Controller Delegate

- (void)navigationController:(UINavigationController *)navigationController
	   didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if (viewController != self.detailViewController) {
		[self setDetailViewController:viewController
					updatingSplitView:NO];
		[self setPersistentBarButtonItem:self.persistentBarButtonItem
				 forDetailViewController:viewController];
	}
}

@end
