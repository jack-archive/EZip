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
#import "EZTree.h"
#import "EZCodedCharacter.h"

@implementation ez

+(NSData*) compressData:(NSData*)data {
    NSData* rv;

    long OriginalBytes = [data length];

    NSDate* start = [NSDate date];

    NSString* s = [ez detectEncoding:data];

    NSCountedSet* cs = [[NSCountedSet alloc] init];

    for (int a = 0; a < s.length; a++) {
        [cs addObject:@([s characterAtIndex:a])];
    }

    EZTree* tree = [[EZTree alloc] init];

    for (NSNumber* ch in cs) {
        int freq = (int) [cs countForObject:ch];
        EZNode* echar = [[EZNode alloc] init];
        echar.count = freq;
        echar.charc = [ch integerValue];
        [tree addNode:echar];
    }

    print(@"\tBuilding Codes...");
    [tree constructTree];

    NSMutableArray* codes = [[NSMutableArray alloc] init];
    [tree GenerateCodes:((EZNode*) tree.Nodes[0]) toArray:codes currentCode:@""];

    for (int a = 0; a < codes.count; a++) {
        print(@"{%c, %@}", ((EZCodedCharacter*)codes[a]).character, ((EZCodedCharacter*)codes[a]).code);
    }

    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    timeInterval = timeInterval - (timeInterval * 2);
    printInfo(@"Compressed %d Bytes in %f Seconds", OriginalBytes, timeInterval);

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

@end
