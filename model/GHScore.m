//
//  GHScore.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/16/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHScore.h"
#import "GHCourse.h"
#import "GHPlayer.h"


@implementation GHScore

@dynamic value;
@dynamic date;
@dynamic course;
@dynamic player;


+ (NSString *)entityName {
    return @"Score";
}
+ (NSArray *)defaultSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
}

-(double)differential {
    double dValue = [self.value doubleValue];
    double dRating = [self.course.rating doubleValue];
    int iSlope = [self.course.slope intValue];
    
    double unrounded = (dValue - dRating) * 113.0 / iSlope;
    return roundf( unrounded*10.0)/10.0; // Round to nearest tenth
}

@end
