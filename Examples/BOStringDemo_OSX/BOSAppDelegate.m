//
//  BOSAppDelegate.m
//  BOStringDemo_OSX
//
//  Created by Pavel Mazurin on 12/12/13.
//  Copyright (c) 2013 Pavel Mazurin. All rights reserved.
//

#import "BOSAppDelegate.h"
#import "BOStringDemoViewController.h"

@implementation BOSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    BOStringDemoViewController *vc = [[BOStringDemoViewController alloc] init];
    NSView *v = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 200, 400)];
    vc.view = v;
    [_window.contentView addSubview:vc.view];
    vc.view.frame = [_window.contentView bounds];
    [vc setupLabels];
}

@end
