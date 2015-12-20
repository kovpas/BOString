//
//  BOStringAttribute.m
//  BOString
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Pavel Mazurin. All rights reserved.
//

#import "BOStringAttribute.h"

@implementation BOStringAttribute

- (instancetype)with
{
    return self;
}

- (void(^)())stringRange
{
    return ^{
        _attributeRange = NSMakeRange(0, _stringLength);
    };
}

- (instancetype (^)(NSRange))range
{
    return ^BOStringAttribute *(NSRange newRange) {
        _attributeRange = newRange;
        return self;
    };
}

@end
