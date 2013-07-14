//
//  ChannelViewController.h
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/12/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "SplitViewManager.h"

@class RSSChannel;

@interface ChannelViewController : UITableViewController <UISplitViewControllerDelegate, ListViewControllerDelegate, ReplaceableDetailViewController>

@end
