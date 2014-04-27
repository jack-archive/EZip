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

/*
 * Colors For Colorized Terminal Output
 */
static NSString* RESET = @"\033[0m";
static NSString* RED = @"\033[31m";                 /* Red */
static NSString* GREEN = @"\033[32m";               /* Green */
static NSString* BLUE = @"\033[34m";                /* Blue */
static NSString* MAGENTA  = @"\033[35m";            /* Magenta */
static NSString* CYAN = @"\033[36m";                /* Cyan */
static NSString* BOLDRED = @"\033[1m\033[31m";      /* Bold Red */
static NSString* BOLDGREEN = @"\033[1m\033[32m";    /* Bold Green */
static NSString* BOLDYELLOW = @"\033[1m\033[33m";   /* Bold Yellow */
static NSString* BOLDCYAN = @"\033[1m\033[36m";     /* Bold Cyan */
static NSString* BOLDMAGENTA = @"\033[1m\033[35m";  /* Bold Magenta */
static NSString* BOLDBLUE = @"\033[1m\033[34m";     /* Bold Blue */

#define __EZ_VERSION__ "1.0.0-Beta1"

@interface ezutils : NSObject

@end

#ifndef EZ_H_
#define EZ_H_

void print(NSString* x, ...);
void printErr(NSString* x, ...);
void printWarn(NSString* x, ...);
void printInfo(NSString* x, ...);
void printSuccess(NSString* x, ...);
void printUsage();
void printHelp();
void printVersion();
void showLicense();

#endif
