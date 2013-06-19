//
//  GHPrintFormmater.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/18/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHCourse.h"
#import "GHLeague.h"

@interface GHPrintFormmater : NSObject

-(NSString*)printableHtmlForData:(NSArray*)array league:(GHLeague*)league andCourse:(GHCourse*)course;

@end
