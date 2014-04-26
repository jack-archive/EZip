//
//  hfzutls.m
//  hfz
//
//  Created by Jack Maloney on 4/26/14.
//  Copyright (c) 2014 Jack Maloney. All rights reserved.
//

#import "hfzutls.h"

@implementation hfzutls

@end


void print_core(BOOL err, NSString* x, va_list f) {
    NSString* s = [[NSString alloc] initWithFormat:x arguments:f];
    if (err) {
        fprintf(stderr, "%s\n", [s UTF8String]);
    } else {
        printf("%s\n", [s UTF8String]);
    }
}

void print(NSString* x, ...) {
    va_list(f);
    va_start(f, x);
    
    print_core(NO, x, f);
    
    va_end(f);
}
