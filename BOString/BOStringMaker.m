//
//  BOStringMaker.m
//  BOString
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Pavel Mazurin. All rights reserved.
//

#import "BOStringMaker.h"
#import "BOStringAttribute.h"

typedef NS_ENUM(NSInteger, BOStringMakerStringCommand) {
    BOStringMakerUndefinedStringCommand = 0,
    BOStringMakerFirstStringCommand,
    BOStringMakerLastStringCommand,
    BOStringMakerEachStringCommand
};

@interface BOStringMaker ()

@property (nonatomic, copy) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *attributes; // BOStringAttribute
@property (nonatomic, assign) NSRange furtherRange;
@property (nonatomic, assign) NSInteger stringLength;
@property (nonatomic, assign) BOStringMakerStringCommand stringCommand;

@end

#if TARGET_OS_IPHONE
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedDescending)
#define NSAttributeAssert(attr) NSAssert(IS_IOS7, @"Attribute %@ is supported on iOS 7 or later", attr)
#else
#define NSAttributeAssert(...)
#endif
@implementation BOStringMaker

- (instancetype)initWithString:(NSString *)string
{
    return [self initWithAttributedString:[[NSAttributedString alloc] initWithString:string]];
}

- (instancetype)initWithAttributedString:(NSAttributedString *)string
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    if (string)
    {
        _attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:string];
        _stringLength = [[_attributedString string] length];
        _furtherRange = NSMakeRange(0, _stringLength);
    }
    
    _attributes = [NSMutableArray array];
    
    return self;
}

- (NSDictionary *)attributesByRanges:(NSArray *)attributes
{
    NSMutableDictionary *attributesByRanges = [NSMutableDictionary dictionary];
    for (BOStringAttribute *attribute in attributes)
    {
        NSValue *rangeVal = [NSValue valueWithRange:attribute.attributeRange];
        if (!attributesByRanges[rangeVal])
        {
            attributesByRanges[rangeVal] = [NSMutableDictionary dictionary];
        }
        attributesByRanges[rangeVal][attribute.attributeName] = attribute.attributeValue;
    }
    return attributesByRanges;
}

- (NSArray *)sortedRangesArray:(NSArray *)arrayToSort
{
    NSArray *sortedRanges = [arrayToSort sortedArrayUsingComparator:^NSComparisonResult(id val1, id val2) {
        NSRange range1 = [val1 rangeValue];
        NSRange range2 = [val2 rangeValue];
        
        if(range1.location < range2.location) return NSOrderedAscending;
        if(range1.location > range2.location) return NSOrderedDescending;
        
        // start point is the same. compare lengths. If longer, then it's attributes should go first
        if(range1.length > range2.length) return NSOrderedAscending;
        if(range1.length < range2.length) return NSOrderedDescending;
        
        return NSOrderedSame;
    }];
    return sortedRanges;
}

- (NSAttributedString *)makeString
{
    if (!_attributedString)
    {
        return nil;
    }
    
    NSDictionary *attributesByRanges = [self attributesByRanges:_attributes];
    NSArray *sortedRanges = [self sortedRangesArray:[attributesByRanges allKeys]];
    
    [_attributedString beginEditing];
    [sortedRanges enumerateObjectsUsingBlock:^(NSValue *range, NSUInteger idx, BOOL *stop) {
        [_attributedString addAttributes:attributesByRanges[range]
                                   range:[range rangeValue]];
    }];
    [_attributedString endEditing];
    
    return [[NSAttributedString alloc] initWithAttributedString:_attributedString];
}

- (instancetype)with
{
    return self;
}

- (instancetype)first
{
    _stringCommand = BOStringMakerFirstStringCommand;
    return self;
}

- (instancetype)last
{
    _stringCommand = BOStringMakerLastStringCommand;
    return self;
}

- (instancetype)each
{
    _stringCommand = BOStringMakerEachStringCommand;
    return self;
}

- (void (^)(NSString *, void (^)(void)))substring
{
    NSAssert(_stringCommand != BOStringMakerUndefinedStringCommand, @"Please provide correct instruction before substring command. I.e. make.each.substring(...) or make.first.substring(...)");
    
    return ^(NSString *string, void (^attrbutes)(void)) {
        NSMutableArray *ranges = [NSMutableArray array];
        switch (_stringCommand) {
            case BOStringMakerFirstStringCommand:
                [ranges addObject:[NSValue valueWithRange:[[_attributedString string] rangeOfString:string]]];
                break;
            case BOStringMakerLastStringCommand:
                [ranges addObject:[NSValue valueWithRange:[[_attributedString string] rangeOfString:string
                                                                                            options:NSBackwardsSearch]]];
                break;
                
            case BOStringMakerEachStringCommand:
            {
                NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:string
                                                                                            options:0
                                                                                              error:nil];
                
                NSRange range = NSMakeRange(0, [_attributedString length]);
                [expression enumerateMatchesInString:[_attributedString string]
                                             options:0
                                               range:range
                                          usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    [ranges addObject:[NSValue valueWithRange:[result rangeAtIndex:0]]];
                }];
                break;
            }
            default:
                break;
        }
        _stringCommand = BOStringMakerUndefinedStringCommand;
        
        [ranges enumerateObjectsUsingBlock:^(NSValue *rangeVal, NSUInteger idx, BOOL *stop) {
            self.range([rangeVal rangeValue], attrbutes);
        }];
    };
}

- (void(^)(NSString *, NSRegularExpressionOptions, void (^)(void)))regexpMatch
{
    NSAssert(_stringCommand != BOStringMakerUndefinedStringCommand, @"Please provide correct instruction before regexp command. I.e. make.each.regexpMatch(...) or make.first.regexpMatch(...)");
    return ^(NSString *pattern, NSRegularExpressionOptions options, void (^attrbutes)(void)) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:options
                                                                                 error:&error];
        NSString *string = [_attributedString string];
        BOOL matchFirstOnly = (_stringCommand == BOStringMakerFirstStringCommand);
        BOOL matchLastOnly = (_stringCommand == BOStringMakerLastStringCommand);
        __block NSTextCheckingResult *lastResult = nil;
        _stringCommand = BOStringMakerUndefinedStringCommand;
        [regex enumerateMatchesInString:string
                                options:0
                                  range:NSMakeRange(0, [string length])
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 lastResult = result;
                                 if (!matchLastOnly)
                                 {
                                     self.range(lastResult.range, attrbutes);
                                 }

                                 *stop = matchFirstOnly;
                             }];
        if (matchLastOnly && lastResult)
        {
            self.range(lastResult.range, attrbutes);
        }
    };
}

- (void(^)(NSString *, NSRegularExpressionOptions, void (^)(void)))regexpGroup
{
    NSAssert(_stringCommand != BOStringMakerUndefinedStringCommand, @"Please provide correct instruction before regexp command. I.e. make.each.regexpGroup(...) or make.first.regexpGroup(...)");
    return ^(NSString *pattern, NSRegularExpressionOptions options, void (^attrbutes)(void)){
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:options
                                                                                 error:&error];
        NSString *string = [_attributedString string];
        BOOL matchFirstOnly = (_stringCommand == BOStringMakerFirstStringCommand);
        BOOL matchLastOnly = (_stringCommand == BOStringMakerLastStringCommand);
        __block NSTextCheckingResult *lastResult = nil;
        _stringCommand = BOStringMakerUndefinedStringCommand;
        [regex enumerateMatchesInString:string
                                options:0
                                  range:NSMakeRange(0, [string length])
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 lastResult = result;
                                 if (!matchLastOnly)
                                 {
                                     for (NSUInteger i = 1; i < [result numberOfRanges]; i++)
                                     {
                                         self.range([result rangeAtIndex:i], attrbutes);
                                     }
                                 }
                                 *stop = matchFirstOnly;
                             }];
        if (matchLastOnly && lastResult)
        {
            for (NSUInteger i = 1; i < [lastResult numberOfRanges]; i++)
            {
                self.range([lastResult rangeAtIndex:i], attrbutes);
            }
        }
    };
}

- (void(^)(void (^)(void)))stringRange
{
    return ^(void (^rangeAttributes)(void)) {
        self.range(NSMakeRange(0, [[_attributedString string] length]), rangeAttributes);
    };
}

- (void(^)(NSRange, void (^)(void)))range
{
    return ^(NSRange range, void (^rangeAttributes)(void)) {
        NSRange savedRange = _furtherRange;
        _furtherRange = range;
        rangeAttributes();
        _furtherRange = savedRange;
    };
}

- (BOStringAttribute *)addAttributeWithName:(NSString *)name value:(id)value
{
    NSAssert(_stringCommand == BOStringMakerUndefinedStringCommand, @"You can use first/each command only in conjunction with substring. I.e. make.each.substring(...) or make.first.substring(...)");
    
    BOStringAttribute *attribute = [[BOStringAttribute alloc] init];
    attribute.attributeName = name;
    attribute.attributeValue = value;
    attribute.attributeRange = _furtherRange;
    attribute.stringLength = _stringLength;
    
    [_attributes addObject:attribute];
    return attribute;
}

- (BOStringAttribute *(^)(NSString *, id))attribute
{
    return ^BOStringAttribute *(NSString *attributeName, id attributeValue) {
        return [self addAttributeWithName:attributeName value:attributeValue];
    };
}

- (BOStringAttribute *(^)(BOSFont *))font
{
    return ^BOStringAttribute *(BOSFont *font) {
        return self.attribute(NSFontAttributeName, font);
    };
}

- (BOStringAttribute *(^)(NSParagraphStyle *))paragraphStyle
{
    return ^BOStringAttribute *(NSParagraphStyle *paragraphStyle) {
        return self.attribute(NSParagraphStyleAttributeName, paragraphStyle);
    };
}

- (BOStringAttribute *(^)(BOSColor *))foregroundColor
{
    return ^BOStringAttribute *(BOSColor *foregroundColor) {
        return self.attribute(NSForegroundColorAttributeName, foregroundColor);
    };
}

- (BOStringAttribute *(^)(BOSColor *))backgroundColor
{
    return ^BOStringAttribute *(BOSColor *backgroundColor) {
        return self.attribute(NSBackgroundColorAttributeName, backgroundColor);
    };
}

- (BOStringAttribute *(^)(NSNumber *))ligature
{
    return ^BOStringAttribute *(NSNumber *ligature) {
        return self.attribute(NSLigatureAttributeName, ligature);
    };
}

- (BOStringAttribute *(^)(NSNumber *))kern
{
    return ^BOStringAttribute *(NSNumber *kern) {
        return self.attribute(NSKernAttributeName, kern);
    };
}

- (BOStringAttribute *(^)(NSNumber *))strikethroughStyle
{
    return ^BOStringAttribute *(NSNumber *strikethroughStyle) {
        return self.attribute(NSStrikethroughStyleAttributeName, strikethroughStyle);
    };
}

- (BOStringAttribute *(^)(NSNumber *))underlineStyle
{
    return ^BOStringAttribute *(NSNumber *underlineStyle) {
        return self.attribute(NSUnderlineStyleAttributeName, underlineStyle);
    };
}


- (BOStringAttribute *(^)(BOSColor *))strokeColor
{
    return ^BOStringAttribute *(BOSColor *strokeColor) {
        return self.attribute(NSStrokeColorAttributeName, strokeColor);
    };
}

- (BOStringAttribute *(^)(NSNumber *))strokeWidth
{
    return ^BOStringAttribute *(NSNumber *strokeWidth) {
        return self.attribute(NSStrokeWidthAttributeName, strokeWidth);
    };
}

- (BOStringAttribute *(^)(NSShadow *))shadow
{
    return ^BOStringAttribute *(NSShadow *shadow) {
        return self.attribute(NSShadowAttributeName, shadow);
    };
}

#if TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_7
- (BOStringAttribute *(^)(NSNumber *))verticalGlyphForm
{
    return ^BOStringAttribute *(NSNumber *verticalGlyphForm) {
        return self.attribute(NSVerticalGlyphFormAttributeName, verticalGlyphForm);
    };
}
#endif // TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_7

#if !TARGET_OS_IPHONE || __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#if TARGET_OS_IPHONE
- (BOStringAttribute *(^)(NSString *))textEffect
{
    NSAttributeAssert(@"NSTextEffectAttributeName");
    return ^BOStringAttribute *(NSString *textEffect) {
        return self.attribute(NSTextEffectAttributeName, textEffect);
    };
}
#endif // TARGET_OS_IPHONE

- (BOStringAttribute *(^)(NSTextAttachment *))attachment
{
    NSAttributeAssert(@"NSAttachmentAttributeName");
    return ^BOStringAttribute *(NSTextAttachment *attachment) {
        return self.attribute(NSAttachmentAttributeName, attachment);
    };
}

- (BOStringAttribute *(^)(id))link
{
    NSAttributeAssert(@"NSLinkAttributeName");
    return ^BOStringAttribute *(id link) {
        NSAssert([link isKindOfClass:[NSURL class]] || [link isKindOfClass:[NSString class]], @"The value of link attribute is an NSURL object (preferred) or an NSString object.");
        return self.attribute(NSLinkAttributeName, link);
    };
}

- (BOStringAttribute *(^)(NSNumber *))baselineOffset
{
    NSAttributeAssert(@"NSBaselineOffsetAttributeName");
    return ^BOStringAttribute *(NSNumber *baselineOffset) {
        return self.attribute(NSBaselineOffsetAttributeName, baselineOffset);
    };
}

- (BOStringAttribute *(^)(BOSColor *))underlineColor
{
    NSAttributeAssert(@"NSUnderlineColorAttributeName");
    return ^BOStringAttribute *(BOSColor *underlineColor) {
        return self.attribute(NSUnderlineColorAttributeName, underlineColor);
    };
}

- (BOStringAttribute *(^)(BOSColor *))strikethroughColor
{
    NSAttributeAssert(@"NSStrikethroughColorAttributeName");
    return ^BOStringAttribute *(BOSColor *strikethroughColor) {
        return self.attribute(NSStrikethroughColorAttributeName, strikethroughColor);
    };
}

- (BOStringAttribute *(^)(NSNumber *))obliqueness
{
    NSAttributeAssert(@"NSObliquenessAttributeName");
    return ^BOStringAttribute *(NSNumber *obliqueness) {
        return self.attribute(NSObliquenessAttributeName, obliqueness);
    };
}

- (BOStringAttribute *(^)(NSNumber *))expansion
{
    NSAttributeAssert(@"NSExpansionAttributeName");
    return ^BOStringAttribute *(NSNumber *expansion) {
        return self.attribute(NSExpansionAttributeName, expansion);
    };
}

#if TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6
- (BOStringAttribute *(^)(id))writingDirection
{
    NSAttributeAssert(@"NSWritingDirectionAttributeName");
    return ^BOStringAttribute *(id writingDirection) {
        NSAssert([writingDirection isKindOfClass:[NSArray class]] || [writingDirection isKindOfClass:[NSNumber class]], @"The value of writingDirection attribute is an NSArray object or an NSNumber object.");
        return self.attribute(NSWritingDirectionAttributeName, writingDirection);
    };
}
#endif // TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6
#endif // !TARGET_OS_IPHONE || __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

#if !TARGET_OS_IPHONE
- (BOStringAttribute *(^)(NSNumber *))superscript
{
    return ^BOStringAttribute *(NSNumber *superscript) {
        return self.attribute(NSSuperscriptAttributeName, superscript);
    };
}

- (BOStringAttribute *(^)(NSCursor *))cursor
{
    return ^BOStringAttribute *(NSCursor *cursor) {
        return self.attribute(NSCursorAttributeName, cursor);
    };
}

- (BOStringAttribute *(^)(NSString *))toolTip
{
    return ^BOStringAttribute *(NSString *toolTip) {
        return self.attribute(NSToolTipAttributeName, toolTip);
    };
}

- (BOStringAttribute *(^)(NSNumber *))characterShape
{
    return ^BOStringAttribute *(NSNumber *characterShape) {
        return self.attribute(NSCharacterShapeAttributeName, characterShape);
    };
}

- (BOStringAttribute *(^)(NSGlyphInfo *))glyphInfo
{
    return ^BOStringAttribute *(NSGlyphInfo *glyphInfo) {
        return self.attribute(NSGlyphInfoAttributeName, glyphInfo);
    };
}

- (BOStringAttribute *(^)(NSNumber *))markedClauseSegment
{
    return ^BOStringAttribute *(NSNumber *markedClauseSegment) {
        return self.attribute(NSMarkedClauseSegmentAttributeName, markedClauseSegment);
    };
}

#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_8
- (BOStringAttribute *(^)(NSTextAlternatives *))textAlternatives
{
    return ^BOStringAttribute *(NSTextAlternatives *textAlternatives) {
        return self.attribute(NSTextAlternativesAttributeName, textAlternatives);
    };
}
#endif // MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_8
#endif // !TARGET_OS_IPHONE


@end
