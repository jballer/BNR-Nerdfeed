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
	
	__weak UIPopoverController *popover;
}
@end

@implementation WebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.navigationItem.leftItemsSupplementBackButton = YES;
	}
	return self;
}

- (void)loadView
{
	// Content View -> WebView + Toolbar
	
	// Set up the content view with autolayout
	UIView *contentView = [UIView new];
//	contentView.backgroundColor = [UIColor redColor];
	
	// Set up the Web View
	_webView = [UIWebView new];
	_webView.delegate = self;
	_webView.scalesPageToFit = YES;
//	_webView.backgroundColor = [UIColor yellowColor];
	_webView.translatesAutoresizingMaskIntoConstraints = NO;
	[contentView addSubview:_webView];
	
	// Set up the back/forward buttons
	backButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
	forwardButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleDone target:self action:@selector(goForward:)];
	backButton.enabled = NO;
	forwardButton.enabled = NO;
	
	// Set up the Toolbar with back/forward buttons
	UIToolbar *toolbar = [UIToolbar new];
//	toolbar.backgroundColor = [UIColor blueColor];
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
	backButton.enabled = self.webView.canGoBack;
	
	forwardButton.enabled = self.webView.canGoForward;
}

#pragma mark - Accessors

#pragma mark Replaceable Detail View Controller

- (void)setPersistentBarButtonItem:(UIBarButtonItem *)persistentBarButtonItem
{
	NSMutableArray *buttonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
	
	if (persistentBarButtonItem) {
		[buttonItems count] ?
			[buttonItems insertObject:persistentBarButtonItem atIndex:0] : [buttonItems addObject:persistentBarButtonItem];
	}
	else {
		[buttonItems removeObject:_persistentBarButtonItem];
	}
	
	self.navigationItem.leftBarButtonItems = buttonItems;
	
	_persistentBarButtonItem = persistentBarButtonItem;
}

#pragma mark - List View Delegate

- (void)listViewController:(ListViewController *)lvc handleObject:(id)object
{
	if ([object isKindOfClass:[RSSItem class]]) {
		RSSItem *item = object;
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.link]];
		[self.webView loadRequest:request];
		
		self.navigationItem.title = item.title;
		if (popover) {
			[popover dismissPopoverAnimated:YES];
		}
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

#pragma mark - Split View Delegate

- (void)splitViewController:(UISplitViewController *)svc
	 willHideViewController:(UIViewController *)aViewController
		  withBarButtonItem:(UIBarButtonItem *)barButtonItem
	   forPopoverController:(UIPopoverController *)pc
{
	[self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
	popover = pc;
}

- (void)splitViewController:(UISplitViewController *)svc
	 willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	[self.navigationItem setLeftBarButtonItem:nil animated:YES];
}
@end