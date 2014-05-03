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

#import "EZCompressor.h"
#import "ezip.h"
#import "EZTree.h"
#import "EZNode.h"
#import "EZOperationTimer.h"

@interface EZCompressor ()
@property (readwrite, nonatomic, strong) NSString* path;
@property (readwrite, nonatomic) FILE* file;
@end

@implementation EZCompressor

// Initalizes a new EZCompressor
-(instancetype) initWithInFile:(NSString*) path {
    self = [super init];
    self.path = path;
    self.file = fopen([self.path UTF8String], "r");
    return self;
}

// Returns nil because it is not the correct init method
-(instancetype) init {
    return nil;
}

// Compresses the file at self.path
-(void) compress {

    EZOperationTimer* start = [[EZOperationTimer alloc] init];
    EZOperationTimer* time = [[EZOperationTimer alloc] init];
    [start start];
    [time start];

    printInfo(@"Compressing File At %@ to %@\n", self.path, [self calculateOutFileName]);
    print(@"\tIndexing File... ");

    // Stores the frequencies of each character
    NSCountedSet* frequencies = [[NSCountedSet alloc] init];

    fseek(self.file, 0L, SEEK_END);
    long length = ftell(self.file);
    fseek(self.file, 0L, SEEK_SET);

    // reads the file and parses each character, then adds it to frequencies
    char b;
    b = fgetc(self.file);
    while (b != EOF) {
        [frequencies addObject:@((char) b)];
        b = fgetc(self.file);
    }

    EZTree* tree = [[EZTree alloc] init];

    // Adds the characters and their frequencies from the NSCountedSet to the EZTree
    for (NSNumber* ch in frequencies) {
        int freq = (int) [frequencies countForObject:ch];
        EZNode* echar = [[EZNode alloc] init];
        echar.count = freq;
        //print(@"%d, %c\n", echar.count, [ch integerValue]);
        echar.charc = [ch integerValue];
        [tree addNode:echar];
    }

    print(@"Done In %.5f Sec\n", [time time]);

    int outlength = 0;

    // Constructs the tree upon which the codes are based off of
    [tree constructTree];

    EZCodeMap* codes = [[NSMapTable alloc] init];

    print(@"%@", ((EZNode*)tree.Nodes[0]));

    [tree GenerateCodes:((EZNode*)tree.Nodes[0]) toMap:codes currentCode:@""];

    printSuccess(@"Successfully Compressed %ld Bytes To %d Bytes\n", length, outlength);
}

// Parses self.path to generate a file name
-(NSString*) calculateOutFileName {
    NSArray* parts = [self.path componentsSeparatedByString:@"/"];
    NSString* rv = ((NSString*) parts[parts.count - 1]);
    rv = [rv stringByAppendingString:@".ez"];
    return rv;
}

@end
