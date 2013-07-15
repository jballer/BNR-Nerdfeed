//
//  NFSplitViewManager.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/12/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBSplitViewManager : NSObject <UISplitViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UISplitViewController *splitViewController;
@property (nonatomic, strong) UIViewController *detailViewController;

@property (nonatomic, strong, readonly) UIBarButtonItem *splitViewBarButtonItem;

@end
