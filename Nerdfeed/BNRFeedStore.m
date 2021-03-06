//
//  BNRFeedStore.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/15/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "BNRFeedStore.h"
#import "RSSChannel.h"
#import "BNRConnection.h"

@implementation BNRFeedStore
{
	RSSChannel *channelBNR;
	RSSChannel *channelTopSongs;
}

+ (instancetype)sharedStore
{
	static id _sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[self alloc] init];
	});
	
	return _sharedInstance;
}

- (void)fetchTopSongs:(int)count withCompletion:(void (^)(RSSChannel *, NSError *))completionBlock
{
	if (channelTopSongs) {
		completionBlock(channelTopSongs, nil);
	}
	
	else {
		// Make a request URL
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/us/rss/topsongs/limit=%d/json", count]];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		
		RSSChannel *channel = [NSEntityDescription insertNewObjectForEntityForName:@"RSSChannel" inManagedObjectContext:self.managedObjectContext];
		
		BNRConnection *connection = [[BNRConnection alloc] initWithRequest:request];
		
		connection.completionBlock = completionBlock;
		connection.jsonRootObject = channel;
		[connection start];
		
		channelTopSongs = channel;
	}
}

- (void)fetchRSSFeedWithCompletion:(void (^)(RSSChannel *channel, NSError *error))completionBlock
{
	if (channelBNR) {
		completionBlock(channelBNR, nil);
	}
	
	else {
		// URL
		NSURL *url = [NSURL URLWithString:
					  @"http://forums.bignerdranch.com/smartfeed.php?"
					  @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];

		// Put the URL in a request
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		
		// Create an empty channel
		RSSChannel *channel = [NSEntityDescription insertNewObjectForEntityForName:@"RSSChannel" inManagedObjectContext:self.managedObjectContext];
		
		// Create a connection "actor" object to transfer data from the server
		BNRConnection *connection = [[BNRConnection alloc] initWithRequest:request];
		
		// When the connection is done, call this controller's block
		connection.completionBlock = completionBlock;
		
		// Let the channel pare the data from the web service
		connection.xmlRootObject = channel;

		// Start the connection
		[connection start];
		
		channelBNR = channel;
	}
}

@end
