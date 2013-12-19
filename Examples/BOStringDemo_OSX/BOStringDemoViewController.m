//
//  BOStringDemoViewController.m
//  BOStringDemo
//
//  Created by Pavel Mazurin on 12/12/13.
//  Copyright (c) 2013 Pavel Mazurin. All rights reserved.
//

#import "BOStringDemoViewController.h"
#import "BOString.h"

@implementation BOStringDemoViewController

- (id)init
{
    self = [super init];
    
    if (!self)
    {
        return nil;
    }

    return self;
}

- (void) setupLabels
{
    NSTextField *tf1 = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 200, 300, 100)];
    tf1.backgroundColor = [NSColor darkGrayColor];
    tf1.selectable = NO;
    tf1.bezeled = NO;
    tf1.editable = NO;
    [self.view addSubview:tf1];
    tf1.attributedStringValue = [@"Test attributed string" makeString:^(BOStringMaker *make) {
        make.foregroundColor([NSColor greenColor]);
        make.font([NSFont fontWithName:@"Hoefler Text" size:20]);
        
        make.with.range(NSMakeRange(3, 5), ^{
            make.foregroundColor([NSColor redColor]);
            make.font([NSFont fontWithName:@"Times New Roman" size:10]);
            make.ligature(@2);
            make.baselineOffset(@1);
        });
        
        make.with.range(NSMakeRange(6, 9), ^{
            make.foregroundColor([NSColor blueColor]);
            make.font([NSFont fontWithName:@"Times New Roman" size:30]);
        });
        
        make.with.range(NSMakeRange(7, 4), ^{
            make.strikethroughStyle(@(NSUnderlineStyleSingle));
            make.strikethroughColor([NSColor redColor]);
            make.backgroundColor([NSColor yellowColor]);
        });
    }];

    NSTextField *tf2 = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 100)];
    tf2.backgroundColor = [NSColor darkGrayColor];
    tf2.selectable = NO;
    tf2.bezeled = NO;
    tf2.editable = NO;
    [self.view addSubview:tf2];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Test attributed string"
                                                                                         attributes:@{NSForegroundColorAttributeName: [NSColor greenColor]
                                                                                                      , NSFontAttributeName: [NSFont fontWithName:@"Hoefler Text" size:20]}];
    NSMutableDictionary *attributes = [@{NSForegroundColorAttributeName: [NSColor redColor]
                                         , NSFontAttributeName: [NSFont fontWithName:@"Times New Roman" size:10]
                                         , NSLigatureAttributeName: @2} mutableCopy];
    [attributes setObject:@1 forKey:NSBaselineOffsetAttributeName];
    
    [attributedString addAttributes:attributes
                              range:NSMakeRange(3, 5)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: [NSColor blueColor]
                                      , NSFontAttributeName: [NSFont fontWithName:@"Times New Roman" size:30]}
                              range:NSMakeRange(6, 9)];
    attributes = [@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)
                    , NSBackgroundColorAttributeName: [NSColor yellowColor]} mutableCopy];
    [attributes setObject:[NSColor redColor] forKey:NSStrikethroughColorAttributeName];
    
    [attributedString addAttributes:attributes
                              range:NSMakeRange(7, 4)];
    tf2.attributedStringValue = attributedString;
}

@end
