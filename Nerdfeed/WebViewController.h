//
//  WebViewController.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"

@interface WebViewController : UIViewController <UIWebViewDelegate, UISplitViewControllerDelegate, ListViewControllerDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIToolbar *toolbar;

@end
