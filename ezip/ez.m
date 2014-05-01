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
#import "EZTree.h"
#import "EZBitWriter.h"
#import "EZOperationTimer.h"
#import "EZBitReader.h"

@implementation ez

+(void) compressFile:(NSString*) path {
    EZOperationTimer* start = [[EZOperationTimer alloc] init];
    EZOperationTimer* time = [[EZOperationTimer alloc] init];
    [start start];
    [time start];

    printInfo(@"Compressing file at %@\n", path);
    print(@"\tIndexing File... ");

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
    print(@"%f Sec\n", [time time]);

    print(@"\tBuilding Tree... ");
    [tree constructTree];
    print(@"%f Sec\n", [time time]);

    print(@"\tGenerating Codes... ");
    EZCodeMap* codes = [NSMapTable strongToStrongObjectsMapTable];
    [tree GenerateCodes:((EZNode*) tree.Nodes[0]) toMap:codes currentCode:@""];
    print(@"%f Sec\n", [time time]);

    print(@"\tCompressing... ");
    EZBitWriter* bw = [[EZBitWriter alloc] initWithFile:@"./test.ez"];

    [bw WriteHeader:tree sha:sha];

    for (int a = 0; a < s.length; a++) {
        [bw CompressAndWriteCharacter:[s characterAtIndex:a] WithCoding:codes];
    }

    [bw flush];

    print(@"%f Sec\n", [time time]);

    printInfo(@"Compressed %d Bytes in %f Seconds\n", OriginalBytes, [start time]);
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

+(void) decompressFile:(NSString *)path {
    EZOperationTimer* start = [[EZOperationTimer alloc] init];
    EZOperationTimer* time = [[EZOperationTimer alloc] init];
    [start start];
    [time start];

    printInfo(@"Decompressing file at %@\n", path);

    NSString* sha;

    NSString* outpath;

    NSData* data = [NSData dataWithContentsOfFile:path];

    EZCodeMap* codes = [[NSMapTable alloc] init];

    long OriginalBytes = [data length];

    NSString* s = [ez detectEncoding:data];

    if (![s hasPrefix:@"@HEAD"]) {
        printErr(@"Malformed File");
    }

    print(@"\tIndexing File... ");

    NSArray* file = [((NSString*)s) componentsSeparatedByString:@"@END"];

    NSArray* header = [((NSString*)file[0]) componentsSeparatedByString:@"@MAP"];

    NSArray* map = [((NSString*)header[1]) componentsSeparatedByString:@"="];

    // Parse Codes From File
    for (int a = 0; a < map.count; a = a + 2) {
        [codes setObject:map[a] forKey:map[a + 1]];
    }

    header = [((NSString*)header[0]) componentsSeparatedByString:@"\n"];

    for (int a = 0; a < header.count; a++) {
        if ([((NSString*)header[a]) hasPrefix:@"SHA"]) {
            NSArray* shacmps = [((NSString*)header[a]) componentsSeparatedByString:@"="];
            sha = shacmps[1];
        }
    }

    print(@"%f Sec\n", [time time]);

    // Prints a warning if it could not find the sha hash
    if (!sha) {
        printWarn(@"No hash found in the file at %@, unable to check hash on decrypted file\n", path);
    }

    EZBitReader* reader = [[EZBitReader alloc] initWithPath:path];
    


    printInfo(@"Decompressed %d Bytes in %f Seconds\n", OriginalBytes, [start time]);
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

// #########################################################
// C METHODS ###############################################
// #########################################################

void print_core(BOOL err, NSString* x, va_list f) {

    NSString* s = [[NSString alloc] initWithFormat:x arguments:f];

    if (err) {
        fprintf(stderr, "%s", [s UTF8String]);
        fflush(stderr);
    } else {
        printf("%s", [s UTF8String]);
        fflush(stdout);
    }
}

void print(NSString* x, ...) {
    va_list(f);
    va_start(f, x);

    print_core(NO, x, f);

    va_end(f);
}

void printErr(NSString* x, ...) {
    va_list(f);
    va_start(f, x);

    NSString* r = [NSString stringWithFormat:@"%@Error:%@ %@", BOLDRED, RESET, x];

    print_core(YES, r, f);

    va_end(f);
}

void printWarn(NSString* x, ...) {
    va_list(f);
    va_start(f, x);

    NSString* r = [NSString stringWithFormat:@"%@Warning:%@ %@", BOLDYELLOW, RESET, x];

    print_core(YES, r, f);

    va_end(f);
}

void printInfo(NSString* x, ...) {
    va_list(f);
    va_start(f, x);

    NSString* r = [NSString stringWithFormat:@"%@%@%@", BOLDCYAN, x, RESET];

    print_core(NO, r, f);

    va_end(f);
}

void printSuccess(NSString* x, ...) {
    va_list(f);
    va_start(f, x);

    NSString* r = [NSString stringWithFormat:@"%@✔︎ %@%@", BOLDGREEN, x, RESET];

    print_core(NO, r, f);

    va_end(f);
}

void printUsage() {
    print(@"Usage: \tez [-lhv] \n\tez [-cx] arguments ...\n");
    print(@"Type ez --help for more help");
}

void printHelp() {

}

void printVersion() {
    print(@"EZip Version: %s\n", __EZ_VERSION__);
    print(@"Built On: %s at %s\n", __DATE__, __TIME__);
    print(@"\nCopyright (c) 2014 Jack Maloney\n");

    print(@"\nThis program is free software: you can redistribute it and/or modify\n");
    print(@"it under the terms of the GNU General Public License as published by\n");
    print(@"the Free Software Foundation, either version 3 of the License, or\n");
    print(@"(at your option) any later version.\n\n");

    print(@"This program is distributed in the hope that it will be useful,\n");
    print(@"but WITHOUT ANY WARRANTY; without even the implied warranty of\n");
    print(@"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n");
    print(@"GNU General Public License for more details.\n");
}

void showLicense() {
    
}

@end
