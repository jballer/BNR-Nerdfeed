//
//  WebViewController.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"
#import "SplitViewManager.h"

@interface WebViewController : UIViewController <UIWebViewDelegate, ListViewControllerDelegate, ReplaceableDetailViewController>

@property (nonatomic, strong, readonly) UIWebView *webView;

@end
