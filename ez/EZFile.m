//
//  EZFile.m
//  ez
//
//  Created by Jack Maloney on 4/27/14.
//  Copyright (c) 2014 Jack Maloney. All rights reserved.
//

#import "EZFile.h"
#import "ezutils.h"

@interface EZFile ()
@property (nonatomic, readwrite, strong) NSFileHandle* file;
@property (nonatomic, readwrite) bitset bits;
@property (nonatomic, readwrite) int count;
@end

@implementation EZFile

-(void) writeBits:(NSString*) bits {
    bitset wbits = 0;
    for (int a = 0; a < bits.length; a++) {
        if ([bits characterAtIndex:a] == '0') {
        } else if ([bits characterAtIndex:a] == '1') {
            setBit(&wbits, a);
        } else {
            printErr(@"Error in parsing bits");
            exit(1);
        }
    }
}

@end
