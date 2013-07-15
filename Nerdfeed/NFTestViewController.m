//
//  NFTestViewController.m
//  Nerdfeed
//
//  Created by Jonathan Ballerano on 7/14/13.
//  Copyright (c) 2013 jballer. All rights reserved.
//

#import "NFTestViewController.h"
#import "UIViewController+JBSplitViewManager.h"

@interface NFTestViewController ()

@end

@implementation NFTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	self.navigationController.toolbarHidden = NO;
	self.toolbarItems = @[[[UIBarButtonItem alloc] initWithTitle:@"BLAH" style:UIBarButtonItemStyleBordered target:nil action:nil]];
}

#pragma mark JBSplitViewManager
- (BOOL)shouldEmbedInNavController
{
	return YES;
}

@end
