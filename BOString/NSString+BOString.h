//
//  NSString+BOString.h
//  BOStringDemo
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Pavel Mazurin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BOStringMaker;

/**
 *  Helper category, which allows to avoid manual creation of <BOStringMaker>.
 *  It allows to make `NSAttributedString` instance with initial `NSString` 
 *  object and a maker block.
 *
 *  @see BOStringMaker for more information.
 */
@interface NSString (BOString)

/**
 *  Creates `NSAttributedString` instance with a given maker block.
 *
 *  @param block A list of instructions for <BOStringMaker>.
 *
 *  @return An `NSAttributedString` instance with attributes added 
 *  from _block_.
 */
- (NSAttributedString *)bos_makeString:(void(^)(BOStringMaker *make))block;

#ifdef BOS_SHORTHAND

/**
 *  Shorthand method for bos_makeString:.
 */
- (NSAttributedString *)makeString:(void(^)(BOStringMaker *make))block;

#endif // BOS_SHORTHAND

@end
