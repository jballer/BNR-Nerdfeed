//
//  ChannelViewController.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/12/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "ChannelViewController.h"
#import "RSSChannel.h"

@interface ChannelViewController ()

@property (nonatomic, retain) RSSChannel *channel;
@property (nonatomic, retain) NSDictionary *cellContents;

@end

@interface RSSChannelCell : UITableViewCell

@end

@implementation ChannelViewController

static NSString *kChannelCellIdentifier = @"ChannelInfoCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _cellContents = [NSDictionary new];
    }
    return self;
}

#pragma mark Accessors

/**
 This is where the logic resides for determining what cells we display and in what order.
 */
- (void)setChannel:(RSSChannel *)channel
{
	self.cellContents = @{@"Title":channel.title,
						  @"Info":channel.infoString};
	_channel = channel;
}

- (void)setCellContents:(NSDictionary *)cellContents
{
	NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:_cellContents];
	for (id key in cellContents) {
		id obj = [cellContents objectForKey:key];
		if ([obj isKindOfClass:[NSString class]]) { // Sanitize… we only want strings here
			[temp setObject:obj forKey:key];
		}
	}
	
	_cellContents = [NSDictionary dictionaryWithDictionary:temp];
}

#pragma mark - List View Controller Delegate

- (void)listViewController:(ListViewController *)lvc handleObject:(id)object
{
	if ([object isKindOfClass:[RSSChannel class]]) {
		self.channel = object;
	}
}

#pragma mark - Table View Delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChannelCellIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
									  reuseIdentifier:kChannelCellIdentifier];
	}
	
    // Configure the cell...
	if (indexPath.section == 0) {
		NSString *key = self.cellContents.allKeys[indexPath.row];
		cell.textLabel.text = [key description];
		cell.detailTextLabel.text = self.cellContents[key];
	}
    return cell;
}

@end

#pragma mark - UITableViewCell Subclass

@implementation RSSChannelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}

@end