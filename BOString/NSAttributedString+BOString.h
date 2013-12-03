//
//  NSAttributedString+BOString.h
//  BOStringDemo
//
//  Created by Pavel Mazurin on 29/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BOStringMaker;

@interface NSAttributedString (BOString)

- (NSAttributedString *)makeString:(void(^)(BOStringMaker *make))block;

@end
