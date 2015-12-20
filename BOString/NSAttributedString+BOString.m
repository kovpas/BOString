//
//  NSAttributedString+BOString.m
//  BOString
//
//  Created by Pavel Mazurin on 29/11/13.
//  Copyright (c) 2013 Pavel Mazurin. All rights reserved.
//

#import "NSAttributedString+BOString.h"
#import "BOStringMaker.h"

@implementation NSAttributedString (BOString)

- (NSAttributedString *)bos_makeString:(void(^)(BOStringMaker *make))block
{
    BOStringMaker *stringMaker = [[BOStringMaker alloc] initWithAttributedString:self];
    if (block)
    {
        block(stringMaker);
    }
    
    return [stringMaker makeString];
}

@end
