//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;

@end

@implementation WebViewController

- (void)loadView
{
	// create a webview as big as the screen
	CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
	
	//	Tried embedding this to do a toolbar; went with nav bar items instead
//	self.view = [[UIView alloc] initWithFrame:screenFrame];
//	_webView = [[UIWebView alloc] initWithFrame:[self.view bounds]];
	
	_webView = [[UIWebView alloc] initWithFrame:screenFrame];
	_webView.delegate = self;
	_webView.scalesPageToFit = YES;
	
	
	_backButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
	_forwardButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleDone target:self action:@selector(goForward:)];
	
	self.navigationItem.rightBarButtonItems = @[_forwardButton, _backButton];
	
	self.view = _webView;
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
	self.backButton.enabled = self.webView.canGoBack;
	
	self.forwardButton.enabled = self.webView.canGoForward;
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
