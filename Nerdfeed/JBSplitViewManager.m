 //
//  NFSplitViewManager.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/12/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "JBSplitViewManager.h"
#import "UIViewController+JBSplitViewManager.h"
#import "UINavigationItem+JBSplitViewManagerAdditions.h"

@interface JBSplitViewManager ()
@property (nonatomic, strong) UIPopoverController *popover;
@end

@implementation JBSplitViewManager

- (BOOL)shouldEmbedViewController:(UIViewController *)detailViewController
{
	return detailViewController.shouldEmbedInNavController;
}

- (void)setDetailViewController:(UIViewController *)detailViewController
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
	[self removeSplitViewBarButtonItemFromDetailViewController];
	
	// Switch to the new value
	_detailViewController = detailViewController;
	
	// Add it to the new controller
	[self addSplitViewBarButtonItemToDetailViewController];
	
	// Swap in the new view controller
	if (shouldUpdateSplitView) {
		NSMutableArray *vcs = [self.splitViewController.viewControllers mutableCopy];
		if (![vcs count]) {
			[[NSException exceptionWithName:@"Failed to set Detail View Controller" reason:@"SplitViewController must have at least a master view controller." userInfo:nil] raise];
		}

		// Embed in a Navigation Controller if needed
		if (self.detailViewController.shouldEmbedInNavController) {
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
			nav.delegate = self;
			[vcs insertObject:nav atIndex:1];
		}
		else {
			[vcs insertObject:self.detailViewController atIndex:1];
		}
		self.splitViewController.viewControllers = vcs;
	}
}

- (void)addSplitViewBarButtonItemToDetailViewController
{
	self.detailViewController.splitViewBarButtonItem = self.splitViewBarButtonItem;

	if (self.detailViewController.shouldPresentButtonAutomatically) {
		[self.detailViewController.navigationItem addSplitViewBarButtonItem:self.splitViewBarButtonItem];
	}
}

- (void)removeSplitViewBarButtonItemFromDetailViewController
{
	self.detailViewController.splitViewBarButtonItem = nil;
	
	if (self.detailViewController.shouldPresentButtonAutomatically) {
		[self.detailViewController.navigationItem removeSplitViewBarButtonItem:self.splitViewBarButtonItem];
	}
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
	_splitViewBarButtonItem = splitViewBarButtonItem;
	
	// Set it for the Detail View Controller, too.
	if (self.splitViewBarButtonItem) {
		[self addSplitViewBarButtonItemToDetailViewController];
	}
	else {
		[self removeSplitViewBarButtonItemFromDetailViewController];
	}
}

- (void)setSplitViewController:(UISplitViewController *)splitViewController
{
	_splitViewController = splitViewController;
	splitViewController.delegate = self;
	
	if (splitViewController.viewControllers.count > 1) {
		UIViewController *detail = splitViewController.viewControllers[1];
		if ([detail  isKindOfClass:[UINavigationController class]]) {
			detail = ((UINavigationController *)detail).viewControllers[0];
		}
		
		[self setDetailViewController:detail updatingSplitView:NO];
	}
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
	
	if (self.splitViewBarButtonItem != barButtonItem) {
		barButtonItem.title = @"BNR Discussions";
		self.splitViewBarButtonItem = barButtonItem;
	}
	
	if (self.popover != pc) {
		self.popover = pc;
	}
}

- (void)splitViewController:(UISplitViewController *)svc
	 willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	self.splitViewBarButtonItem = nil;
	self.popover = nil;
}

#pragma mark Navigation Controller Delegate

- (void)navigationController:(UINavigationController *)navigationController
	   didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if (viewController != self.detailViewController) {
		[self setDetailViewController:viewController
					updatingSplitView:NO];
	}
}

@end
