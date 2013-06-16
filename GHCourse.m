//
//  GHCourse.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHCourse.h"


@implementation GHCourse

@dynamic name;
@dynamic abbreviation;
@dynamic slope;
@dynamic rating;
@dynamic tees;


+ (NSString *)entityName {
	return @"Course";
}


+ (NSArray *)defaultSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
}
@end
