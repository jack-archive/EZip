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
#import <CommonCrypto/CommonDigest.h>

@implementation ez

+(void) compressFile:(NSString*) path {
    NSDate* start = [NSDate date];

    printInfo(@"Compressing file at %@\n", path);
    printf("\tIndexing File... ");
    fflush(stdout);

    NSString* sha = [ez getSHAFromFile:path];

    NSData* data = [NSData dataWithContentsOfFile:path];

    long OriginalBytes = [data length];

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
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    timeInterval = timeInterval - (timeInterval * 2);
    printf("%f\n", timeInterval);

    NSDate* td = [NSDate date];
    printf("\tBuilding Tree... ");
    fflush(stdout);
    [tree constructTree];
    timeInterval = [td timeIntervalSinceNow];
    timeInterval = timeInterval - (timeInterval * 2);
    printf("%f\n", timeInterval);

    td = [NSDate date];
    printf("\tGenerating Codes... ");
    fflush(stdout);
    EZCodeMap* codes = [NSMapTable strongToStrongObjectsMapTable];
    [tree GenerateCodes:((EZNode*) tree.Nodes[0]) toMap:codes currentCode:@""];
    timeInterval = [td timeIntervalSinceNow];
    timeInterval = timeInterval - (timeInterval * 2);
    printf("%f\n", timeInterval);

    td = [NSDate date];
    printf("\tCompressing... ");
    fflush(stdout);
    EZBitWriter* bw = [[EZBitWriter alloc] initWithFile:@"./test.ez"];

    [bw WriteHeader:tree sha:sha];

    for (int a = 0; a < s.length; a++) {
        [bw CompressAndWriteCharacter:[s characterAtIndex:a] WithCoding:codes];
    }

    [bw flush];

    timeInterval = [td timeIntervalSinceNow];
    timeInterval = timeInterval - (timeInterval * 2);
    printf("%f\n", timeInterval);

    timeInterval = [start timeIntervalSinceNow];
    timeInterval = timeInterval - (timeInterval * 2);
    printInfo(@"Compressed %d Bytes in %f Seconds\n", OriginalBytes, timeInterval);
}

+(NSString*) detectEncoding:(NSData*) data {
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (!str) {
        str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if (!str) {
            str = [[NSString alloc] initWithData:data encoding:NSUTF16StringEncoding];
            if (!str) {
                printErr(@"Unable To Detect File Encoding\n");
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

+(NSString*) getSHAFromFile:(NSString*) path {
    NSTask* sha = [[NSTask alloc] init];
    [sha setLaunchPath:@"/usr/bin/shasum"];
    [sha setArguments:@[@"--algorithm", @"256", path]];

    NSFileManager* fm = [[NSFileManager alloc] init];
    [sha setCurrentDirectoryPath:[fm currentDirectoryPath]];

    NSPipe* pipe = [NSPipe pipe];
    [sha setStandardOutput:pipe];

    [sha launch];

    NSFileHandle* file = [pipe fileHandleForReading];
    NSData* data = [file readDataToEndOfFile];

    NSString* rv = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];

    NSArray* x = [rv componentsSeparatedByString:@"  "];
    rv = ((NSString*) x[0]);

    return rv;
}

@end
