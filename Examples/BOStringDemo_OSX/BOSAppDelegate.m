//
//  BOSAppDelegate.m
//  BOStringDemo_OSX
//
//  Created by Pavel Mazurin on 12/12/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "BOSAppDelegate.h"
#import "BOStringDemoViewController.h"

@implementation BOSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    BOStringDemoViewController *vc = [[BOStringDemoViewController alloc] init];
    [_window.contentView addSubview:vc.view];
    vc.view.frame = [_window.contentView bounds];
}

@end
