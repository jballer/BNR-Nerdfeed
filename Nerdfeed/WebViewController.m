//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "WebViewController.h"
#import "RSSItem.h"
#import "UIViewController+JBSplitViewManager.h"

@interface WebViewController ()
{
	UIBarButtonItem *backButton;
	UIBarButtonItem *forwardButton;
}

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;

@end

@implementation WebViewController

- (void)loadView
{
	// Content View -> WebView + Toolbar
	
	// Set up the Web View
	_webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	_webView.delegate = self;
		
	// Test the left bar buttons on the nav bar
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:nil];
	
	
	// Set up the back/forward buttons
	backButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
	forwardButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleDone target:self action:@selector(goForward:)];
	backButton.enabled = NO;
	forwardButton.enabled = NO;
	

	[self setToolbarItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																		  target:nil action:nil],
							backButton,
							[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
																		  target:nil action:nil],
							forwardButton,
							[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
																		  target:nil action:nil]]];
	self.view = _webView;
}

- (void)viewDidLoad
{
<<<<<<< HEAD
	// Set up the Toolbar with back/forward buttons
	self.navigationController.toolbarHidden = NO;
	
	NSLog(@"Toolbar Items at ViewDidLoad: %@", self.toolbarItems);
=======
	NSLog(@"%@",self.view);
>>>>>>> parent of e9f2913... Split View Controller support. Known issue: iPhone layout on iOS 7 is ambiguous at UIWindow level. Looks like an Apple bug.
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

<<<<<<< HEAD
#pragma mark - Split View Manager

- (BOOL)shouldEmbedInNavController
{
	return YES;
}

- (BOOL)shouldPresentButtonAutomatically
{
	return NO;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
	NSLog(@"Set Split View Button: %@", splitViewBarButtonItem);
	NSLog(@"Before: %@", self.toolbarItems);
	
	NSMutableArray *items = [NSMutableArray arrayWithArray:self.toolbarItems];

	if (_splitViewBarButtonItem) {
		[items removeObject:_splitViewBarButtonItem];
	}
	
	_splitViewBarButtonItem = splitViewBarButtonItem;

	// If it's getting deleted, this must be called after updating the ivar to nil
	// setToolbarItems injects the splitViewButton on its own
	[self setToolbarItems:[items copy]];
	NSLog(@"After: %@", self.toolbarItems);
}

- (void)setToolbarItems:(NSArray *)toolbarItems animated:(BOOL)animated
{
	NSMutableArray *items = [NSMutableArray arrayWithObjects:self.splitViewBarButtonItem, nil];
	[items addObjectsFromArray:toolbarItems];
	
	[super setToolbarItems:items animated:animated];
}

#pragma mark - List View Delegate

- (void)listViewController:(ListViewController *)lvc handleObject:(id)object
{
	if ([object isKindOfClass:[RSSItem class]]) {
		RSSItem *item = object;
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.link]];
		[self.webView loadRequest:request];
		
		self.navigationItem.title = item.title;
		self.navigationController.toolbarHidden = NO;
	}
}

#pragma mark - Web View Delegate
=======
#pragma mark <UIWebViewDelegate>
>>>>>>> parent of e9f2913... Split View Controller support. Known issue: iPhone layout on iOS 7 is ambiguous at UIWindow level. Looks like an Apple bug.

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