//
//  BOStringMaker.h
//  BOStringDemo
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BOStringAttribute;

#if TARGET_OS_IPHONE
    #define BOSColor UIColor
    #define BOSFont UIFont
#else
    #define BOSColor NSColor
    #define BOSFont NSFont
#endif

/**
 *  This class "resolves" maker block.
 *  Maker block is a list of instructions how to create an `NSAttributedString`.
 *
 *  Example:
 *  @code
 *  NSAttributedString *result = [@"string" makeString:^(BOStringMaker *make) {
 *      make.font([UIFont systemFontOfSize:12]).with.stringRange();
 *      make.foregroundColor([UIColor greenColor]).with.range(NSMakeRange(0, 5));
 *      make.backgroundColor([UIColor blueColor]).range(NSMakeRange(0, 3));
 *  }];
 *  @endcode
 
 *  Attributes are stored as `BOStringAttribute` objects in the internal array.
 *  After all attributes are processed, `makeString` method resolves collisions
 *  with the following algorithm:
 *
 *  - it maps array of `BOStringAttribute` objects into a dictionary:  
 *  @code
 *  @{NSRange => @[@{attribute name => attribute value}, ...], ...}
 *  @endcode
 *      in this example `attribute name` is an NSAttributedString attribute name
 *      i.e. NSFontAttributeName, `attribute value` is it's value, i.e. UIFont
 *      instance.
 *
 *  - it sorts all the attributes by their NSRanges, so that ranges with the
 *      same start indexes and longer length have priority over the ones with a
 *      shorter range.
 *
 *  - it applies all attributes with 
 *      [NSMutableAttributedString addAttributes:range:]` method.
 *
 *  With this algorithm attributes are applied from left to right, so in case if
 *  you write something like:
 *  @code
 *  make.foregroundColor([UIColor blueColor]).range(NSMakeRange(1, 2));
 *  make.foregroundColor([UIColor redColor]).stringRange();
 *  @endcode
 *  it makes sure that `redColor` will be applied first and `blueColor` second.
 */
@interface BOStringMaker : NSObject

/**
 *  Returns a `BOStringMaker` instance, initialized with an attributed string.
 *
 *  @param string Initial attributed string.
 *
 *  @return `BOStringMaker` instance, initialized with an attributed string.
 */
- (instancetype)initWithAttributedString:(NSAttributedString *)string;

/**
 *  Returns a `BOStringMaker` instance, initialized with a string.
 *
 *  @param string Initial string.
 *
 *  @return `BOStringMaker` instance, initialized with a string.
 */
- (instancetype)initWithString:(NSString *)string;

/**
 *  Returns `NSAttributedString` instance.
 *
 *  @return `NSAttributedString` instance, created with initial attributes (in
 *  case if `BOStringMaker` instance was created with initWithAttributedString:
 *  method) and attributes assigned with the methods below.
 */
- (NSAttributedString *)makeString;

/**
 *  Semantic filler. Returns `self`, so effectively, does nothing.
 *
 *  @return `self`.
 */
- (instancetype)with;

/**
 *  Returns a block, which should contain attributes that are set for the range,
 *  passed to that block.
 *
 *  Example:
 *  @code
 *  NSAttributedString *result = [@"string" makeString:^(BOStringMaker *make) {
 *      make.with.range(NSMakeRange(0, 5), ^{
 *          make.font([UIFont systemFontOfSize:12]);
 *          make.foregroundColor([UIColor greenColor]);
 *          make.backgroundColor([UIColor blueColor]);
 *      });
 *  }];
 *  @endcode
 *  All three attributes above will be applied for the range `(0, 5)`.
 */
- (void(^)(NSRange, void (^)(void)))range;

/**
 *  Returns a block, which should contain attributes that are set for the entire
 *  string.
 *
 *  Example:
 *  @code
 *  NSAttributedString *result = [@"string" makeString:^(BOStringMaker *make) {
 *      make.with.stringRange(^{
 *          make.font([UIFont systemFontOfSize:12]);
 *          make.foregroundColor([UIColor greenColor]);
 *          make.backgroundColor([UIColor blueColor]);
 *      });
 *  }];
 *  @endcode
 *  All three attributes above will be applied for the whole string. This method
 *  is equivalent to the following invocation:
 *  @code
 *  NSAttributedString *result = [stringVar makeString:^(BOStringMaker *make) {
 *      make.with.range(NSMakeRange(0, [stringVar length]), ^{
 *          make.font([UIFont systemFontOfSize:12]);
 *          make.foregroundColor([UIColor greenColor]);
 *          make.backgroundColor([UIColor blueColor]);
 *      });
 *  }];
 *  @endcode
 *  In fact, by default all attributes are applied to the whole string, so if 
 *  you want a shorter code, you can write something like this:
 *  @code
 *  NSAttributedString *result = [stringVar makeString:^(BOStringMaker *make) {
 *      make.font([UIFont systemFontOfSize:12]);
 *      make.foregroundColor([UIColor greenColor]);
 *      make.backgroundColor([UIColor blueColor]);
 *  }];
 *  @endcode
 *  However for the sake of readability, you still might want to use this method.
 *
 *  @see BOStringAttribute to learn more of attributes application range.
 */
- (void(^)(void (^)(void)))stringRange;

/**
 *  Helper method, used in conjunction with `substring` to apply certain
 *  attributes to a first found substring.
 *
 *  Example:
 *  @code
 *  NSAttributedString *result = [@"abababa" makeString:^(BOStringMaker *make) {
 *      make.first.substring(@"a", ^{
 *          make.font([UIFont systemFontOfSize:12]);
 *          make.foregroundColor([UIColor greenColor]);
 *          make.backgroundColor([UIColor blueColor]);
 *      });
 *  }];
 *  @endcode
 *  @return `self`. After invoking this method, you *must* invoke `substring`.
 */
- (instancetype)first;

/**
 *  Helper method, used in conjunction with `substring` to apply certain
 *  attributes to each found substring.
 *
 *  Example:
 *  @code
 *  NSAttributedString *result = [@"abababa" makeString:^(BOStringMaker *make) {
 *      make.each.substring(@"a", ^{
 *          make.font([UIFont systemFontOfSize:12]);
 *          make.foregroundColor([UIColor greenColor]);
 *          make.backgroundColor([UIColor blueColor]);
 *      });
 *  }];
 *  @endcode
 *  @return `self`. After invoking this method, you *must* invoke `substring`.
 */
- (instancetype)each;

/**
 *  Method which applies certain attributes to substrings according to rules,
 *  described in `first` and `each` methods.
 *
 *  Example:
 *  @code
 *  NSAttributedString *result = [@"abababa" makeString:^(BOStringMaker *make) {
 *      make.each.substring(@"a", ^{
 *          make.backgroundColor([UIColor blueColor]);
 *      });
 *      make.first.substring(@"ab", ^{
 *          make.foregoundColor([UIColor greenColor]);
 *      });
 *  }];
 *  @endcode
 */
- (void(^)(NSString *, void (^)(void)))substring;

/**
 *  Sets NSFontAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range:
 *  @code
 *  NSAttributedString *result = [stringVar makeString:^(BOStringMaker *make) {
 *      make.font([UIFont fontOfSize:12]).with.range(NSMakeRange(0, 5));
 *  }];
 *  @endcode
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSFont *))font;

/**
 *  Sets NSParagraphStyleAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSParagraphStyle *))paragraphStyle;

/**
 *  Sets NSForegroundColorAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSColor *))foregroundColor;

/**
 *  Sets NSBackgroundColorAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSColor *))backgroundColor;

/**
 *  Sets NSLigatureAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))ligature;

/**
 *  Sets NSKernAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))kern;

/**
 *  Sets NSStrikethroughStyleAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))strikethroughStyle;

/**
 *  Sets NSUnderlineStyleAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))underlineStyle;

/**
 *  Sets NSStrokeColorAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSColor *))strokeColor;

/**
 *  Sets NSStrokeWidthAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))strokeWidth;

/**
 *  Sets NSShadowAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSShadow *))shadow;

#if TARGET_OS_IPHONE

/**
 *  Sets NSTextEffectAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSString *))textEffect;
#endif

/**
 *  Sets NSAttachmentAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSTextAttachment *))attachment;

/**
 *  Sets NSLinkAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(id))link;

/**
 *  Sets NSBaselineOffsetAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))baselineOffset;

/**
 *  Sets NSUnderlineColorAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSColor *))underlineColor;

/**
 *  Sets NSStrikethroughColorAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSColor *))strikethroughColor;

/**
 *  Sets NSObliquenessAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))obliqueness;

/**
 *  Sets NSExpansionAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))expansion;

/**
 *  Sets NSWritingDirectionAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(id))writingDirection;

/**
 *  Sets NSVerticalGlyphFormAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))verticalGlyphForm;

#if !TARGET_OS_IPHONE

/**
 *  Sets NSSuperscriptAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))superscript;

/**
 *  Sets NSCursorAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSCursor *))cursor;

/**
 *  Sets NSToolTipAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSString *))toolTip;

/**
 *  Sets NSCharacterShapeAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))characterShape;

/**
 *  Sets NSGlyphInfoAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSGlyphInfo *))glyphInfo;

/**
 *  Sets NSMarkedClauseSegmentAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))markedClauseSegment;

/**
 *  Sets NSTextAlternativesAttributeName attribute.
 *
 *  @returns BOStringAttribute instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSTextAlternatives *))textAlternatives;
#endif

@end
