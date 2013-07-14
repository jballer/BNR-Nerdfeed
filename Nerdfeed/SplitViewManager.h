//
//  NFSplitViewManager.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/12/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReplaceableDetailViewController

@optional

/**
 Defaults to YES if there's no persistentBarButtonItem provided.

 If a persistentBarButtonItem is provided, defaults to NO.
 */
@property (nonatomic, readonly) BOOL embedInNavController;

/**
 @warning If not provided, the view will be presented in a UINavigationController, and
 the item handled automatically. This will make the Split View Manager the Navigation Controller's delegate.
 */
@property (nonatomic, retain) UIBarButtonItem *persistentBarButtonItem;

@end

@interface SplitViewManager : NSObject <UISplitViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UISplitViewController *splitViewController;
@property (nonatomic, strong) UIViewController<ReplaceableDetailViewController> *detailViewController;
@property (nonatomic, strong) UIBarButtonItem *persistentBarButtonItem;

@end
