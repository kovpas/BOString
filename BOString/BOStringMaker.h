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
#elif TARGET_OS_MAC
    #define BOSColor NSColor
    #define BOSFont NSFont
#endif

@interface BOStringMaker : NSObject

- (instancetype)initWithAttributedString:(NSAttributedString *)string;
- (instancetype)initWithString:(NSString *)string;
- (NSAttributedString *)makeString;

- (instancetype)with;
- (void(^)(void (^)(void)))stringRange;
- (void(^)(NSRange, void (^)(void)))range;

- (instancetype)first;
- (instancetype)each;
- (void(^)(NSString *, void (^)(void)))substring;

- (BOStringAttribute *(^)(BOSFont *))font;
- (BOStringAttribute *(^)(NSParagraphStyle *))paragraphStyle;
- (BOStringAttribute *(^)(BOSColor *))foregroundColor;
- (BOStringAttribute *(^)(BOSColor *))backgroundColor;
- (BOStringAttribute *(^)(NSNumber *))ligature;
- (BOStringAttribute *(^)(NSNumber *))kern;
- (BOStringAttribute *(^)(NSNumber *))strikethroughStyle;
- (BOStringAttribute *(^)(NSNumber *))underlineStyle;
- (BOStringAttribute *(^)(BOSColor *))strokeColor;
- (BOStringAttribute *(^)(NSNumber *))strokeWidth;
- (BOStringAttribute *(^)(NSShadow *))shadow;

#if TARGET_OS_IPHONE
- (BOStringAttribute *(^)(NSString *))textEffect;
#endif
- (BOStringAttribute *(^)(NSTextAttachment *))attachment;
- (BOStringAttribute *(^)(id))link;
- (BOStringAttribute *(^)(NSNumber *))baselineOffset;
- (BOStringAttribute *(^)(BOSColor *))underlineColor;
- (BOStringAttribute *(^)(BOSColor *))strikethroughColor;
- (BOStringAttribute *(^)(NSNumber *))obliqueness;
- (BOStringAttribute *(^)(NSNumber *))expansion;
- (BOStringAttribute *(^)(id))writingDirection;
- (BOStringAttribute *(^)(NSNumber *))verticalGlyphForm;

@end
