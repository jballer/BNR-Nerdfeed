//
//  ListViewController.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSSChannel, WebViewController;

typedef enum {
	ListViewControllerRSSTypeBNR,
	ListViewControllerRSSTypeApple
}ListViewControllerRSSType;

@interface ListViewController : UITableViewController <NSURLConnectionDataDelegate, NSXMLParserDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) RSSChannel *channel;
@property ListViewControllerRSSType rssType;

@property (nonatomic, strong) WebViewController *webViewController;

/**
 Connect to forums.bignerdranch.com and get last 20 posts in RSS2.0 format.
 */
- (void)fetchEntries;

@end

@protocol ListViewControllerDelegate

/**
 This method is called when the delegate should present the object passed,
 usually as the result of user selection.
 */
- (void)listViewController:(ListViewController *)lvc handleObject:(id)object;

@end