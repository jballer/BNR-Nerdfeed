//
//  RSSChannel.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 6/25/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSItem.h"

@interface RSSChannel ()
{
	NSMutableString *currentString;
}
@end

@implementation RSSChannel

@synthesize parentParserDelegate;

@dynamic infoString;
@dynamic title;
@dynamic items;

#pragma mark Regular Expressions
- (void)trimItemTitles
{
	// Make a regex with pattern: 'Author'
	NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@".* :: .* :: .*"
																		 options:0 error:nil];
	
	[self.items enumerateObjectsUsingBlock:^(id obj, BOOL *stop){

		// Check for match
		RSSItem *item = (RSSItem *)obj;
		NSString *itemTitle = item.title;
		NSArray *matches = [reg matchesInString:itemTitle options:0 range:NSMakeRange(0, itemTitle.length)];
		
		// Print it out for debugging
		if (matches.count) {
			NSTextCheckingResult *result = matches.firstObject;
			NSRange range = result.range;
			MyLog(@"Match at {%d, %d} for %@!", range.location, range.length, itemTitle);
		}
	}];
}

#pragma mark <NSXMLParserDelegate>

/*
 Parse the RSS feed…
 */

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict
{
	ParseDebug(@"\t%@ found a %@ element",self,elementName);
	
	/*
	 I got stuck here because my title and infoString properties
	 were 'copy' - so the default setter was making immutable copies
	 and they weren't updating with the append.
	 */
	
	if ([elementName isEqualToString:@"title"]) {
		currentString = [[NSMutableString alloc] init];
		self.title = currentString;
	}
	else if ([elementName isEqualToString:@"description"])
	{
		currentString = [[NSMutableString alloc] init];
		self.infoString = currentString;
	}
	else if ([elementName isEqualToString:@"item"])
	{
		RSSItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"RSSItem" inManagedObjectContext:self.managedObjectContext];
		item.parentParserDelegate = self;
		
		[parser setDelegate:item];
		
		[self addItemsObject:item];
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
	if ([elementName isEqualToString:@"channel"]) {
		[parser setDelegate:self.parentParserDelegate];
		[self trimItemTitles];
		ParseDebug(@"\n %@", self.items);
	}
}

/*
#pragma mark CoreDataGeneratedAccessors
- (void)addItemsObject:(NSManagedObject *)value
{
	
}

- (void)removeItemsObject:(NSManagedObject *)value
{
	
}

- (void)addItems:(NSSet *)values
{
	
}

- (void)removeItems:(NSSet *)values
{
	
}
*/

@end
