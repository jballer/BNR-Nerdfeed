//
//  BNRConnection.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/16/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface BNRConnection : NSObject  <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
	NSURLConnection *internalConnection;
	NSMutableData *container;
}

- (instancetype)initWithRequest:(NSURLRequest *)request;

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *err);
@property (nonatomic, strong) id <NSXMLParserDelegate> xmlRootObject;
@property (nonatomic, strong) id <JSONSerializable> jsonRootObject;

- (void)start;

@end
