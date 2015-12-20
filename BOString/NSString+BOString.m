//
//  NSString+BOString.m
//  BOString
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Pavel Mazurin. All rights reserved.
//

#import "NSString+BOString.h"
#import "BOStringMaker.h"

@implementation NSString (BOString)

- (NSAttributedString *)bos_makeString:(void(^)(BOStringMaker *make))block
{
    BOStringMaker *stringMaker = [[BOStringMaker alloc] initWithString:self];
    if (block)
    {
        block(stringMaker);
    }
    
    return [stringMaker makeString];
}

@end
