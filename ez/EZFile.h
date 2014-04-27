//
//  EZFile.h
//  ez
//
//  Created by Jack Maloney on 4/27/14.
//  Copyright (c) 2014 Jack Maloney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZBitset.h"

@interface EZFile : NSObject

@property (nonatomic, readonly, strong) NSFileHandle* file;
@property (nonatomic, readonly) bitset bits;
@property (nonatomic, readonly) int count;

@end
