//
//  UINavigationItem+JBSplitViewManagerAdditions.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/13/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "UINavigationItem+JBSplitViewManagerAdditions.h"

@implementation UINavigationItem (JBSplitViewManagerAdditions)

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
	NSMutableArray *items = [NSMutableArray arrayWithArray:self.leftBarButtonItems];
	if (!leftBarButtonItem) {
		if ([self.leftBarButtonItems count] > 1) {
			[items removeObjectAtIndex:1];
		}
		else {
			[items removeObjectAtIndex:0];
		}
	}
	else if([items count]) {
		items[1] = leftBarButtonItem;
	}
	else {
		items[0] = leftBarButtonItem;
	}
	
	self.leftBarButtonItems = items;
}

- (void)addSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
	if (splitViewBarButtonItem) {
		NSMutableArray *items = [NSMutableArray arrayWithArray:self.leftBarButtonItems];
		[items insertObject:splitViewBarButtonItem atIndex:0];
		self.leftBarButtonItems = items;
	}
	

}

- (void)removeSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
	if ([self.leftBarButtonItems count]) {
		NSMutableArray *items = [NSMutableArray arrayWithArray:self.leftBarButtonItems];
		[items removeObjectAtIndex:0];
		self.leftBarButtonItems = items;
	}
}

@end
