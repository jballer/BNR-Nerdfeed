//
//  BNRConnection.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/16/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "BNRConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation BNRConnection

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)start
{
	// Initialize container for data from connection
	container = [NSMutableData new];
	
	// Spawn a connection
	internalConnection = [[NSURLConnection alloc] initWithRequest:self.request
														 delegate:self
												 startImmediately:YES];
	
	MyLog(@"Creating Shared Connection List?");
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedConnectionList = [[NSMutableArray alloc] init];
		MyLog(@"Created Shared Connection List.");
	});
	
	[sharedConnectionList addObject:self];
}

#pragma mark <NSURLConnectionDataDelegate>

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// Add the incoming data to the container.
	// (It's always in the right order)
	[container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
	if (self.xmlRootObject) {
		// Make a parser with the data contents, and pass it to the parser
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:container];
		ParseDebug(@"XML Received from\n\n<   %@   >\n\n%@",conn.currentRequest.URL,[[NSString alloc] initWithData:container encoding:NSUTF8StringEncoding]);

		parser.delegate = self.xmlRootObject;
		[parser parse];
	}
	
	// Execute the completion block, supplying the root object
	if ([self completionBlock]) {
		[self completionBlock](self.xmlRootObject, nil);
	}
	
	// Detroy the connection
	[sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Execute block with the error
	if (self.completionBlock) {
		self.completionBlock(nil,error);
	}
	
	// Destroy this connection
	[sharedConnectionList removeObject:self];
}

@end
