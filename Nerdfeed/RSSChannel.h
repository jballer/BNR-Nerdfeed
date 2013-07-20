//
//  RSSChannel.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JSONSerializable.h"

@interface RSSChannel : NSManagedObject <NSXMLParserDelegate, JSONSerializable>

@property (nonatomic, weak) id<NSXMLParserDelegate> parentParserDelegate;

@property (nonatomic, retain) NSString * infoString;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *items;
@end

@interface RSSChannel (CoreDataGeneratedAccessors)

- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItemsObject:(NSManagedObject *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)trimItemTitles;

@end
