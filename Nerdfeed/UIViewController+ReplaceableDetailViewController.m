//
//  UIViewController+ReplaceableDetailViewController.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/12/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "UIViewController+ReplaceableDetailViewController.h"
#import "SplitViewManager.h"

@implementation UIViewController (ReplaceableDetailViewController)

- (UIBarButtonItem *)persistentBarButtonItem
{
	return self.splitViewController.persistentBarButtonItem;
}

- (void)setPersistentBarButtonItem:(UIBarButtonItem *)persistentBarButtonItem
{
	NSMutableArray *buttonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
	
	if (persistentBarButtonItem) {
		[buttonItems count] ?
		[buttonItems insertObject:persistentBarButtonItem atIndex:0] : [buttonItems addObject:persistentBarButtonItem];
	}
	else {
		[buttonItems removeObject:((SplitViewManager *)self.splitViewController.delegate).persistentBarButtonItem];
	}
	
	self.navigationItem.leftBarButtonItems = buttonItems;
}

@end
