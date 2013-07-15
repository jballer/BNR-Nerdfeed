//
//  WebViewController.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"
#import "JBSplitViewManager.h"

<<<<<<< HEAD
@interface WebViewController : UIViewController <UIWebViewDelegate, ListViewControllerDelegate>
=======
@interface WebViewController : UIViewController <UIWebViewDelegate>
>>>>>>> parent of e9f2913... Split View Controller support. Known issue: iPhone layout on iOS 7 is ambiguous at UIWindow level. Looks like an Apple bug.

@property (nonatomic, strong) UIWebView *webView;

@end
