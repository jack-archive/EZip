//
//  bitset.c
//  ez
//
//  Created by Jack Maloney on 4/26/14.
//  Copyright (c) 2014 Jack Maloney. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include "bitset.h"

void setBit(bitset* set, int i) {
    switch (i) {
        case 0:
            *set = *set | BIT_00_1;
            return;
        case 1:
            *set = *set | BIT_01_1;
            return;
        case 2:
            *set = *set | BIT_02_1;
            return;
        case 3:
            *set = *set | BIT_03_1;
            return;
        case 4:
            *set = *set | BIT_04_1;
            return;
        case 5:
            *set = *set | BIT_05_1;
            return;
        case 6:
            *set = *set | BIT_06_1;
            return;
        case 7:
            *set = *set | BIT_07_1;
            return;
        case 8:
            *set = *set | BIT_08_1;
            return;
        case 9:
            *set = *set | BIT_09_1;
            return;
        case 10:
            *set = *set | BIT_10_1;
            return;
        case 11:
            *set = *set | BIT_11_1;
            return;
        case 12:
            *set = *set | BIT_12_1;
            return;
        case 13:
            *set = *set | BIT_13_1;
            return;
        case 14:
            *set = *set | BIT_14_1;
            return;
        case 15:
            *set = *set | BIT_15_1;
            return;
        default:
            fprintf(stderr, "setBit error, passed integer is not valid");
            exit(1);
            break;
    }
}

void unsetBit(bitset* set, int i) {
    switch (i) {
        case 0:
            *set = *set & BIT_00_0;
            return;
        case 1:
            *set = *set & BIT_01_0;
            return;
        case 2:
            *set = *set & BIT_02_0;
            return;
        case 3:
            *set = *set & BIT_03_0;
            return;
        case 4:
            *set = *set & BIT_04_0;
            return;
        case 5:
            *set = *set & BIT_05_0;
            return;
        case 6:
            *set = *set & BIT_06_0;
            return;
        case 7:
            *set = *set & BIT_07_0;
            return;
        case 8:
            *set = *set & BIT_08_0;
            return;
        case 9:
            *set = *set & BIT_09_0;
            return;
        case 10:
            *set = *set & BIT_10_0;
            return;
        case 11:
            *set = *set & BIT_11_0;
            return;
        case 12:
            *set = *set & BIT_12_0;
            return;
        case 13:
            *set = *set & BIT_13_0;
            return;
        case 14:
            *set = *set & BIT_14_0;
            return;
        case 15:
            *set = *set & BIT_15_0;
            return;
        default:
            fprintf(stderr, "setBit error, passed integer is not valid");
            exit(1);
            break;
    }
}
