//
//  EZRandom.m
//  ez
//
//  Created by Jack Maloney on 5/1/14.
//  Copyright (c) 2014 Jack Maloney. All rights reserved.
//

#import "EZRandom.h"
#import "EZSecurity.h"

@implementation EZRandom

-(instancetype) initWithSeed:(EZCryptoSeed) seed {
    self = [super init];
    self.seed = seed;
    return self;
}

-(long int) rand {
    long int rv = (((self.seed = 1664525 * self.seed + 1013904223) >> 16) / (float) 0x10000);

    if (rv > 0) {
        return rv;
    } else {
        return (rv * -1);
    }

    return rv;
}

@end
