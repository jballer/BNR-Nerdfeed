//
//  ListViewController.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "ListViewController.h"

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		// Kick off the asynchronous data fetch
        [self fetchEntries];
    }
    return self;
}

- (void)fetchEntries
{
	// Connect to forums.bignerdranch.com and get last 20 posts in RSS2.0 format
	
	// Data Container
	self.xmlData = [[NSMutableData alloc] init];
	
	// URL
	NSURL *url = [NSURL URLWithString:
				  @"http://forums.bignerdranch.com/smartfeed.php?"
				  @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
	
	// Apple's "Hot News" feed
	//	NSURL *url2 = [NSURL URLWithString:@"http://www.apple.com/pr/feeds/pr.rss"];
	
	// Put the URL in a request
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	// Create a connection with the request
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	// (BNR says to use alloc initWithRequest:delegate:startImmediately:)
}

#pragma mark <NSURLConnectionDataDelegate>

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// Add the incoming data to the container.
	// (It's always in the right order)
	[self.xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
	// Check that we're getting the right data
//	NSString *xmlCheck = [[NSString alloc] initWithData:self.xmlData encoding:NSUTF8StringEncoding];
//	NSLog(@"XML Received from\n\n<   %@   >\n\n%@",conn.currentRequest.URL,xmlCheck);
	
	// Set up a parser
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.xmlData];
	
	// Give it a delegate
	parser.delegate = self;
	
	// Start parsing
	[parser parse];
	
	// Clean up
	self.xmlData = nil;
	self.connection = nil;

	// Refresh the table data
	[self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	// Release the connection object
	self.connection = nil;
	
	// Release the data object
	self.xmlData = nil;
	
	// Get the error details that were passed to us
	NSString *errorString = [NSString stringWithFormat:@"Fetch Failed: %@",
							 [error localizedDescription]];
	
	// Show an alert with the error
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
														 message:errorString
														delegate:self
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
	[errorAlert show];
}

#pragma mark <NSXMLParserDelegate>

/*
 Parse the RSS feed…
 
 <title> or <description> --> RSSChannel
 <item> --> RSSItem --> RSSChannel's 'items' array
 
 */

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	
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
