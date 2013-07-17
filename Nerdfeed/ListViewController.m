//
//  ListViewController.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "BNRFeedStore.h"
#import "ListViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"
#import "ChannelViewController.h"

//TODO: Bronze Challenge - UITableViewCell with 3 labels

@implementation ListViewController
{
	UISegmentedControl *rssTypePicker;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		self.navigationItem.backBarButtonItem.title = @"RSS";
		NSLog(@"Back item: %@\nTitle: %@", self.navigationItem.backBarButtonItem, self.navigationItem.backBarButtonItem.title);
		
		UIBarButtonItem *channelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info"
																			  style:UIBarButtonItemStyleBordered
																			 target:self
																			 action:@selector(showChannelInfo:)];
		self.navigationItem.rightBarButtonItem = channelButtonItem;
		
		rssTypePicker = [[UISegmentedControl alloc] initWithItems:@[@"BNR",@"Apple"]];
		[rssTypePicker addTarget:self
						  action:@selector(chooseFeedType:)
				forControlEvents:UIControlEventValueChanged];
		rssTypePicker.selectedSegmentIndex = 0;
		rssTypePicker.segmentedControlStyle = UISegmentedControlStyleBar;
		self.navigationItem.titleView = rssTypePicker;
		
		// Kick off the asynchronous data fetch
        [self fetchEntries];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)fetchEntries
{	
	// Initiate a request
	void (^completionBlock)(RSSChannel *, NSError *) = ^(RSSChannel *channel, NSError *error){
		if (!error) {
			self.channel = channel;
			
			[[self tableView] reloadData];
		}
		else {
			[[[UIAlertView alloc] initWithTitle:@"Error"
										message:[error localizedDescription]
									   delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil]
			 show];
		}
	};
	
	if (self.rssType == ListViewControllerRSSTypeBNR) {
		[[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:completionBlock];
	}
	else {
		[[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:completionBlock];
	}
}

- (void)chooseFeedType:(id)sender
{
	if (sender == rssTypePicker) {
		self.rssType = rssTypePicker.selectedSegmentIndex;
		[self fetchEntries];
	}
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
		SplitViewManager *manager = (SplitViewManager *)self.splitViewController.delegate;
		manager.detailViewController = cvc;
	}
	else {
		[self.navigationController pushViewController:cvc animated:YES];
	}
	
	[cvc listViewController:self handleObject:self.channel];
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
	ParseDebug(@"\n\nCOUNT: %d", self.channel.items.count);
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
	RSSItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];

	if (self.splitViewController) {
		SplitViewManager *manager = (SplitViewManager *)self.splitViewController.delegate;
		manager.detailViewController = self.webViewController;
	}
	else {
		[self.navigationController pushViewController:self.webViewController animated:YES];
	}
	
	[self.webViewController listViewController:self handleObject:item];
}

@end
