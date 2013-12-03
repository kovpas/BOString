//
//  NSString+BOString.h
//  BOStringDemo
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BOStringMaker;

@interface NSString (BOString)

- (NSAttributedString *)makeString:(void(^)(BOStringMaker *make))block;

@end
