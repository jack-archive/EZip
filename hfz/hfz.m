//
//  hfz.m
//  hfz
//
//  Created by Jack Maloney on 4/26/14.
//  Copyright (c) 2014 Jack Maloney. All rights reserved.
//

#import "hfz.h"
#import "hfzutls.h"

@implementation hfz

+(NSData*) compressData:(NSData *)x {
    NSData* rv;

    NSString* utfx = [[NSString alloc] initWithData:x encoding:NSUTF8StringEncoding];

    char chars[1];
    int count[1];
    int c;

    print(@"%@\n", utfx);

    for (int a = 0; a < utfx.length; a++) {
        BOOL exists = NO;
        for (int b = 0; b < c; b++) {
            print(@"%c = %c", chars[b], [utfx characterAtIndex:a]);
            if (chars[b] == [utfx characterAtIndex:a]) {
                exists = YES;
                int f = count[b];
                f++;
                print(@"f: %d", f);
                count[b] = f;
            }
        }

        if (!exists) {
            print(@"!exists");
            char tmp[c + 1];
            tmp[c + 1] = [utfx characterAtIndex:a];
            int tmp2[c + 1];
            tmp2[c + 1] = 1;
            c++;
        }

    }

    return rv;
}

@end
