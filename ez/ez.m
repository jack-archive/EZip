//
//  EZip, Awesome File Compression
//  Copyright (c) 2014 Jack Maloney. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "ez.h"
#import "ezutils.h"
#import "bitset.h"
#import "EZEncodeChar.h"

@implementation ez

+(NSData*) compressData:(NSData*)data {
    NSData* rv;

    NSString* s = [ez detectEncoding:data];

    NSCountedSet* cs = [[NSCountedSet alloc] init];

    for (int a = 0; a < s.length; a++) {
        [cs addObject:@([s characterAtIndex:a])];
    }

    NSMutableArray* counts = [[NSMutableArray alloc] initWithCapacity:0];

    for (NSNumber* ch in cs) {
        int freq = (int) [cs countForObject:ch];
        EZEncodeChar* echar = [[EZEncodeChar alloc] init];
        echar.count = freq;
        echar.charc = [ch integerValue];
        [counts addObject:echar];
    }

    NSArray* x = [ez BubbleSortEZEncodeCharArray:counts];

    for (int a = 0; a < x.count; a++) {
        print(@"%d", ((EZEncodeChar*)x[a]).count);
    }

    return rv;
}

+(NSString*) detectEncoding:(NSData*) data {
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (!str) {
        str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if (!str) {
            str = [[NSString alloc] initWithData:data encoding:NSUTF16StringEncoding];
            if (!str) {
                printErr(@"Unable To Detect File Encoding");
            }
        }
    }

    return str;
}

+(NSArray*) BubbleSortEZEncodeCharArray:(NSArray*) arr {
    NSMutableArray* rv = [arr mutableCopy];

    while (true) {
        BOOL hasSorted = NO;
        for (int a = 0; a < rv.count - 1; a++) {
            if (![rv[a] isKindOfClass:[EZEncodeChar class]]) {
                printErr(@"Malformed Array");
                exit(1);
            }

            if (((EZEncodeChar*)rv[a]).count > ((EZEncodeChar*)rv[a + 1]).count) {
                hasSorted = YES;
                EZEncodeChar* item1 = ((EZEncodeChar*)rv[a]);
                EZEncodeChar* item2 = ((EZEncodeChar*)rv[a + 1]);

                [rv replaceObjectAtIndex:a withObject:item2];
                [rv replaceObjectAtIndex:a + 1 withObject:item1];
            }
        }
        if (!hasSorted) {
            break;
        }
    }
    return rv;
}

@end
