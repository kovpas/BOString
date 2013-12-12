//
//  BOStringMaker.h
//  BOStringDemo
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BOStringAttribute;

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

- (BOStringAttribute *(^)(UIFont *))font;
- (BOStringAttribute *(^)(NSParagraphStyle *))paragraphStyle;
- (BOStringAttribute *(^)(UIColor *))foregroundColor;
- (BOStringAttribute *(^)(UIColor *))backgroundColor;
- (BOStringAttribute *(^)(NSNumber *))ligature;
- (BOStringAttribute *(^)(NSNumber *))kern;
- (BOStringAttribute *(^)(NSNumber *))strikethroughStyle;
- (BOStringAttribute *(^)(NSNumber *))underlineStyle;
- (BOStringAttribute *(^)(UIColor *))strokeColor;
- (BOStringAttribute *(^)(NSNumber *))strokeWidth;
- (BOStringAttribute *(^)(NSShadow *))shadow;

- (BOStringAttribute *(^)(NSString *))textEffect;
- (BOStringAttribute *(^)(NSTextAttachment *))attachment;
- (BOStringAttribute *(^)(id))link;
- (BOStringAttribute *(^)(NSNumber *))baselineOffset;
- (BOStringAttribute *(^)(UIColor *))underlineColor;
- (BOStringAttribute *(^)(UIColor *))strikethroughColor;
- (BOStringAttribute *(^)(NSNumber *))obliqueness;
- (BOStringAttribute *(^)(NSNumber *))expansion;
- (BOStringAttribute *(^)(id))writingDirection;
- (BOStringAttribute *(^)(NSNumber *))verticalGlyphForm;

@end
