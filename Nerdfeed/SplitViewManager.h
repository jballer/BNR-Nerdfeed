//
//  NFSplitViewManager.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/12/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SplitViewManager : NSObject <UISplitViewControllerDelegate>

@property (nonatomic, retain) UISplitViewController *splitViewController;
@property (nonatomic, weak) UIViewController *detailViewController;
@property (nonatomic, strong) UIBarButtonItem *persistentBarButtonItem;

@end
