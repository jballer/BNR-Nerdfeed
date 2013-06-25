//
//  WebViewController.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end
