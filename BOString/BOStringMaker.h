//
//  BOStringMaker.h
//  BOString
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Pavel Mazurin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BOStringAttribute;

#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>

    #define BOSColor UIColor
    #define BOSFont UIFont
#else
    #import <AppKit/AppKit.h>

    #define BOSColor NSColor
    #define BOSFont NSFont
#endif

/**  
 *  This class "resolves" maker block.
 *  Maker block is a list of instructions how to create an `NSAttributedString`.
 *
 *  Example:
 *
 *	NSAttributedString *result = [@"string" makeString:^(BOStringMaker *make) {
 *	    make.font([UIFont systemFontOfSize:12]).with.stringRange();
 *	    make.foregroundColor([UIColor greenColor]).with.range(NSMakeRange(0, 5));
 *	    make.backgroundColor([UIColor blueColor]).range(NSMakeRange(0, 3));
 *	}];
 *
 *  Attributes are stored as <BOStringAttribute> objects in the internal array.
 *  After all attributes are processed, <makeString> method resolves collisions
 *  with the following algorithm:
 *
 *  - it maps array of <BOStringAttribute> objects into a dictionary:   
 *
 *		@{NSRange => @[@{attribute name => attribute value}, ...], ...}
 *
 *      in this example `attribute name` is an `NSAttributedString` attribute name
 *      i.e. `NSFontAttributeName`, `attribute value` is it's value, i.e. `UIFont`
 *      instance.
 *
 *  - it sorts all the attributes by their `NSRange`s, so that ranges with the
 *      same start indexes and longer length have priority over the ones with a
 *      shorter range.
 *
 *  - it applies all attributes with 
 *      `[NSMutableAttributedString addAttributes:range:]` method.
 *
 *  With this algorithm attributes are applied from left to right, so in case if
 *  you write something like:
 *  
 *	make.foregroundColor([UIColor blueColor]).range(NSMakeRange(1, 2));
 *	make.foregroundColor([UIColor redColor]).stringRange();
 *  
 *  it makes sure that `redColor` will be applied first and `blueColor` second.
 */
@interface BOStringMaker : NSObject

/**
 * @name Initializers
 */

/**
 *  Returns a <BOStringMaker> instance, initialized with an attributed string.
 *
 *  @param string Initial attributed string.
 *
 *  @return <BOStringMaker> instance, initialized with an attributed string.
 */
- (instancetype)initWithAttributedString:(NSAttributedString *)string;

/**
 *  Returns a <BOStringMaker> instance, initialized with a string.
 *
 *  @param string Initial string.
 *
 *  @return <BOStringMaker> instance, initialized with a string.
 */
- (instancetype)initWithString:(NSString *)string;

/**
 * @name String maker
 */

/**
 *  Returns `NSAttributedString` instance.
 *
 *  @return `NSAttributedString` instance, created with initial attributes (in
 *  case if <BOStringMaker> instance was created with initWithAttributedString:
 *  method) and attributes assigned with the methods below.
 */
- (NSAttributedString *)makeString;

/**
 * @name Range modifiers
 */

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
 *
 *	NSAttributedString *result = [@"string" makeString:^(BOStringMaker *make) {
 *	    make.with.range(NSMakeRange(0, 5), ^{
 *	        make.font([UIFont systemFontOfSize:12]);
 *	        make.foregroundColor([UIColor greenColor]);
 *	        make.backgroundColor([UIColor blueColor]);
 *	    });
 *	}];
 *
 *  All three attributes above will be applied for the range `(0, 5)`.
 */
- (void(^)(NSRange, void (^)(void)))range;

/**
 *  Returns a block, which should contain attributes that are set for the entire
 *  string.
 *
 *  Example:
 *  
 *	NSAttributedString *result = [@"string" makeString:^(BOStringMaker *make) {
 *	    make.with.stringRange(^{
 *	        make.font([UIFont systemFontOfSize:12]);
 *	        make.foregroundColor([UIColor greenColor]);
 *	        make.backgroundColor([UIColor blueColor]);
 *	    });
 *	}];
 *  
 *  All three attributes above will be applied for a whole string. This method
 *  is equivalent to the following invocation:
 *  
 *	NSAttributedString *result = [stringVar makeString:^(BOStringMaker *make) {
 *	    make.with.range(NSMakeRange(0, [stringVar length]), ^{
 *	        make.font([UIFont systemFontOfSize:12]);
 *	        make.foregroundColor([UIColor greenColor]);
 *	        make.backgroundColor([UIColor blueColor]);
 *	    });
 *	}];
 *  
 *  In fact, by default all attributes are applied to a whole string, so if 
 *  you want a shorter code, you can write something like this:
 *  
 *	NSAttributedString *result = [stringVar makeString:^(BOStringMaker *make) {
 *	    make.font([UIFont systemFontOfSize:12]);
 *	    make.foregroundColor([UIColor greenColor]);
 *	    make.backgroundColor([UIColor blueColor]);
 *	}];
 *  
 *  However for the sake of readability, you still might want to use this method.
 *
 *  @see BOStringAttribute to learn more about attributes application range.
 */
- (void(^)(void (^)(void)))stringRange;

/**
 * @name Attributed string helper methods
 */

/**
 *  Helper method, used in conjunction with `substring` to apply certain
 *  attributes to a first found substring.
 *
 *  Example:
 *
 *	NSAttributedString *result = [@"abababa" makeString:^(BOStringMaker *make) {
 *	    make.first.substring(@"a", ^{
 *	        make.font([UIFont systemFontOfSize:12]);
 *	        make.foregroundColor([UIColor greenColor]);
 *	        make.backgroundColor([UIColor blueColor]);
 *	    });
 *	}];
 *
 *  @return `self`. After invoking this method, you *must* call `substring`.
 */
- (instancetype)first;

/**
 *  Helper method, used in conjunction with `substring` to apply certain
 *  attributes to a last found substring.
 *
 *  Example:
 *
 *	NSAttributedString *result = [@"abababa" makeString:^(BOStringMaker *make) {
 *	    make.last.substring(@"a", ^{
 *	        make.font([UIFont systemFontOfSize:12]);
 *	        make.foregroundColor([UIColor greenColor]);
 *	        make.backgroundColor([UIColor blueColor]);
 *	    });
 *	}];
 *
 *  @return `self`. After invoking this method, you *must* call `substring`.
 */
- (instancetype)last;

/**
 *  Helper method, used in conjunction with `substring` to apply certain
 *  attributes to each found substring.
 *
 *  Example:
 *  
 *	NSAttributedString *result = [@"abababa" makeString:^(BOStringMaker *make) {
 *	    make.each.substring(@"a", ^{
 *	        make.font([UIFont systemFontOfSize:12]);
 *	        make.foregroundColor([UIColor greenColor]);
 *	        make.backgroundColor([UIColor blueColor]);
 *	    });
 *	}];
 *  
 *  @return `self`. After invoking this method, you *must* call `substring`.
 */
- (instancetype)each;

/**
 *  Method which applies certain attributes to substrings according to rules,
 *  described in `first` and `each` methods.
 *
 *  Example:
 *
 *	NSAttributedString *result = [@"abababa" makeString:^(BOStringMaker *make) {
 *	    make.each.substring(@"a", ^{
 *	        make.backgroundColor([UIColor blueColor]);
 *	    });
 *	    make.first.substring(@"ab", ^{
 *	        make.foregoundColor([UIColor greenColor]);
 *	    });
 *	}];
 */
- (void(^)(NSString *, void (^)(void)))substring;

/**
 *  Method which applies certain attributes to regexp matches according to rules,
 *  described in `first` and `each` methods.
 *
 *  Example:
 *
 *	NSAttributedString *result = [@"aab ab ab" makeString:^(BOStringMaker *make) {
 *	    make.each.regexpMatch(@"\\w{2}", NSRegularExpressionCaseInsensitive, ^{
 *	        make.backgroundColor([UIColor blueColor]);
 *	    });
 *	    make.first.regexpMatch(@"a[^b]", 0, ^{
 *	        make.foregoundColor([UIColor greenColor]);
 *	    });
 *	}];
 */
- (void(^)(NSString *, NSRegularExpressionOptions, void (^)(void)))regexpMatch;

/**
 *  Method which applies certain attributes to regexp matching groups according 
 *  to rules, described in `first` and `each` methods.
 *
 *  Example:
 *
 *	NSAttributedString *result = [@"aab ab ab" makeString:^(BOStringMaker *make) {
 *	    make.each.regexpGroup(@"\\s(a\\w)", NSRegularExpressionCaseInsensitive, ^{
 *	        make.backgroundColor([UIColor blueColor]);
 *	    });
 *	    make.first.regexpGroup(@"a(ab)", 0, ^{
 *	        make.foregoundColor([UIColor greenColor]);
 *	    });
 *	}];
 */
- (void(^)(NSString *, NSRegularExpressionOptions, void (^)(void)))regexpGroup;

/**
 * @name Attributes
 */

/**
 *  Sets custom attribute. It's recommended to use pre-defined methods, however
 *  some CoreText attributes are not available through them, so in that case you 
 *  can use this method.
 *
 *	NSAttributedString *result = [stringVar makeString:^(BOStringMaker *make) {
 *	    make.attribute(kCTLanguageAttributeName, @"jp");
 *	}];
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change
 *  attribute's range.
 *
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSString *, id))attribute;

/**
 *  Sets `NSFontAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range:
 *  
 *	NSAttributedString *result = [stringVar makeString:^(BOStringMaker *make) {
 *	    make.font([UIFont fontOfSize:12]).with.range(NSMakeRange(0, 5));
 *	}];
 *  
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSFont *))font;

/**
 *  Sets `NSParagraphStyleAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSParagraphStyle *))paragraphStyle;

/**
 *  Sets `NSForegroundColorAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSColor *))foregroundColor;

/**
 *  Sets `NSBackgroundColorAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSColor *))backgroundColor;

/**
 *  Sets `NSLigatureAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))ligature;

/**
 *  Sets `NSKernAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))kern;

/**
 *  Sets `NSStrikethroughStyleAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))strikethroughStyle;

/**
 *  Sets `NSUnderlineStyleAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))underlineStyle;

/**
 *  Sets `NSStrokeColorAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSColor *))strokeColor;

/**
 *  Sets `NSStrokeWidthAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))strokeWidth;

/**
 *  Sets `NSShadowAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSShadow *))shadow;

#if TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_7
/**
 *  Sets `NSVerticalGlyphFormAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))verticalGlyphForm;
#endif // TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_7

#if !TARGET_OS_IPHONE || __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#if TARGET_OS_IPHONE
/**
 *  Sets `NSTextEffectAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSString *))textEffect;
#endif // TARGET_OS_IPHONE

/**
 *  Sets `NSAttachmentAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSTextAttachment *))attachment;

/**
 *  Sets `NSLinkAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(id))link;

/**
 *  Sets `NSBaselineOffsetAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))baselineOffset;

/**
 *  Sets `NSUnderlineColorAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSColor *))underlineColor;

/**
 *  Sets `NSStrikethroughColorAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(BOSColor *))strikethroughColor;

/**
 *  Sets `NSObliquenessAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))obliqueness;

/**
 *  Sets `NSExpansionAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))expansion;

#if TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6
/**
 *  Sets `NSWritingDirectionAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(id))writingDirection;
#endif // TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6
#endif // !TARGET_OS_IPHONE || __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

#if !TARGET_OS_IPHONE
/**
 *  Sets `NSSuperscriptAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))superscript;

/**
 *  Sets `NSCursorAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSCursor *))cursor;

/**
 *  Sets `NSToolTipAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSString *))toolTip;

/**
 *  Sets `NSCharacterShapeAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))characterShape;

/**
 *  Sets `NSGlyphInfoAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSGlyphInfo *))glyphInfo;

/**
 *  Sets `NSMarkedClauseSegmentAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSNumber *))markedClauseSegment;

#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_8
/**
 *  Sets `NSTextAlternativesAttributeName` attribute.
 *
 *  @returns <BOStringAttribute> instance, in case if you want to change 
 *  attribute's range.
 *
 *  @see font for more information.
 *  @see BOStringAttribute for more information.
 */
- (BOStringAttribute *(^)(NSTextAlternatives *))textAlternatives;
#endif // MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_8
#endif // !TARGET_OS_IPHONE

@end
