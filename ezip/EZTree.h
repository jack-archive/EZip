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

#import <Foundation/Foundation.h>
#import "EZNode.h"
#import "ez.h"

@interface EZTree : NSObject

@property (nonatomic, readonly, strong) NSMutableArray* BaseNodes;
@property (nonatomic, readonly, strong) NSMutableArray* Nodes;

/*  Tells the program when the node array has been modified */
@property (nonatomic, readonly) BOOL modified;
@property (nonatomic, readonly, strong) NSMapTable* Codes;

-(void) constructTree;
-(void) addNode:(EZNode*) node;
-(void) GenerateCodes:(EZNode*) node toMap:(EZCodeMap*)map currentCode:(NSString*) code;

@end
