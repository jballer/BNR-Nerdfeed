//
//  ListViewController.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "ListViewController.h"

@implementation ListViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self fetchEntries];
    }
    return self;
}

- (void)fetchEntries
{
	// Connect to forums.bignerdranch.com and get last 20 posts in RSS2.0 format
	
	// Data Container
	xmlData = [[NSMutableData alloc] init];
	
	// URL
	NSURL *url = [NSURL URLWithString:
				  @"http://forums.bignerdranch.com/smartfeed.php?"
				  @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
	
	// Apple's "Hot News" feed
	//	NSURL *url2 = [NSURL URLWithString:@"http://www.apple.com/pr/feeds/pr.rss"];
	
	// Put the URL in a request
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	// Create a connection with the request
	connection = [NSURLConnection connectionWithRequest:request delegate:self];
	// (BNR says to use alloc initWithRequest:delegate:startImmediately:)
	
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end
