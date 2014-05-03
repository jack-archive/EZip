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

#import "ezip.h"

@implementation ezip

@end

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

void printFailure(NSString* x, ...) {
    va_list(f);
    va_start(f, x);

    NSString* r = [NSString stringWithFormat:@"%@✘ %@%@", BOLDRED, x, RESET];

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

