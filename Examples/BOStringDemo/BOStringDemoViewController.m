//
//  BOStringDemoViewController.m
//  BOStringDemo
//
//  Created by Pavel Mazurin on 02/12/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "BOStringDemoViewController.h"
#import "BOString.h"

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedDescending)

@interface BOStringDemoViewController ()

@property (nonatomic, strong) UILabel *attributedTextView;
@property (nonatomic, strong) UILabel *attributedTextView2;

@end

@implementation BOStringDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _attributedTextView = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_attributedTextView];
    _attributedTextView2 = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_attributedTextView2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIFont *fnt = [UIFont fontWithName:@"Hoefler Text" size:15];
    UIFont *fnt2 = [UIFont fontWithName:@"Times New Roman" size:15];
    
    _attributedTextView.frame = CGRectMake(0, 60, 320, 100);
    _attributedTextView.backgroundColor = [UIColor lightGrayColor];
    _attributedTextView2.frame = CGRectMake(0, 200, 320, 100);
    _attributedTextView2.backgroundColor = [UIColor lightGrayColor];

    _attributedTextView.attributedText = [@"Test attributed string" makeString:^(BOStringMaker *make) {
        make.foregroundColor([UIColor greenColor]);
        make.font([fnt fontWithSize:20]);

        make.with.range(NSMakeRange(3, 5), ^{
            make.foregroundColor([UIColor redColor]);
            make.font([fnt2 fontWithSize:10]);
            make.ligature(@2);
            if (IS_IOS7) make.baselineOffset(@1);
        });

        make.with.range(NSMakeRange(6, 9), ^{
            make.foregroundColor([UIColor blueColor]);
            make.font([fnt2 fontWithSize:30]);
        });

        make.with.range(NSMakeRange(7, 4), ^{
            make.strikethroughStyle(@(NSUnderlineStyleSingle));
            if (IS_IOS7) make.strikethroughColor([UIColor redColor]);
            make.backgroundColor([UIColor yellowColor]);
        });
    }];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Test attributed string"
                                                                                         attributes:@{NSForegroundColorAttributeName: [UIColor greenColor]
                                                                                                      , NSFontAttributeName: [fnt fontWithSize:20]}];
    NSMutableDictionary *attributes = [@{NSForegroundColorAttributeName: [UIColor redColor]
        , NSFontAttributeName: [fnt2 fontWithSize:10]
        , NSLigatureAttributeName: @2} mutableCopy];
    if (IS_IOS7) [attributes setObject:@1 forKey:NSBaselineOffsetAttributeName];
    
    [attributedString addAttributes:attributes
                              range:NSMakeRange(3, 5)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor blueColor]
                                      , NSFontAttributeName: [fnt2 fontWithSize:30]}
                              range:NSMakeRange(6, 9)];
    attributes = [@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)
                    , NSBackgroundColorAttributeName: [UIColor yellowColor]} mutableCopy];
    if (IS_IOS7) [attributes setObject:[UIColor redColor] forKey:NSStrikethroughColorAttributeName];

    [attributedString addAttributes:attributes
                              range:NSMakeRange(7, 4)];
    _attributedTextView2.attributedText = attributedString;
}

@end
