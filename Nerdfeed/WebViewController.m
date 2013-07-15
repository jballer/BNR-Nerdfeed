//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "WebViewController.h"
#import "RSSItem.h"

@interface WebViewController ()
{
	UIBarButtonItem *backButton;
	UIBarButtonItem *forwardButton;
}
@end

@implementation WebViewController

@synthesize webView = webView;

- (void)loadView
{
	// Set up the Web View
	webView = [UIWebView new];
	self.view = webView;
}

- (void)viewDidLoad
{
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	
	// Set up the back/forward buttons
	backButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
	backButton.width = 44;
	forwardButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleDone target:self action:@selector(goForward:)];
	forwardButton.width = 44;
}

- (void)viewDidLayoutSubviews
{
	MyLog(@"%@",self.view);
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
//	backButton.enabled = self.webView.canGoBack;
//	forwardButton.enabled = self.webView.canGoForward;
	
	UIBarButtonItem *backItem;
	UIBarButtonItem *forwardItem;

	// Intrinsic button widths aren't available with a public API, so I set them manually.
	// One alternative is to use KVC to get the frame of the UIBarButtonItem's 'view' ivar.
	backItem = self.webView.canGoBack ? backButton : [self fixedSpaceWithSize:backButton.width];
	forwardItem = self.webView.canGoForward ? forwardButton : [self fixedSpaceWithSize:forwardButton.width];
	
	// Place them in the toolbar provided by the navigation bar
	[self.navigationController setToolbarHidden:(!(self.webView.canGoBack || self.webView.canGoForward)) animated:YES];
	[self setToolbarItems:@[[self flexibleSpace],
							backItem,
							[self fixedSpaceWithSize:8],
							 forwardItem]
				  animated:YES];
}

#pragma mark Helper Methods

- (UIBarButtonItem *)fixedSpaceWithSize:(CGFloat)size
{
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedSpace.width = size;
	return fixedSpace;
}

- (UIBarButtonItem *)flexibleSpace
{
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

#pragma mark - List View Delegate

- (void)listViewController:(ListViewController *)lvc handleObject:(id)object
{
	if ([object isKindOfClass:[RSSItem class]]) {
		RSSItem *item = object;
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.link]];
		[self.webView loadRequest:request];
		
		self.navigationItem.title = item.title;
	}
}

#pragma mark - Web View Delegate

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