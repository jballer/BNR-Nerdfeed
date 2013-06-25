//
//  RSSItem.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSSChannel;

@interface RSSItem : NSManagedObject <NSXMLParserDelegate>
{
	NSMutableString *currentString;
}

@property (nonatomic, weak) id<NSXMLParserDelegate> parentParserDelegate;

@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) RSSChannel *channel;

@end