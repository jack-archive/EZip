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
#import "ezutils.h"
#import "ez.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {

        if (argc < 2) {
            printUsage();
            exit(1);
        }

        NSString* arg = [NSString stringWithUTF8String:argv[1]];

        if ([@"-h" isEqualToString:arg] || [@"--help" isEqualToString:arg]) {
            printHelp();
        } else if ([@"-v" isEqualToString:arg] || [@"--version" isEqualToString:arg]) {
            printVersion();
        } else if ([@"-l" isEqualToString:arg]) {
            showLicense();
        } else if ([@"-c" isEqualToString:arg]) {
            // Create Archive

            if (argc < 3) {
                printErr(@"-c Requires An Argument");
                exit(1);
            }

            NSData* data = [NSData dataWithContentsOfFile:[NSString stringWithUTF8String:argv[2]]];

            print(@"Compressing file at %@ ", [NSString stringWithUTF8String:argv[2]]);

            [ez compressData:data];

        } else if ([@"-x" isEqualToString:arg]) {
            // Extract Archive
        } else {
            printErr(@"Arguments Are Invalid");
        }
        
    }
    return 0;
}

