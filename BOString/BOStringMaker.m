//
//  BOStringMaker.m
//  BOStringDemo
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "BOStringMaker.h"
#import "BOStringAttribute.h"

typedef NS_ENUM(NSInteger, BOStringMakerStringCommand) {
    BOStringMakerUndefinedStringCommand = 0,
    BOStringMakerFirstStringCommand,
    BOStringMakerEachStringCommand
};

@interface BOStringMaker ()

@property (nonatomic, copy) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *attributes; // BOStringAttribute
@property (nonatomic, assign) NSRange furtherRange;
@property (nonatomic, assign) NSInteger stringLength;
@property (nonatomic, assign) BOStringMakerStringCommand stringCommand;

@end

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedDescending)
#define NSAttributeAssert(attr) NSAssert(IS_IOS7, @"Attribute %@ is supported on iOS 7 or later", attr)

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

- (instancetype)each
{
    _stringCommand = BOStringMakerEachStringCommand;
    return self;
}

- (void (^)(NSString *, void (^)(void)))substring
{
    NSAssert(_stringCommand != BOStringMakerUndefinedStringCommand, @"Please provide correct instruction before substring command. I.e. make.each.substring(...) or make.first.substring(...)");
    
    return ^(NSString *string, void (^attrbutes)(void)){
        NSMutableArray *ranges = [NSMutableArray array];
        switch (_stringCommand) {
            case BOStringMakerFirstStringCommand:
                [ranges addObject:[NSValue valueWithRange:[[_attributedString string] rangeOfString:string]]];
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

- (BOStringAttribute *(^)(UIFont *))font
{
    return ^BOStringAttribute *(UIFont *font) {
        return [self addAttributeWithName:NSFontAttributeName value:font];
    };
}

- (BOStringAttribute *(^)(NSParagraphStyle *))paragraphStyle
{
    return ^BOStringAttribute *(NSParagraphStyle *paragraphStyle) {
        return [self addAttributeWithName:NSParagraphStyleAttributeName value:paragraphStyle];
    };
}

- (BOStringAttribute *(^)(UIColor *))foregroundColor
{
    return ^BOStringAttribute *(UIColor *foregroundColor) {
        return [self addAttributeWithName:NSForegroundColorAttributeName value:foregroundColor];
    };
}

- (BOStringAttribute *(^)(UIColor *))backgroundColor
{
    return ^BOStringAttribute *(UIColor *backgroundColor) {
        return [self addAttributeWithName:NSBackgroundColorAttributeName value:backgroundColor];
    };
}

- (BOStringAttribute *(^)(NSNumber *))ligature
{
    return ^BOStringAttribute *(NSNumber *ligature) {
        return [self addAttributeWithName:NSLigatureAttributeName value:ligature];
    };
}

- (BOStringAttribute *(^)(NSNumber *))kern
{
    return ^BOStringAttribute *(NSNumber *kern) {
        return [self addAttributeWithName:NSKernAttributeName value:kern];
    };
}

- (BOStringAttribute *(^)(NSNumber *))strikethroughStyle
{
    return ^BOStringAttribute *(NSNumber *strikethroughStyle) {
        return [self addAttributeWithName:NSStrikethroughStyleAttributeName value:strikethroughStyle];
    };
}

- (BOStringAttribute *(^)(NSNumber *))underlineStyle
{
    return ^BOStringAttribute *(NSNumber *underlineStyle) {
        return [self addAttributeWithName:NSUnderlineStyleAttributeName value:underlineStyle];
    };
}


- (BOStringAttribute *(^)(UIColor *))strokeColor
{
    return ^BOStringAttribute *(UIColor *strokeColor) {
        return [self addAttributeWithName:NSStrokeColorAttributeName value:strokeColor];
    };
}

- (BOStringAttribute *(^)(NSNumber *))strokeWidth
{
    return ^BOStringAttribute *(NSNumber *strokeWidth) {
        return [self addAttributeWithName:NSStrokeWidthAttributeName value:strokeWidth];
    };
}

- (BOStringAttribute *(^)(NSShadow *))shadow
{
    return ^BOStringAttribute *(NSShadow *shadow) {
        return [self addAttributeWithName:NSShadowAttributeName value:shadow];
    };
}

- (BOStringAttribute *(^)(NSString *))textEffect
{
    NSAttributeAssert(@"NSTextEffectAttributeName");
    return ^BOStringAttribute *(NSString *textEffect) {
        return [self addAttributeWithName:NSTextEffectAttributeName value:textEffect];
    };
}

- (BOStringAttribute *(^)(NSTextAttachment *))attachment
{
    NSAttributeAssert(@"NSAttachmentAttributeName");
    return ^BOStringAttribute *(NSTextAttachment *attachment) {
        return [self addAttributeWithName:NSAttachmentAttributeName value:attachment];
    };
}

- (BOStringAttribute *(^)(id))link
{
    NSAttributeAssert(@"NSLinkAttributeName");
    return ^BOStringAttribute *(id link) {
        NSAssert([link isKindOfClass:[NSURL class]] || [link isKindOfClass:[NSString class]], @"The value of link attribute is an NSURL object (preferred) or an NSString object.");
        return [self addAttributeWithName:NSLinkAttributeName value:link];
    };
}

- (BOStringAttribute *(^)(NSNumber *))baselineOffset
{
    NSAttributeAssert(@"NSBaselineOffsetAttributeName");
    return ^BOStringAttribute *(NSNumber *baselineOffset) {
        return [self addAttributeWithName:NSBaselineOffsetAttributeName value:baselineOffset];
    };
}

- (BOStringAttribute *(^)(UIColor *))underlineColor
{
    NSAttributeAssert(@"NSUnderlineColorAttributeName");
    return ^BOStringAttribute *(UIColor *underlineColor) {
        return [self addAttributeWithName:NSUnderlineColorAttributeName value:underlineColor];
    };
}

- (BOStringAttribute *(^)(UIColor *))strikethroughColor
{
    NSAttributeAssert(@"NSStrikethroughColorAttributeName");
    return ^BOStringAttribute *(UIColor *strikethroughColor) {
        return [self addAttributeWithName:NSStrikethroughColorAttributeName value:strikethroughColor];
    };
}

- (BOStringAttribute *(^)(NSNumber *))obliqueness
{
    NSAttributeAssert(@"NSObliquenessAttributeName");
    return ^BOStringAttribute *(NSNumber *obliqueness) {
        return [self addAttributeWithName:NSObliquenessAttributeName value:obliqueness];
    };
}

- (BOStringAttribute *(^)(NSNumber *))expansion
{
    NSAttributeAssert(@"NSExpansionAttributeName");
    return ^BOStringAttribute *(NSNumber *expansion) {
        return [self addAttributeWithName:NSExpansionAttributeName value:expansion];
    };
}

- (BOStringAttribute *(^)(id))writingDirection
{
    NSAttributeAssert(@"NSWritingDirectionAttributeName");
    return ^BOStringAttribute *(id writingDirection) {
        NSAssert([writingDirection isKindOfClass:[NSArray class]] || [writingDirection isKindOfClass:[NSNumber class]], @"The value of writingDirection attribute is an NSArray object or an NSNumber object.");
        return [self addAttributeWithName:NSWritingDirectionAttributeName value:writingDirection];
    };
}

- (BOStringAttribute *(^)(NSNumber *))verticalGlyphForm
{
    return ^BOStringAttribute *(NSNumber *verticalGlyphForm) {
        return [self addAttributeWithName:NSVerticalGlyphFormAttributeName value:verticalGlyphForm];
    };
}


@end
