//
//  BOStringAttribute.h
//  BOStringDemo
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Represents single attribute instance.
 */
@interface BOStringAttribute : NSObject

/**
 *  Range of attribute.
 *  Default is `(0, _stringLength_)`.
 */
@property (nonatomic, assign) NSRange attributeRange;
/**
 *  Length of string to apply attribute to.
 */
@property (nonatomic, assign) NSUInteger stringLength;
/**
 *  Name of the attribute to apply.
 */
@property (nonatomic, copy) NSString *attributeName;
/**
 *  Value of the attribute.
 */
@property (nonatomic, strong) id attributeValue;

/**
 *  Semantic filler. Does nothing, just returns self. May be helpful in case if
 *  range needs to be changed:
 *  @code
 *      make.foregroundColor([UIColor blueColor]).with.range(NSMakeRange(1, 2));
 *  @endcode
 *  however, this code is equivalent to a bit shorter form:
 *  @code
 *      make.foregroundColor([UIColor blueColor]).range(NSMakeRange(1, 2));
 *  @endcode
 *  which is a bit less human readable.
 *
 *  @return `self`
 */
- (instancetype)with;
/**
 *  Sets range of the attribute.
 */
- (BOStringAttribute *(^)(NSRange))range;
/**
 *  Sets range of the attribute to whole string. Equivalent:
 *  @code
 *      range(NSMakeRange(0, self.stringLength));
 *  @endcode
 */
- (void(^)())stringRange;

@end
