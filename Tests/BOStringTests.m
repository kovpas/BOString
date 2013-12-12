//
//  BOStringTest.m
//  BOStringDemo
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BOString.h"
#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedDescending)

SpecBegin(BOString)

__block NSString *_testString;

describe(@"Basic", ^{
    beforeAll(^{
        _testString = @"Test string.";
    });
    
    it(@"empty string should be initialized", ^{
        NSAttributedString *result = [@"" makeString:nil];
        expect(result).to.equal([[NSAttributedString alloc] init]);
    });
    
    it(@"string without attributes should be initialized", ^{
        NSAttributedString *result = [_testString makeString:nil];
        expect(result).to.equal([[NSAttributedString alloc] initWithString:_testString]);
    });
});

describe(@"Attribute", ^{
    beforeAll(^{
        _testString = @"Test string.";
    });
    
    it(@"font should change", ^{
        UIFont *testFont = [UIFont boldSystemFontOfSize:12];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.font(testFont);
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:_testString
                                                                                                 attributes:@{NSFontAttributeName: testFont}];
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"paragraphStyle should change", ^{
        NSMutableParagraphStyle *testParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        testParagraphStyle.alignment = NSTextAlignmentCenter;
        testParagraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.paragraphStyle(testParagraphStyle);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSParagraphStyleAttributeName: testParagraphStyle}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"foregroundColor should change", ^{
        UIColor *testColor = [UIColor redColor];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.foregroundColor(testColor);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSForegroundColorAttributeName: testColor}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"backgroundColor should change", ^{
        UIColor *testColor = [UIColor blueColor];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.backgroundColor(testColor);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSBackgroundColorAttributeName: testColor}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"ligature should change", ^{
        NSNumber *testLigature = @0.3;
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.ligature(testLigature);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSLigatureAttributeName: testLigature}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"kern should change", ^{
        NSNumber *testKern = @2.5;
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.kern(testKern);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSKernAttributeName: testKern}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"strikethroughStyle should change", ^{
        NSNumber *testStrikethroughStyle = @(NSUnderlineStyleDouble);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.strikethroughStyle(testStrikethroughStyle);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSStrikethroughStyleAttributeName: testStrikethroughStyle}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"underlineStyle should change", ^{
        NSNumber *testUnderlineStyle = @(NSUnderlineStyleDouble);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.underlineStyle(testUnderlineStyle);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSUnderlineStyleAttributeName: testUnderlineStyle}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"strokeColor should change", ^{
        UIColor *testStrokeColor = [UIColor redColor];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.strokeColor(testStrokeColor);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSStrokeColorAttributeName: testStrokeColor}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"strokeWidth should change", ^{
        NSNumber *testStrokeWidth = @(2);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.strokeWidth(testStrokeWidth);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSStrokeWidthAttributeName: testStrokeWidth}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"shadow should change", ^{
        NSShadow *testShadow = [[NSShadow alloc] init];
        testShadow.shadowColor = [UIColor greenColor];
        testShadow.shadowOffset = CGSizeMake(1, 1.5);
        testShadow.shadowBlurRadius = 0.4;
        
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.shadow(testShadow);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSShadowAttributeName: testShadow}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"textEffect should change", ^{
        if (!IS_IOS7) return;
        
        NSString *testTextEffect = NSTextEffectLetterpressStyle;
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.textEffect(testTextEffect);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSTextEffectAttributeName: testTextEffect}];
        
        expect(result).to.equal(testAttributedString);
    }
       );
    
    it(@"attachment should change", ^{
        if (!IS_IOS7) return;
        
        NSTextAttachment *testAttachment = [[NSTextAttachment alloc] init];
        testAttachment.image = [[UIImage alloc] init];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.attachment(testAttachment);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSAttachmentAttributeName: testAttachment}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"link should change", ^{
        if (!IS_IOS7) return;
        
        NSString *testLink = @"http://google.com";
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.link(testLink);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSLinkAttributeName: testLink}];
        
        expect(result).to.equal(testAttributedString);
        
        NSURL *testurl = [NSURL URLWithString:@"http://google.com"];
        result = [_testString makeString:^(BOStringMaker *make) {
            make.link(testurl);
        }];
        
        testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSLinkAttributeName: testurl}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"baselineOffset should change", ^{
        if (!IS_IOS7) return;
        
        NSNumber *testBaselineOffset = @(1.2);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.baselineOffset(testBaselineOffset);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSBaselineOffsetAttributeName: testBaselineOffset}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"underlineColor should change", ^{
        if (!IS_IOS7) return;
        
        UIColor *testUnderlineColor = [UIColor redColor];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.underlineColor(testUnderlineColor);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSUnderlineColorAttributeName: testUnderlineColor}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"strikethroughColor should change", ^{
        if (!IS_IOS7) return;
        
        UIColor *testStrikethroughColor = [UIColor blueColor];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.strikethroughColor(testStrikethroughColor);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSStrikethroughColorAttributeName: testStrikethroughColor}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"obliqueness should change", ^{
        if (!IS_IOS7) return;
        
        NSNumber *testObliqueness = @(-0.4);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.obliqueness(testObliqueness);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSObliquenessAttributeName: testObliqueness}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"expansion should change", ^{
        if (!IS_IOS7) return;
        
        NSNumber *testExpansion = @(0.3);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.expansion(testExpansion);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSExpansionAttributeName: testExpansion}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"writingDirection should change", ^{
        if (!IS_IOS7) return;
        
        NSNumber *testWritingDirection = @(NSWritingDirectionRightToLeft | NSTextWritingDirectionEmbedding);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.writingDirection(testWritingDirection);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSWritingDirectionAttributeName: testWritingDirection}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"verticalGlyphForm should change", ^{
        NSNumber *testVerticalGlyphForm = @(1);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.verticalGlyphForm(testVerticalGlyphForm);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSVerticalGlyphFormAttributeName: testVerticalGlyphForm}];
        
        expect(result).to.equal(testAttributedString);
    });
});

describe(@"Ranged attributes", ^{
    __block UIFont *testFont;
    __block UIFont *testFont2;
    __block UIColor *testColor;
    __block UIColor *backgroundColor;
    __block UIColor *backgroundColor2;
    __block NSRange testRange;
    __block NSRange testRange2;
    __block NSRange testRange3;

    beforeAll(^{
        _testString = @"Test string.";
        testFont = [UIFont boldSystemFontOfSize:12];
        testFont2 = [UIFont boldSystemFontOfSize:14];
        testColor = [UIColor greenColor];
        backgroundColor = [UIColor redColor];
        backgroundColor2 = [UIColor blueColor];
        testRange = NSMakeRange(1, 4);
        testRange2 = NSMakeRange(7, 4);
        testRange3 = NSMakeRange(1, 5);
    });

    it(@"should be set", ^{
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.font(testFont).with.range(testRange);
            make.foregroundColor(testColor).with.range(testRange2);
            make.backgroundColor(backgroundColor).range(testRange3);
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:_testString];
        expect(result).notTo.equal(testAttributedString);
        
        [testAttributedString addAttribute:NSFontAttributeName value:testFont range:testRange];
        expect(result).notTo.equal(testAttributedString);
        
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:testColor range:testRange2];
        expect(result).notTo.equal(testAttributedString);
        
        [testAttributedString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:testRange3];
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"should be set for whole string", ^{
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.font(testFont).with.stringRange();
            make.foregroundColor(testColor).with.range(testRange2);
            make.backgroundColor(backgroundColor).range(testRange3);
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:_testString attributes:@{NSFontAttributeName: testFont}];
        expect(result).notTo.equal(testAttributedString);
        
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:testColor range:testRange2];
        expect(result).notTo.equal(testAttributedString);
        
        [testAttributedString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:testRange3];
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"should be set when using withRange", ^{
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.with.stringRange(^{
                make.foregroundColor(testColor);
            });
            
            make.with.range(testRange2, ^{
                make.font(testFont);
                make.backgroundColor(backgroundColor);
            });
            
            make.with.range(testRange3, ^{
                make.font(testFont2);
                make.backgroundColor(backgroundColor2);
            });
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:_testString attributes:@{NSForegroundColorAttributeName: testColor}];
        expect(result).notTo.equal(testAttributedString);
        
        [testAttributedString addAttributes:@{NSBackgroundColorAttributeName: backgroundColor
                                              , NSFontAttributeName: testFont}
                                      range:testRange2];
        expect(result).notTo.equal(testAttributedString);
        
        [testAttributedString addAttributes:@{NSBackgroundColorAttributeName: backgroundColor2
                                              , NSFontAttributeName: testFont2}
                                      range:testRange3];
        expect(result).to.equal(testAttributedString);
    });
});

describe(@"Attributed string", ^{
    __block UIFont *testFont;
    __block UIColor *testColor;
    __block UIColor *backgroundColor;
    __block NSRange testRange2;
    __block NSRange testRange3;
    
    beforeAll(^{
        _testString = @"Test string.";
        testFont = [UIFont boldSystemFontOfSize:12];
        testColor = [UIColor greenColor];
        backgroundColor = [UIColor redColor];
        testRange2 = NSMakeRange(7, 4);
        testRange3 = NSMakeRange(1, 5);
    });
    
    it(@"should be created", ^{
        NSAttributedString *testString = [[NSAttributedString alloc] initWithString:_testString
                                                                         attributes:@{NSFontAttributeName: testFont}];
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.foregroundColor(testColor).with.range(testRange2);
            make.backgroundColor(backgroundColor).range(testRange3);
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:_testString attributes:@{NSFontAttributeName: testFont}];
        expect(result).notTo.equal(testAttributedString);
        
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:testColor range:testRange2];
        expect(result).notTo.equal(testAttributedString);
        
        [testAttributedString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:testRange3];
        expect(result).to.equal(testAttributedString);
    });
});

describe(@"Substring should highlight", ^{
    __block NSString *testString;
    beforeAll(^{
        testString = @"This is my string";
    });
    it(@"first instance", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.first.substring(@"is", ^{
                make.foregroundColor([UIColor greenColor]);
            });
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(2, 2)];
        
        expect(result).to.equal(testAttributedString);
    });
    it(@"all instances", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.each.substring(@"is", ^{
                make.foregroundColor([UIColor greenColor]);
            });
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(2, 2)];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(5, 2)];
        
        expect(result).to.equal(testAttributedString);
    });
});
SpecEnd

