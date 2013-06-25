//
//  ListViewController.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListViewController : UITableViewController <NSURLConnectionDataDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *xmlData;

- (void)fetchEntries;

@end
