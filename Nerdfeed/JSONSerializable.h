//
//  JSONSerializable.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/17/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONSerializable <NSObject>

- (void)readFromJSONDictionary:(NSDictionary *)dictionary;

@end
