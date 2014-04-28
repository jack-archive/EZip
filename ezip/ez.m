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
#import "EZBitWriter.h"

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

    print(@"\tBuilding Tree...");
    [tree constructTree];

    print(@"\tGenerating Codes...");
    EZCodeMap* codes = [NSMapTable strongToStrongObjectsMapTable];
    [tree GenerateCodes:((EZNode*) tree.Nodes[0]) toMap:codes currentCode:@""];

    EZBitWriter* bw = [[EZBitWriter alloc] initWithFile:@"./test.ez"];

    for (int a = 0; a < s.length; a++) {
        [bw CompressAndWriteCharacter:[s characterAtIndex:a] WithCoding:codes];
    }

    [bw flush];

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
                exit(1);
            }
        }
    }

    return str;
}

/*#############################################################*/
/*###############   Decompression   ###########################*/
/*#############################################################*/

+(NSData*) decopmpressData:(NSData *)data {
    NSData* rv;

    long OriginalBytes = [data length];

    NSDate* start = [NSDate date];

    return rv;

    
}

@end
