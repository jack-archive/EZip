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

typedef unsigned short int bitset;

#define BIT_00_1 32768
#define BIT_01_1 16384
#define BIT_02_1 8192
#define BIT_03_1 4096
#define BIT_04_1 2048
#define BIT_05_1 1024
#define BIT_06_1 512
#define BIT_07_1 256
#define BIT_08_1 128
#define BIT_09_1 64
#define BIT_10_1 32
#define BIT_11_1 16
#define BIT_12_1 8
#define BIT_13_1 4
#define BIT_14_1 2
#define BIT_15_1 1

#define BIT_00_0 32767
#define BIT_01_0 49151
#define BIT_02_0 57343
#define BIT_03_0 61439
#define BIT_04_0 63487
#define BIT_05_0 64511
#define BIT_06_0 65023
#define BIT_07_0 65279
#define BIT_08_0 65407
#define BIT_09_0 65471
#define BIT_10_0 65503
#define BIT_11_0 65519
#define BIT_12_0 65527
#define BIT_13_0 65531
#define BIT_14_0 65533
#define BIT_15_0 65534

#ifndef ez_bitset_h
#define ez_bitset_h

void setBit(bitset* set, int i);
void unsetBit(bitset* set, int i);

#endif

@interface EZBitset : NSObject

@end