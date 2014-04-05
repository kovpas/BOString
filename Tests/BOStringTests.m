//
//  BOStringTest.m
//  BOStringDemo
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Pavel Mazurin. All rights reserved.
//

#define EXP_SHORTHAND
#define BOS_SHORTHAND

#import "BOString.h"
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#if TARGET_OS_IPHONE
    #define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedDescending)
#else
    #define IS_IOS7 YES
#endif


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
        BOSFont *testFont = [BOSFont boldSystemFontOfSize:12];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.font(testFont);
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:_testString
                                                                                                 attributes:@{NSFontAttributeName: testFont}];
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"paragraphStyle should change", ^{
        NSMutableParagraphStyle *testParagraphStyle = [[NSMutableParagraphStyle alloc] init];
#if TARGET_OS_IPHONE
        testParagraphStyle.alignment = NSTextAlignmentCenter;
#else
        testParagraphStyle.alignment = NSCenterTextAlignment;
#endif
        testParagraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.paragraphStyle(testParagraphStyle);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSParagraphStyleAttributeName: testParagraphStyle}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"foregroundColor should change", ^{
        BOSColor *testColor = [BOSColor redColor];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.foregroundColor(testColor);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSForegroundColorAttributeName: testColor}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"backgroundColor should change", ^{
        BOSColor *testColor = [BOSColor blueColor];
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
        BOSColor *testStrokeColor = [BOSColor redColor];
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
        testShadow.shadowColor = [BOSColor greenColor];
        testShadow.shadowOffset = CGSizeMake(1, 1.5);
        testShadow.shadowBlurRadius = 0.4;
        
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.shadow(testShadow);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSShadowAttributeName: testShadow}];
        
        expect(result).to.equal(testAttributedString);
    });
    
#if TARGET_OS_IPHONE
    it(@"textEffect should change", ^{
        if (!IS_IOS7) return;
        
        NSString *testTextEffect = NSTextEffectLetterpressStyle;
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.textEffect(testTextEffect);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSTextEffectAttributeName: testTextEffect}];
        
        expect(result).to.equal(testAttributedString);
    });
#endif
    
    it(@"attachment should change", ^{
        if (!IS_IOS7) return;
        
        NSTextAttachment *testAttachment = [[NSTextAttachment alloc] init];
#if TARGET_OS_IPHONE
        testAttachment.image = [[UIImage alloc] init];
#endif
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
        
        BOSColor *testUnderlineColor = [BOSColor redColor];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.underlineColor(testUnderlineColor);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSUnderlineColorAttributeName: testUnderlineColor}];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"strikethroughColor should change", ^{
        if (!IS_IOS7) return;
        
        BOSColor *testStrikethroughColor = [BOSColor blueColor];
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
    
    it (@"custom attribute should be added", ^{
        NSNumber *testWritingDirection = @(NSWritingDirectionRightToLeft | NSTextWritingDirectionEmbedding);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.attribute(NSWritingDirectionAttributeName, testWritingDirection);
        }];

        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSWritingDirectionAttributeName: testWritingDirection}];
        
        expect(result).to.equal(testAttributedString);
    });
#if !TARGET_OS_IPHONE
    it( @"superscript should change", ^{
        NSNumber *testSuperscript = @(2);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.superscript(testSuperscript);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSSuperscriptAttributeName: testSuperscript}];
        
        expect(result).to.equal(testAttributedString);
    });

    it( @"cursor should change", ^{
        NSCursor *testCursor = [NSCursor resizeRightCursor];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.cursor(testCursor);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSCursorAttributeName: testCursor}];
        
        expect(result).to.equal(testAttributedString);
    });

    it( @"toolTip should change", ^{
        NSString *testToolTip = @"Test tooltip";
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.toolTip(testToolTip);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSToolTipAttributeName: testToolTip}];
        
        expect(result).to.equal(testAttributedString);
    });

    it( @"characterShape should change", ^{
        NSNumber *testCharacterShape = @(kTraditionalAltTwoSelector);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.characterShape(testCharacterShape);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSCharacterShapeAttributeName: testCharacterShape}];
        
        expect(result).to.equal(testAttributedString);
    });

    it( @"glyphInfo should change", ^{
        NSString* baseString = [NSString stringWithFormat:@"%C", (unichar)0xFFFD];
        NSGlyphInfo* testGlyphInfo = [NSGlyphInfo glyphInfoWithGlyphName:@"copyright"
                                                                 forFont:[NSFont systemFontOfSize:10]
                                                              baseString:baseString];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.glyphInfo(testGlyphInfo);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSGlyphInfoAttributeName: testGlyphInfo}];
        
        expect(result).to.equal(testAttributedString);
    });

    it( @"markedClauseSegment should change", ^{
        NSNumber *testMarkedClauseSegment = @(1);
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.markedClauseSegment(testMarkedClauseSegment);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSMarkedClauseSegmentAttributeName: testMarkedClauseSegment}];
        
        expect(result).to.equal(testAttributedString);
    });

    it( @"textAlternatives should change", ^{
        NSTextAlternatives *testTextAlternatives = [[NSTextAlternatives alloc] initWithPrimaryString:_testString alternativeStrings:@[@"Alternative 1", @"Alternative 2"]];
        NSAttributedString *result = [_testString makeString:^(BOStringMaker *make) {
            make.textAlternatives(testTextAlternatives);
        }];
        
        NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:_testString attributes:@{NSTextAlternativesAttributeName: testTextAlternatives}];
        
        expect(result).to.equal(testAttributedString);
    });

#endif
});

describe(@"Ranged attributes", ^{
    __block BOSFont *testFont;
    __block BOSFont *testFont2;
    __block BOSColor *testColor;
    __block BOSColor *backgroundColor;
    __block BOSColor *backgroundColor2;
    __block NSRange testRange;
    __block NSRange testRange2;
    __block NSRange testRange3;

    beforeAll(^{
        _testString = @"Test string.";
        testFont = [BOSFont boldSystemFontOfSize:12];
        testFont2 = [BOSFont boldSystemFontOfSize:14];
        testColor = [BOSColor greenColor];
        backgroundColor = [BOSColor redColor];
        backgroundColor2 = [BOSColor blueColor];
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
    __block BOSFont *testFont;
    __block BOSColor *testColor;
    __block BOSColor *backgroundColor;
    __block NSRange testRange2;
    __block NSRange testRange3;
    
    beforeAll(^{
        _testString = @"Test string.";
        testFont = [BOSFont boldSystemFontOfSize:12];
        testColor = [BOSColor greenColor];
        backgroundColor = [BOSColor redColor];
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
                make.foregroundColor([BOSColor greenColor]);
            });
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(2, 2)];
        
        expect(result).to.equal(testAttributedString);
    });

    it(@"last instance", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.last.substring(@"is", ^{
                make.foregroundColor([BOSColor greenColor]);
            });
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(5, 2)];
        
        expect(result).to.equal(testAttributedString);
    });

    it(@"all instances", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.each.substring(@"is", ^{
                make.foregroundColor([BOSColor greenColor]);
            });
        }];

        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(2, 2)];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(5, 2)];

        expect(result).to.equal(testAttributedString);
    });

    it(@"first regexp match", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.first.regexpMatch(@"\\wy", 0, ^{ // should highlight `my`
                make.foregroundColor([BOSColor greenColor]);
            });
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(8, 2)];
        
        expect(result).to.equal(testAttributedString);
    });
    
    it(@"last regexp match", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.last.regexpMatch(@"i\\w", 0, ^{ // should highlight `in` in `string`
                make.foregroundColor([BOSColor greenColor]);
            });
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(14, 2)];
        
        expect(result).to.equal(testAttributedString);
    });

    it(@"all regexp matches", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.each.regexpMatch(@"i\\w", 0, ^{ // should highlight `Th_is_ _is_ my str_in_g`
                make.foregroundColor([BOSColor greenColor]);
            });
        }];

        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(2, 2)];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(5, 2)];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(14, 2)];
        
        expect(result).to.equal(testAttributedString);
    });

    it(@"first regexp group", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.first.regexpGroup(@"(i\\w)\\s", 0, ^{ // should highlight `Th_is_ is my string`
                make.foregroundColor([BOSColor greenColor]);
            });
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(2, 2)];
        
        expect(result).to.equal(testAttributedString);
    });

    it(@"last regexp group", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.last.regexpGroup(@"(i\\w)\\s", 0, ^{ // should highlight `This _is_ my string`
                make.foregroundColor([BOSColor greenColor]);
            });
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(5, 2)];
        
        expect(result).to.equal(testAttributedString);
    });

    it(@"first regexp multiple groups", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.first.regexpGroup(@"(\\w{2})\\s(\\w{2})", 0, ^{ // should highlight `Th_is_ _is_ my string`
                make.foregroundColor([BOSColor greenColor]);
            });
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(2, 2)];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(5, 2)];
        
        expect(result).to.equal(testAttributedString);
    });

    it(@"last regexp multiple groups", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.last.regexpGroup(@"(\\w{2})\\s(\\w{2})", 0, ^{ // should highlight `This is _my_ _st_ring`
                make.foregroundColor([BOSColor greenColor]);
            });
        }];
        
        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(8, 2)];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(11, 2)];
        
        expect(result).to.equal(testAttributedString);
    });

    it(@"all regexp groups", ^{
        NSAttributedString *result = [testString makeString:^(BOStringMaker *make) {
            make.each.regexpGroup(@"[^h](i\\w)", 0, ^{ // should highlight `This _is_ my str_in_g`
                make.foregroundColor([BOSColor greenColor]);
            });
        }];

        NSMutableAttributedString *testAttributedString = [[NSMutableAttributedString alloc] initWithString:testString];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(5, 2)];
        [testAttributedString addAttribute:NSForegroundColorAttributeName value:[BOSColor greenColor] range:NSMakeRange(14, 2)];

        expect(result).to.equal(testAttributedString);
    });
});
SpecEnd

