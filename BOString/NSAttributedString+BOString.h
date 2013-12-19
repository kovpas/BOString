//
//  NSAttributedString+BOString.h
//  BOStringDemo
//
//  Created by Pavel Mazurin on 29/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BOStringMaker;

/**
 *  Helper category, which allows to avoid manual creation of `BOStringMaker`.
 *  It allows to make `NSAttributedString` instance with initial 
 *  `NSAttributedString` object and a maker block.
 *
 *  @see BOStringMaker for more information.
 */
@interface NSAttributedString (BOString)

/**
 *  Creates `NSAttributedString` instance with a given maker block.
 *
 *  @param block A list of instructions for `BOStringMaker`.
 *
 *  @return An `NSAttributedString` instance with initial attributes and
 *  attributes added from _block_. This method preserves attributes of initial
 *  `NSAttributedString`. In case of conflicts initial attributes are 
 *  re-written.
 */
- (NSAttributedString *)makeString:(void(^)(BOStringMaker *make))block;

@end
