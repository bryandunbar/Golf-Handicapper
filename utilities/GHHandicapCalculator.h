//
//  GHHandicapCalculator.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/17/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHPlayer.h"
#import "GHCourse.h"
@interface GHHandicapCalculator : NSObject

-(double)handicapIndexForScores:(NSArray*)scores;
-(int)courseHandicapForHandicap:(double)handicapIndex forCourse:(GHCourse*)course;

@end