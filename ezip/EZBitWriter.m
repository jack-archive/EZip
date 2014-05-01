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

#import "EZBitWriter.h"
#import "ez.h"
#import "EZBitset.h"
#import "EZTree.h"
#import "EZNode.h"

@interface EZBitWriter ()

@property (nonatomic, readwrite) FILE* file;
@property (nonatomic, readwrite) int position;
@property (nonatomic, readwrite, strong) NSString* current;

@end

@implementation EZBitWriter

-(instancetype) initWithFile:(NSString*) path {
    self = [super init];
    self.file = fopen([path UTF8String], "w");
    self.position = 0;
    self.current = @"";
    return self;
}

-(void) CompressAndWriteCharacter:(char) character WithCoding:(EZCodeMap*) codes {
    NSString* code = [codes objectForKey:@(character)];
    for (int a = 0; a < code.length; a++) {
        if (self.position == 16) {
            [self WriteString:self.current];
            self.position = 0;
            self.current = @"";
        }
        self.current = [self.current stringByAppendingFormat:@"%c", [code characterAtIndex:a]];
        self.position++;
        //print(@"%@\n", self.current);
    }
}

-(void) WriteString:(NSString*) str {
    bitset w = 0;
    for (int a = 0; a < str.length; a++) {
        if ([str characterAtIndex:a] == '0') {
            //Do Nothing
        } else if ([str characterAtIndex:a] == '1') {
            setBit(&w, a);
        } else {
            [NSException raise:@"String Error" format:@"String Does Not Contain All Ones And Zeroes"];
        }
    }
    fprintf(self.file, "%c", w);
}

-(void) flush {
    [self WriteString:self.current];
    self.position = 0;
}

-(void) WriteHeader:(EZTree*) tree sha:(NSString*) sha {
    NSString* header = [NSString stringWithFormat:@"@HEAD\nEZV=%s\nSHA=%@\n@MAP", __EZ_VERSION__, sha];

    for (int a = 0; a < tree.BaseNodes.count; a++) {
        header = [header stringByAppendingFormat:@"%c=%@\n", ((EZNode*)tree.BaseNodes[a]).charc, [tree.Codes objectForKey:@(((EZNode*)tree.BaseNodes[a]).charc)]];
    }

    header = [header stringByAppendingString:@"@END\n"];

    fprintf(self.file, "%s", [header UTF8String]);
}

@end
