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

#import "EZTree.h"
#import "EZNode.h"
#import "ezip.h"
#import "EZBitset.h"

@interface EZTree()

@property (nonatomic, readwrite, strong) NSMutableArray* BaseNodes;
@property (nonatomic, readwrite, strong) NSMutableArray* Nodes;
@property (nonatomic, readwrite) BOOL modified;
@property (nonatomic, readwrite, strong) NSMapTable* Codes;

@end

@implementation EZTree

-(instancetype) init {
    self = [super init];
    self.BaseNodes = [[NSMutableArray alloc] init];
    self.modified = NO;
    return self;
}

-(void) addNode:(EZNode*) node {
    if ([node isKindOfClass:[EZNode class]]) {
        [self.BaseNodes insertObject:node atIndex:0];
        self.modified = YES;
    }
}

-(void) constructTree {

    NSMutableArray* arr = [self.BaseNodes mutableCopy];

    arr = [EZTree sortEZNodeArray:arr];

    for (int a = 0; a < arr.count; a++) {
        //print(@"%c\n", ((EZNode*)arr[a]).charc);
    }

    for (int a = 0; a < arr.count; a++) {
        ((EZNode*)arr[a]).isLeaf = YES;
    }

    while (arr.count > 1) {
        EZNode* node1 = arr[0];
        EZNode* node2 = arr[1];
        EZNode* node3 = [[EZNode alloc] init];

        node1.parent = node3;
        node2.parent = node3;
        node3.rightChild = node2;
        node3.leftChild = node1;

        node3.count = node2.count + node1.count;

        [arr removeObject:node1];
        [arr removeObject:node2];

        [arr addObject:node3];

        arr = [EZTree sortEZNodeArray:arr];

        //print(@"After Sorting\n%@\n", arr);
    }
    self.Nodes = arr;
    self.modified = NO;
}

-(void) GenerateCodes:(EZNode*) node toMap:(EZCodeMap*)map currentCode:(NSString*) code {
    if (self.modified) {
        [self constructTree];
    }

    if (node.isLeaf) {

        bitset w = 0;

        // Convert string code to bitset
        for (int a = 0; a < code.length; a++) {
            if ([code characterAtIndex:a] == '0') {
                //Do Nothing
            } else if ([code characterAtIndex:a] == '1') {
                setBit(&w, a);
            } else {
                [NSException raise:@"String Error" format:@"String Does Not Contain All Ones And Zeroes"];
            }
        }

        print(@"%@, %d, %c\n", code, w, node.charc);

        [map setObject:@(w) forKey:@(node.charc)];
    } else {
        if (node.leftChild) {
            [self GenerateCodes:node.leftChild toMap:map currentCode:[code stringByAppendingString:@"0"]];
        }

        if (node.rightChild) {
            [self GenerateCodes:node.rightChild toMap:map currentCode:[code stringByAppendingString:@"1"]];
        }
    }
    self.Codes = map;
}

+(NSMutableArray*) sortEZNodeArray:(NSArray*) arr {

    NSMutableArray* rv = [arr mutableCopy];

    while (true) {
        BOOL hasSorted = NO;
        for (int a = 0; a < rv.count - 1; a++) {
            if (![rv[a] isKindOfClass:[EZNode class]]) {
                [NSException raise:@"Malformed Array" format:@"Not all elements are of type EZNode"];
            }

            if (((EZNode*)rv[a]).count > ((EZNode*)rv[a + 1]).count) {
                hasSorted = YES;
                id item1 = rv[a];
                id item2 = rv[a + 1];

                //print(@"%d is greater than %d\n", ((EZNode*)rv[a]).count, ((EZNode*)rv[a + 1]).count);

                [rv replaceObjectAtIndex:a withObject:item2];
                [rv replaceObjectAtIndex:a + 1 withObject:item1];
            } else {
                //print(@"%d is less than %d\n", ((EZNode*)rv[a]).count, ((EZNode*)rv[a + 1]).count);
            }

            //print(@"%@\n", rv);
        }
        if (!hasSorted) {
            break;
        }
    }

    return rv;
}

@end
