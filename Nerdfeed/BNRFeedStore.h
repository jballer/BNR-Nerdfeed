//
//  BNRFeedStore.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/15/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSChannel;

@interface BNRFeedStore : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (BNRFeedStore *)sharedStore;

- (void)fetchRSSFeedWithCompletion:(void (^)(RSSChannel *channel, NSError *error))block;

@end
