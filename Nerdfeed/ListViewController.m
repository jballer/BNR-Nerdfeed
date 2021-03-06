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
			
			self.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"channel == %@", self.channel];
			
			NSError *err = [NSError new];
			[self.fetchedResultsController performFetch:&err];
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

		[self logNumberOfChannelsAndItems];
	};
	
	if (ListViewControllerRSSTypeBNR == self.rssType) {
		[[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:completionBlock];
	}
	else if (ListViewControllerRSSTypeApple == self.rssType) {
		[[BNRFeedStore sharedStore] fetchTopSongs:15 withCompletion:completionBlock];
	}
}

- (void)logNumberOfChannelsAndItems
{
	static NSFetchRequest *channelsRequest;
	static NSFetchRequest *itemsRequest;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		channelsRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSChannel"];
		channelsRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO]];
		
		itemsRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSItem"];
		itemsRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO]];
	});
	
	NSError *err = [NSError new];
	NSArray *channels = [self.managedObjectContext executeFetchRequest:channelsRequest error:&err];
	NSArray *items = [self.managedObjectContext executeFetchRequest:itemsRequest error:&err];
	NSLog(@"%d Items in %d Channels", items.count, channels.count);
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
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channel == %@", self.channel];
	request.predicate = predicate;
	
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
	request.sortDescriptors = @[descriptor];
	
	_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
	_fetchedResultsController.delegate = self;
	
	NSError *error = [NSError new];
	[_fetchedResultsController performFetch:&error];
	
	return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
    UITableView *tableView = self.tableView;
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	// Empty implementation sufficient for change tracking
	NSLog(@"Fetched Results Controller Changed.");

	[self.tableView endUpdates];
}

#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	ParseDebug(@"\n\nCOUNT: %d", self.channel.items.count);
	
	id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
	return [sectionInfo numberOfObjects];
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
