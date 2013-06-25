//
//  ListViewController.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSChannel, WebViewController;

@interface ListViewController : UITableViewController <NSURLConnectionDataDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *xmlData;

@property (nonatomic, strong) RSSChannel *channel;

@property (nonatomic, strong) WebViewController *webViewController;

- (void)fetchEntries;

@end
