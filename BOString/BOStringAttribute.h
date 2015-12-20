//
//  BOStringAttribute.h
//  BOString
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Pavel Mazurin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Represents single attribute instance.
 */
@interface BOStringAttribute : NSObject

/**
 *  Range of attribute.
 *  Default is (0, <stringLength>).
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
 *  
 *	make.foregroundColor([UIColor blueColor]).with.range(NSMakeRange(1, 2));
 *  
 *  However, this code is equivalent to a bit shorter form:
 *  
 *	make.foregroundColor([UIColor blueColor]).range(NSMakeRange(1, 2));
 *  
 *  Which is a bit less human readable.
 *
 *  @return `self`
 */
- (instancetype)with;
/**
 *  Sets range of the attribute.
 */
- (instancetype (^)(NSRange))range;
/**
 *  Sets range of the attribute to whole string. Equivalent:
 *
 *	range(NSMakeRange(0, self.stringLength));
 */
- (void(^)())stringRange;

@end
