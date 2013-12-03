//
//  NSString+BOString.m
//  BOStringDemo
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "NSString+BOString.h"
#import "BOStringMaker.h"

@implementation NSString (BOString)

- (NSAttributedString *)makeString:(void(^)(BOStringMaker *make))block
{
    BOStringMaker *stringMaker = [[BOStringMaker alloc] initWithString:self];
    if (block)
    {
        block(stringMaker);
    }
    
    return [stringMaker makeString];
}

@end
