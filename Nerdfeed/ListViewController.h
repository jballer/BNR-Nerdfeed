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

@interface ListViewController : UITableViewController
<NSURLConnectionDataDelegate, NSXMLParserDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *xmlData;

@property (nonatomic, strong) RSSChannel *channel;

@property (nonatomic, strong) WebViewController *webViewController;

/**
 Connect to forums.bignerdranch.com and get last 20 posts in RSS2.0 format.
 */
- (void)fetchEntries;

@end
