//
//  BOStringAttribute.h
//  BOStringDemo
//
//  Created by Pavel Mazurin on 28/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOStringAttribute : NSObject

@property (nonatomic, assign) NSRange attributeRange;
@property (nonatomic, assign) NSUInteger stringLength;
@property (nonatomic, copy) NSString *attributeName;
@property (nonatomic, strong) id attributeValue;

- (instancetype)with;
- (BOStringAttribute *(^)(NSRange))range;
- (void(^)())stringRange;

@end
