//
//  RSSItem.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem

#pragma mark <NSXMLParserDelegate>

/*
 Parse the RSS feed…
 */

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict
{
	NSLog(@"\t\t%@ found a %@ element",self,elementName);
	
	if ([elementName isEqualToString:@"title"]) {
		currentString = [[NSMutableString alloc] init];
		self.title = currentString;
	}
	else if ([elementName isEqualToString:@"link"])
	{
		currentString = [[NSMutableString alloc] init];
		self.link = currentString;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	currentString = nil;
	
	// If that's the end of the channel, pass it back to our parent to close out.
	if ([elementName isEqualToString:@"item"]) {
		[parser setDelegate:self.parentParserDelegate];
	}
}


@end
