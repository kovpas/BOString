//
//  BOStringTest.m
//  BOStringDemo
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BOString.h"

@interface BOStringTest : XCTestCase

@property (nonatomic, copy) NSString *testString;

@end

@implementation BOStringTest

- (void)setUp
{
    _testString = @"Test string.";
}

- (void)testEmptyString
{
    NSAttributedString *result = [@"" makeString:nil];
    
    XCTAssertNotNil(result, @"Expected non-nil string");
    XCTAssertEqualObjects(result, [[NSAttributedString  alloc] init], @"Expected empty object");
}

- (void)testStringWithoutAttributes
{
    NSAttributedString *result = [_testString makeString:nil];
    
    XCTAssertEqualObjects(result, [[NSAttributedString  alloc] initWithString:_testString], @"Expected %@", _testString);
}

- (void)testFontAttribute
{
    UIFont *testFont = [UIFont boldSystemFontOfSize:12];
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.font(testFont);
    }];
    
    NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:_testString
                                                                                             attributes:@{NSFontAttributeName: testFont}];
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testParagraphStyleAttribute
{
    NSMutableParagraphStyle *testParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    testParagraphStyle.alignment = NSTextAlignmentCenter;
    testParagraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.paragraphStyle(testParagraphStyle);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSParagraphStyleAttributeName: testParagraphStyle}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testForegroundColorAttribute
{
    UIColor *testColor = [UIColor redColor];
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.foregroundColor(testColor);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSForegroundColorAttributeName: testColor}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testBackgroundColorAttribute
{
    UIColor *testColor = [UIColor blueColor];
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.backgroundColor(testColor);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSBackgroundColorAttributeName: testColor}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testLigatureAttribute
{
    NSNumber *testLigature = @0.3;
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.ligature(testLigature);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSLigatureAttributeName: testLigature}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testKernAttribute
{
    NSNumber *testKern = @2.5;
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.kern(testKern);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSKernAttributeName: testKern}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testStrikethroughStyleAttribute
{
    NSNumber *testStrikethroughStyle = @(NSUnderlineStyleDouble);
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.strikethroughStyle(testStrikethroughStyle);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSStrikethroughStyleAttributeName: testStrikethroughStyle}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testUnderlineStyleAttribute
{
    NSNumber *testUnderlineStyle = @(NSUnderlineStyleDouble);
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.underlineStyle(testUnderlineStyle);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSUnderlineStyleAttributeName: testUnderlineStyle}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

-(void)testStrokeColorAttribute
{
    UIColor *testStrokeColor = [UIColor redColor];
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.strokeColor(testStrokeColor);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSStrokeColorAttributeName: testStrokeColor}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

-(void)testStrokeWidthAttribute
{
    NSNumber *testStrokeWidth = @(2);
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.strokeWidth(testStrokeWidth);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSStrokeWidthAttributeName: testStrokeWidth}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

-(void)testShadowAttribute
{
    NSShadow *testShadow = [[NSShadow alloc] init];
    testShadow.shadowColor = [UIColor greenColor];
    testShadow.shadowOffset = CGSizeMake(1, 1.5);
    testShadow.shadowBlurRadius = 0.4;
    
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.shadow(testShadow);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSShadowAttributeName: testShadow}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

-(void)testTextEffectAttribute
{
    NSString *testTextEffect = NSTextEffectLetterpressStyle;
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.textEffect(testTextEffect);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSTextEffectAttributeName: testTextEffect}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}


-(void)testAttachmentAttribute
{
    NSTextAttachment *testAttachment = [[NSTextAttachment alloc] init];
    testAttachment.image = [[UIImage alloc] init];
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.attachment(testAttachment);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSAttachmentAttributeName: testAttachment}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

-(void)testLinkAttribute
{
    NSString *testLink = @"http://google.com";
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.link(testLink);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSLinkAttributeName: testLink}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);

    NSURL *testurl = [NSURL URLWithString:@"http://google.com"];
    result = [_testString makeString:^(BOStringMaker *make) {
        make.link(testurl);
    }];
    
    testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSLinkAttributeName: testurl}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

-(void)testBaselineOffsetAttribute
{
    NSNumber *testBaselineOffset = @(1.2);
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.baselineOffset(testBaselineOffset);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSBaselineOffsetAttributeName: testBaselineOffset}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

-(void)testUnderlineColorAttribute
{
    UIColor *testUnderlineColor = [UIColor redColor];
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.underlineColor(testUnderlineColor);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSUnderlineColorAttributeName: testUnderlineColor}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

-(void)testStrikethroughColorAttribute
{
    UIColor *testStrikethroughColor = [UIColor blueColor];
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.strikethroughColor(testStrikethroughColor);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSStrikethroughColorAttributeName: testStrikethroughColor}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

-(void)testObliquenessAttribute
{
    NSNumber *testObliqueness = @(-0.4);
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.obliqueness(testObliqueness);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSObliquenessAttributeName: testObliqueness}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

-(void)testExpansionAttribute
{
    NSNumber *testExpansion = @(0.3);
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.expansion(testExpansion);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSExpansionAttributeName: testExpansion}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}


-(void)testWritingDirectionAttribute
{
    NSNumber *testWritingDirection = @(NSWritingDirectionRightToLeft | NSTextWritingDirectionEmbedding);
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.writingDirection(testWritingDirection);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSWritingDirectionAttributeName: testWritingDirection}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}


-(void)testVerticalGlyphFormAttribute
{
    NSNumber *testVerticalGlyphForm = @(1);
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.verticalGlyphForm(testVerticalGlyphForm);
    }];
    
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSVerticalGlyphFormAttributeName: testVerticalGlyphForm}];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}


- (void)testRangedAttributes
{
    UIFont *testFont = [UIFont boldSystemFontOfSize:12];
    UIColor *testColor = [UIColor greenColor];
    UIColor *backgroundColor = [UIColor redColor];
    NSRange testRange = NSMakeRange(1, 4);
    NSRange testRange2 = NSMakeRange(7, 4);
    NSRange testRange3 = NSMakeRange(1, 5);
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.font(testFont).with.range(testRange);
        make.foregroundColor(testColor).with.range(testRange2);
        make.backgroundColor(backgroundColor).range(testRange3);
    }];
    
    NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:_testString];
    XCTAssertNotEqualObjects(result, testAttributedString, @"Expected %@", _testString);
    
    [testAttributedString addAttribute:NSFontAttributeName value:testFont range:testRange];
    XCTAssertNotEqualObjects(result, testAttributedString, @"Expected %@", _testString);

    [testAttributedString addAttribute:NSForegroundColorAttributeName value:testColor range:testRange2];
    XCTAssertNotEqualObjects(result, testAttributedString, @"Expected %@", _testString);

    [testAttributedString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:testRange3];
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testStringRange
{
    UIFont *testFont = [UIFont boldSystemFontOfSize:12];
    UIColor *testColor = [UIColor greenColor];
    UIColor *backgroundColor = [UIColor redColor];
    NSRange testRange2 = NSMakeRange(7, 4);
    NSRange testRange3 = NSMakeRange(1, 5);
    NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
        make.font(testFont).with.stringRange();
        make.foregroundColor(testColor).with.range(testRange2);
        make.backgroundColor(backgroundColor).range(testRange3);
    }];
    
    NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:_testString attributes:@{NSFontAttributeName: testFont}];
    XCTAssertNotEqualObjects(result, testAttributedString, @"Expected %@", _testString);
    
    [testAttributedString addAttribute:NSForegroundColorAttributeName value:testColor range:testRange2];
    XCTAssertNotEqualObjects(result, testAttributedString, @"Expected %@", _testString);
    
    [testAttributedString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:testRange3];
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testWithRange
{
    UIFont *testFont = [UIFont boldSystemFontOfSize:12];
    UIFont *testFont2 = [UIFont boldSystemFontOfSize:14];
    UIColor *testColor = [UIColor greenColor];
    UIColor *backgroundColor = [UIColor redColor];
    UIColor *backgroundColor2 = [UIColor redColor];
    NSRange testRange2 = NSMakeRange(7, 4);
    NSRange testRange3 = NSMakeRange(1, 5);
    
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
    XCTAssertNotEqualObjects(result, testAttributedString, @"Expected %@", _testString);

    [testAttributedString addAttributes:@{NSBackgroundColorAttributeName: backgroundColor
                                          , NSFontAttributeName: testFont}
                                  range:testRange2];
    XCTAssertNotEqualObjects(result, testAttributedString, @"Expected %@", _testString);
    
    [testAttributedString addAttributes:@{NSBackgroundColorAttributeName: backgroundColor
                                          , NSFontAttributeName: testFont2}
                                  range:testRange3];
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testAttributedString
{
    UIFont *testFont = [UIFont boldSystemFontOfSize:12];
    UIColor *testColor = [UIColor greenColor];
    UIColor *backgroundColor = [UIColor redColor];
    NSRange testRange2 = NSMakeRange(7, 4);
    NSRange testRange3 = NSMakeRange(1, 5);
    NSAttributedString *testString = [[NSAttributedString alloc] initWithString:_testString
                                                             attributes:@{NSFontAttributeName: testFont}];
    NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
        make.foregroundColor(testColor).with.range(testRange2);
        make.backgroundColor(backgroundColor).range(testRange3);
    }];
    
    NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:_testString attributes:@{NSFontAttributeName: testFont}];
    XCTAssertNotEqualObjects(result, testAttributedString, @"Expected %@", _testString);
    
    [testAttributedString addAttribute:NSForegroundColorAttributeName value:testColor range:testRange2];
    XCTAssertNotEqualObjects(result, testAttributedString, @"Expected %@", _testString);
    
    [testAttributedString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:testRange3];
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testFirstSubstring
{
    NSString *testString = @"This is my string";
    NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
        make.first.substring(@"is", ^{
            make.foregroundColor([UIColor greenColor]);
        });
    }];
    
    NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
    [testAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(2, 2)];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

- (void)testEachSubstring
{
    NSString *testString = @"This is my string";
    NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
        make.each.substring(@"is", ^{
            make.foregroundColor([UIColor greenColor]);
        });
    }];
    
    NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
    [testAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(2, 2)];
    [testAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(5, 2)];
    
    XCTAssertEqualObjects(result, testAttributedString, @"Expected %@", _testString);
}

@end
