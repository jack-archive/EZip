//
//  EZRandom.h
//  ez
//
//  Created by Jack Maloney on 5/1/14.
//  Copyright (c) 2014 Jack Maloney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZSecurity.h"

@interface EZRandom : NSObject

-(instancetype) initWithSeed:(EZCryptoSeed) seed;
-(long int) rand;

@property EZCryptoSeed seed;

@end
