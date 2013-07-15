//
//  ListViewController.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "ListViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"
#import "ChannelViewController.h"
#import "NFTestViewController.h"

//TODO: Bronze Challenge - UITableViewCell with 3 labels

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
<<<<<<< HEAD
		self.navigationItem.backBarButtonItem.title = @"List Back";
		
		UIBarButtonItem *channelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info"
																			  style:UIBarButtonItemStyleBordered
																			 target:self
																			 action:@selector(showChannelInfo:)];
		UIBarButtonItem *testButton = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStyleBordered target:self action:@selector(showTestViewController)];
		self.navigationItem.rightBarButtonItems = @[channelButtonItem, testButton];
		
=======
>>>>>>> parent of e9f2913... Split View Controller support. Known issue: iPhone layout on iOS 7 is ambiguous at UIWindow level. Looks like an Apple bug.
		// Kick off the asynchronous data fetch
        [self fetchEntries];
    }
    return self;
}

- (void)showTestViewController
{
	UIViewController *tvc = [NFTestViewController new];
	((JBSplitViewManager *)self.splitViewController.delegate).detailViewController = tvc;
}

- (void)fetchEntries
{	
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

- (void)showChannelInfo:(id)sender
{
	ChannelViewController *cvc = [[ChannelViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	if (self.splitViewController) {
		// Clear any selection since the detail is getting replaced
		if (self.tableView.indexPathForSelectedRow) {
			[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
		}
		
		// Replace the WebView with this thing
		JBSplitViewManager *manager = (JBSplitViewManager *)self.splitViewController.delegate;
		manager.detailViewController = cvc;
	}
	else {
		[self.navigationController pushViewController:cvc animated:YES];
	}
	
	[cvc listViewController:self handleObject:self.channel];
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
	NSString *xmlCheck = [[NSString alloc] initWithData:self.xmlData encoding:NSUTF8StringEncoding];
	NSLog(@"XML Received from\n\n<   %@   >\n\n%@",conn.currentRequest.URL,xmlCheck);
	
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
	
	NSLog(@"%@\n %@\n %@\n", _channel, _channel.title, _channel.infoString);
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

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict
{
	NSLog(@"%@ found a %@ element",self,elementName);
	
	if ([elementName isEqualToString:@"channel"]) {
		// Store the channel
		self.channel = [NSEntityDescription insertNewObjectForEntityForName:@"RSSChannel" inManagedObjectContext:self.managedObjectContext];
		
		// Give it a pointer back to here
		self.channel.parentParserDelegate = self;
		
		// Set it as the parser's delegate
		parser.delegate = self.channel;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
	if(_fetchedResultsController)
		return _fetchedResultsController;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"RSSItem" inManagedObjectContext:self.managedObjectContext];
	request.entity = entity;
	
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
	request.sortDescriptors = @[descriptor];
	
	_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
	
	NSError *error = [NSError new];
	[_fetchedResultsController performFetch:&error];
	
	return _fetchedResultsController;
}

#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"\n\nCOUNT: %d", self.channel.items.count);
	return self.channel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSDateFormatter *formatter = nil;
	
	if (!formatter) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:@"UITableViewCell"];
	}
	
	RSSItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.textLabel.text = item.title;
	cell.detailTextLabel.text = [formatter stringFromDate:item.date];
	
	return cell;
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
<<<<<<< HEAD
	RSSItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];

	if (self.splitViewController) {
		JBSplitViewManager *manager = (JBSplitViewManager *)self.splitViewController.delegate;
		manager.detailViewController = self.webViewController;
	}
	else {
		[self.navigationController pushViewController:self.webViewController animated:YES];
	}
=======
	[self.navigationController pushViewController:self.webViewController animated:YES];
	
	RSSItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.link]];
>>>>>>> parent of e9f2913... Split View Controller support. Known issue: iPhone layout on iOS 7 is ambiguous at UIWindow level. Looks like an Apple bug.
	
	[self.webViewController listViewController:self handleObject:item];
}

@end
