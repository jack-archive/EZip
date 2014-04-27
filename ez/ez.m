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
        print(@"%@", ch);
        [counts addObject:echar];
    }

    [self BubbleSort:counts];

    for (int a = 0; a < counts.count; a++) {
        print(@"%c, %d", ((EZEncodeChar*)counts[a]).charc, ((EZEncodeChar*)counts[a]).count);
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

+(NSArray*) BubbleSort:(NSArray*) arr {
    NSMutableArray* rv = [arr mutableCopy];

        while (TRUE) {

            BOOL hasSwapped = NO;

            for (int i=0; i < arr.count; i++){

                /** out of bounds check */
                if (i < arr.count - 1){

                    if (![arr[i] isKindOfClass:[EZEncodeChar class]]) {
                        printErr(@"Malformed Array For Bubblesorting");
                    }

                    NSUInteger currentIndexValue = ((EZEncodeChar*)arr[i+1]).count;
                    NSUInteger nextIndexValue    = ((EZEncodeChar*)arr[i+1]).count;

                    if (currentIndexValue > nextIndexValue){
                        hasSwapped = YES;
                        [self swapFirstIndex:i withSecondIndex:i+1 inMutableArray:arr];
                    }
                }

            }

            /** already sorted, break out of the while loop */
            if (!hasSwapped){
                break;
            }
            
        }

    return rv;
}

+(void)swapFirstIndex:(NSUInteger)firstIndex withSecondIndex:(NSUInteger)secondIndex inMutableArray:(NSMutableArray*)array{

    NSNumber* valueAtFirstIndex = array[firstIndex];
    NSNumber* valueAtSecondIndex = array[secondIndex];

    [array replaceObjectAtIndex:firstIndex withObject:valueAtSecondIndex];
    [array replaceObjectAtIndex:secondIndex withObject:valueAtFirstIndex];
}

@end
