//
//  RSSItem.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "RSSItem.h"
#import "RSSChannel.h"

@implementation RSSItem

@synthesize parentParserDelegate;

@dynamic link;
@dynamic title;
@dynamic date;
@dynamic channel;

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
	
	if ([elementName isEqualToString:@"title"] ||
		[elementName isEqualToString:@"link"] ||
		[elementName isEqualToString:@"pubDate"])
	{
		currentString = [[NSMutableString alloc] init];
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
	// If that's the end of the channel, pass it back to our parent to close out.
	if ([elementName isEqualToString:@"item"]) {
		[parser setDelegate:self.parentParserDelegate];
	}
	else if ([elementName isEqualToString:@"title"])
	{
		self.title = currentString;
	}
	else if ([elementName isEqualToString:@"link"])
	{
		self.link = currentString;
	}
	else if ([elementName isEqualToString:@"pubDate"])
	{
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		// Tue, 25 Jun 2013 19:48:41 GMT
		// EEE, d MMM yyyy HH:mm:ss zzz
		[formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
		self.date = [formatter dateFromString:currentString];
		NSLog(@"Current String: %@\nDate Representation: %@", currentString, self.date);
	}
	
	currentString = nil;
}

@end
