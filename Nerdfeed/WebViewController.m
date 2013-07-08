//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
	UIBarButtonItem *backButton;
	UIBarButtonItem *forwardButton;
}
@end

@implementation WebViewController

- (void)loadView
{
	// Content View -> WebView + Toolbar
	
	// Set up the content view with autolayout
	UIView *contentView = [UIView new];
	contentView.backgroundColor = [UIColor redColor];
	
	// Set up the Web View
	_webView = [UIWebView new];
	_webView.delegate = self;
	_webView.scalesPageToFit = YES;
	_webView.backgroundColor = [UIColor yellowColor];
	_webView.translatesAutoresizingMaskIntoConstraints = NO;
	[contentView addSubview:_webView];
	
	// Set up the back/forward buttons
	backButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
	forwardButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleDone target:self action:@selector(goForward:)];
	backButton.enabled = NO;
	forwardButton.enabled = NO;
	
	// Set up the Toolbar with back/forward buttons
	UIToolbar *toolbar = [UIToolbar new];
	toolbar.backgroundColor = [UIColor blueColor];
	toolbar.translatesAutoresizingMaskIntoConstraints = NO;
	[toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																	   target:nil action:nil],
						 backButton,
						 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
																	   target:nil action:nil],
						 forwardButton,
						 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
																	   target:nil action:nil]]];
	
	[toolbar setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[contentView addSubview:toolbar];
	
	NSDictionary *vs = @{@"webView":_webView, @"toolbar":toolbar};
	[contentView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView][toolbar]|"
											 options:0 metrics:nil views:vs]];
	[contentView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|"
											 options:0 metrics:nil views:vs]];
	[contentView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbar]|"
											 options:0 metrics:nil views:vs]];
		
	self.view = contentView;
}

- (void)viewDidLayoutSubviews
{
	NSLog(@"%@",self.view);
}

- (void)goBack:(id)sender
{
	if ([self.webView canGoBack]) {
		[self.webView goBack];
	}
}

- (void)goForward:(id)sender
{
	if ([self.webView canGoForward]) {
		[self.webView goForward];
	}
}

- (void)resetWebNavigationButtons
{
	backButton.enabled = self.webView.canGoBack;
	
	forwardButton.enabled = self.webView.canGoForward;
}

#pragma mark <UIWebViewDelegate>

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self resetWebNavigationButtons];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self resetWebNavigationButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[self resetWebNavigationButtons];
}

@end